//
//  AuthViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation

protocol AuthViewModelProtocol: ObservableObject {
    var showVerificationCodeView: Bool { get set }
    var session: SessionAppService { get }
    var authenticationRepository: AuthenticationRepository { get }
    
    func loginApple() async
    func loginFacebook() async
    func getVerificationID(phoneNumber: String) async
    func signOut() async
}

class AuthViewModel: NSObject, AuthViewModelProtocol {
    @Published var showVerificationCodeView: Bool = false
    let session: SessionAppService = .shared
    let authenticationRepository = AuthenticationRepository(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource())
    
    func loginApple() async {
        do {
            try await authenticationRepository.loginApple()
        } catch {
            print("loginAppleError: \(error.localizedDescription)")
        }
    }
    
    func loginFacebook() async {
        do {
            let user = try await authenticationRepository.loginFacebook()
            session.setUser(user: user, loggedBy: .facebook)
        } catch {
            print("loginFacebookError: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getVerificationID(phoneNumber: String) async {
        do {
            let verificationID = try await authenticationRepository.getVerificationID(phoneNumber: phoneNumber)
            session.set(verificationID, forKey: .authVerificationID)
            showVerificationCodeView.toggle()
        } catch {
            print("gettingVerificationIDError: \(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        do {
            try await authenticationRepository.singOut()
            session.user = nil
            session.set(false, forKey: .isLogged)
            session.set(LoginType.guest.rawValue, forKey: .loggedBy)
        } catch {
            print("singOutError: \(error.localizedDescription)")
        }
    }
}
