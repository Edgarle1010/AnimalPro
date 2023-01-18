//
//  AuthenticationFirebaseDatasource.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import AuthenticationServices
import CryptoKit

final class AuthenticationFirebaseDatasource {
    let session: SessionAppService = .shared
    let facebookAuthentication = FacebookAuthentication()
    let phoneAuthentication = PhoneAuthentication()
    let emailAuthentication = EmailAuthentication()
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    var authStateHandler: AuthStateDidChangeListenerHandle?
    
    fileprivate var currentNonce: String?
    fileprivate var errorMessage: String?
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identy token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serilise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                do {
                    let authDataResult = try await firebaseAuth.signIn(with: credential)
                    let uid = authDataResult.user.uid
                    let email = authDataResult.user.email
                    let user = UserModel(uid: uid, email: email, loginType: .apple, isActive: true)
                    let authUser = try await validateUser(user)
                    await updateDisplayName(for: authDataResult.user, with: appleIDCredential)
                    session.setUser(user: authUser, loggedBy: .apple)
                    session.set(true, forKey: .loggedSuccess)
                } catch {
                    print("Error authenticating: \(error.localizedDescription)")
                    throw error
                }
            }
        }
    }
    
    func loginWithFacebook() async throws -> UserModel {
        do {
            let accessToken = try await facebookAuthentication.loginFacebook()
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            let authDataResult = try await firebaseAuth.signIn(with: credential)
            let uid = authDataResult.user.uid
            let email = authDataResult.user.email
            let user = UserModel(uid: uid, email: email, loginType: .facebook, isActive: true)
            return try await validateUser(user)
        } catch {
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getVerificationID(phoneNumber: String) async throws -> String {
        do {
            return try await phoneAuthentication.getVerificationID(phoneNumber: phoneNumber)
        } catch {
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func verifyPhoneCode(verificationCode: String) async throws -> UserModel {
        let verificationID = session.getString(forKey: .authVerificationID)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: verificationCode)
        
        do {
            let authDataResult = try await firebaseAuth.signIn(with: credential)
            let uid = authDataResult.user.uid
            let email = authDataResult.user.email
            let phone = authDataResult.user.phoneNumber
            let user = UserModel(uid: uid, email: email, phoneNumber: phone, loginType: .phone, isActive: true)
            return try await validateUser(user)
        } catch {
            throw error
        }
    }
    
    func verifyPhoneCodeToLink(verificationCode: String) async throws {
        let verificationID = session.getString(forKey: .authVerificationID)
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID ?? "", verificationCode: verificationCode)
        
        do {
            try await firebaseAuth.currentUser?.link(with: credential)
            try await savePhoneNumber()
        } catch {
            throw error
        }
    }
    
    func sendSignInLink(email: String) async throws {
        do {
            _ = try await emailAuthentication.sendSignInLink(email: email)
        } catch {
            throw error
        }
    }
    
    func passwordlessSignIn(email: String, link: String) async throws -> UserModel {
        do {
            let authDataResult = try await firebaseAuth.signIn(withEmail: email, link: link)
            let uid = authDataResult.user.uid
            let email = authDataResult.user.email
            let user = UserModel(uid: uid, email: email, loginType: .email, isActive: true)
            return try await validateUser(user)
        } catch {
            throw error
        }
    }
    
    func signInAnonymously() async throws -> UserModel {
        do {
            let authDataResult = try await firebaseAuth.signInAnonymously()
            let uid = authDataResult.user.uid
            let user = UserModel(uid: uid, loginType: .guest, isActive: true)
            return user
        } catch {
            throw error
        }
    }
    
    func signOut() async throws {
        do {
            try firebaseAuth.signOut()
        } catch {
            print("Error signing out: %@", error)
            throw error
        }
    }
    
    // MARK: - PRIVATE
    
    private func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener({ auth, user in
                //self.user = user
                //self.authenticationState = user == nil ? .unauthenticated : .authenticated
                //self.displayName = user?.displayName ?? user?.email ?? ""
            })
        }
    }
    
    private func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
        } else {
            let changeRequest = user.createProfileChangeRequest()
            do {
                try await changeRequest.commitChanges()
            } catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    // MARK: - FIRESTORE
    
    func validateUser(_ user: UserModel) async throws -> UserModel {
        if try await isActive(uid: user.uid) {
            try await createUser(user: user
            return user
        } else {
            throw "Tu usuario se encuentra deshabilitado. Por favor, contacta a soporte para revisar tu caso."
        }
    }
    
    func createUser(user: UserModel) async throws {
        let docRef = db.collection("users").document(user.uid)
        
        do {
            try docRef.setData(from: user)
        } catch {
            throw error
        }
    }
    
    func isActive(uid: String) async throws -> Bool {
        let docRef = db.collection("users").document(uid)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let data = document.data()
                if let data = data {
                    return data["isActive"] as? Bool ?? true
                }
            }
            return true
        } catch {
            throw error
        }
    }
    
    func findPhoneNumber(phoneNumber: String) async throws -> Bool {
        let docRef = db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber)
        
        do {
            let querySnapshot = try await docRef.getDocuments()
            for _ in querySnapshot.documents {
                return true
            }
            return false
        } catch {
            throw error
        }
    }
    
    func savePhoneNumber() async throws {
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        do {
            try await docRef.updateData(["phoneNumber": firebaseAuth.currentUser?.phoneNumber ?? ""])
        } catch {
            throw error
        }
    }
}
