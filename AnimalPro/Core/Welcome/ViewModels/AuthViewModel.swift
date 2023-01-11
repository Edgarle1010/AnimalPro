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
    var session: SessionAppService { get }
    var authenticationRepository: AuthenticationRepository { get }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async
    func loginFacebook() async
    func getVerificationID(phoneNumber: String) async throws
    func verifyPhoneCode(verificationCode: String) async throws
    func signOut() async
}

class AuthViewModel: AuthViewModelProtocol {
    @Published var isLoading: Bool = false
    
    let session: SessionAppService = .shared
    let authenticationRepository = AuthenticationRepository(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource())
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationRepository.handleSignInWithAppleRequest(request)
    }
    
    @MainActor
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async {
        isLoading = true
        do {
            try await authenticationRepository.handleSignInWithAppleCompletion(result)
            isLoading = false
        } catch {
            print("loginAppleError: \(error.localizedDescription)")
            isLoading = false
        }
    }
    
    @MainActor
    func loginFacebook() async {
        isLoading = true
        do {
            let user = try await authenticationRepository.loginFacebook()
            session.setUser(user: user, loggedBy: .facebook)
            isLoading = false
        } catch {
            print("loginFacebookError: \(error.localizedDescription)")
            isLoading = false
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
            isLoading = false
        } catch {
            print("gettingVerifyPhoneCodeError: \(error.localizedDescription)")
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func signOut() async {
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
        }
    }
}
