//
//  AuthViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation
import AuthenticationServices

protocol AuthViewModelProtocol: ObservableObject {
    var isLoading: Bool { get set }
    var showEmailView: Bool { get set }
    var showPhoneView: Bool { get set }
    var session: SessionAppService { get }
    var authenticationRepository: AuthenticationRepository { get }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws
    func loginFacebook() async throws
    func getVerificationID(phoneNumber: String) async throws
    func verifyPhoneCode(verificationCode: String) async throws
    func verifyPhoneCodeToLink(verificationCode: String) async throws
    func sendSignInLink(email: String) async throws
    func passwordlessSignIn(email: String, link: String) async throws
    func signInAnonymously() async throws
    func signOut() async throws
}

class AuthViewModel: AuthViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var showEmailView: Bool = false
    @Published var showPhoneView: Bool = false
    @Published var showDataProfile: Bool = false
    
    let session: SessionAppService = .shared
    let authenticationRepository = AuthenticationRepository(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource())
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationRepository.handleSignInWithAppleRequest(request)
    }
    
    @MainActor
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws {
        isLoading = true
        do {
            try await authenticationRepository.handleSignInWithAppleCompletion(result)
            isLoading = false
        } catch {
            print("loginAppleError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func loginFacebook() async throws {
        isLoading = true
        do {
            let user = try await authenticationRepository.loginFacebook()
            session.setUser(user: user, loggedBy: .facebook)
            session.set(true, forKey: .loggedSuccess)
            isLoading = false
        } catch {
            print("loginFacebookError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func getVerificationID(phoneNumber: String) async throws {
        isLoading = true
        do {
            let verificationID = try await authenticationRepository.getVerificationID(phoneNumber: phoneNumber)
            session.set(verificationID, forKey: .authVerificationID)
            isLoading = false
        } catch {
            print("gettingVerificationIDError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func verifyPhoneCode(verificationCode: String) async throws {
        isLoading = true
        do {
            let user = try await authenticationRepository.verifyPhoneCode(verificationCode: verificationCode)
            session.setUser(user: user, loggedBy: .phone)
            session.set(true, forKey: .loggedSuccess)
            isLoading = false
        } catch {
            print("gettingVerifyPhoneCodeError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func verifyPhoneCodeToLink(verificationCode: String) async throws {
        isLoading = true
        do {
            try await authenticationRepository.verifyPhoneCodeToLink(verificationCode: verificationCode)
            showDataProfile.toggle()
            isLoading = false
        } catch {
            print("gettingVerifyPhoneCodeToLinkError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func sendSignInLink(email: String) async throws {
        isLoading = true
        do {
            try await authenticationRepository.sendSignInLink(email: email)
            isLoading = false
        } catch {
            print("sendSignInLinkError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func passwordlessSignIn(email: String, link: String) async throws {
        isLoading = true
        do {
            let user = try await authenticationRepository.passwordlessSignIn(email: email, link: link)
            session.setUser(user: user, loggedBy: .email)
            session.set(true, forKey: .loggedSuccess)
            isLoading = false
        } catch {
            print("passwordlessSignInError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func signInAnonymously() async throws {
        isLoading = true
        do {
            let user = try await authenticationRepository.signInAnonymously()
            session.setUser(user: user, loggedBy: .email)
            session.set(true, forKey: .loggedSuccess)
            isLoading = false
        } catch {
            print("signInAnonymouslyError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func signOut() async throws {
        isLoading = true
        do {
            try await authenticationRepository.singOut()
            session.user = nil
            session.set(false, forKey: .isLogged)
            session.set(LoginType.guest.rawValue, forKey: .loggedBy)
            isLoading = false
        } catch {
            print("singOutError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}
