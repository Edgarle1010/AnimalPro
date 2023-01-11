//
//  AuthenticationFirebaseDatasource.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

final class AuthenticationFirebaseDatasource: NSObject {
    let session: SessionAppService = .shared
    let facebookAuthentication = FacebookAuthentication()
    let phoneAuthentication = PhoneAuthentication()
    let firebaseAuth = Auth.auth()
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
                Task {
                    do {
                        let result = try await firebaseAuth.signIn(with: credential)
                        session.setUser(user: .init(email: result.user.email ?? ""), loggedBy: .apple)
                        await updateDisplayName(for: result.user, with: appleIDCredential)
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func loginWithFacebook() async throws -> UserModel {
        do {
            let accessToken = try await facebookAuthentication.loginFacebook()
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            let authDataResult = try await firebaseAuth.signIn(with: credential)
            let email = authDataResult.user.email ?? "No email"
            return .init(email: email)
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
            let email = authDataResult.user.email ?? "No email"
            return .init(email: email)
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
            // current user is non-empty, don't overwrite it
        } else {
            let changeRequest = user.createProfileChangeRequest()
            do {
                try await changeRequest.commitChanges()
                //session.user?.displayName = Auth.auth().currentUser?.displayName ?? ""
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
}
