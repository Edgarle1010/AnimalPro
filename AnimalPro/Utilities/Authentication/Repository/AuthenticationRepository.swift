//
//  AuthenticationRepository.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation
import AuthenticationServices

protocol AuthenticationRepositoryProtocol {
    var authenticationFirebaseDatasource: AuthenticationFirebaseDatasource { get }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest)
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws
    func loginFacebook() async throws -> UserModel
    func getVerificationID(phoneNumber: String) async throws -> String
    func verifyPhoneCode(verificationCode: String) async throws -> UserModel
    func singOut() async throws
}


final class AuthenticationRepository: AuthenticationRepositoryProtocol {
    var authenticationFirebaseDatasource: AuthenticationFirebaseDatasource
    
    init(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        authenticationFirebaseDatasource.handleSignInWithAppleRequest(request)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws {
        try await authenticationFirebaseDatasource.handleSignInWithAppleCompletion(result)
    }
    
    func loginFacebook() async throws -> UserModel {
        return try await authenticationFirebaseDatasource.loginWithFacebook()
    }
    
    func getVerificationID(phoneNumber: String) async throws -> String {
        return try await authenticationFirebaseDatasource.getVerificationID(phoneNumber: phoneNumber)
    }
    
    func verifyPhoneCode(verificationCode: String) async throws -> UserModel {
        return try await authenticationFirebaseDatasource.verifyPhoneCode(verificationCode: verificationCode)
    }
    
    func singOut() async throws {
        try await authenticationFirebaseDatasource.signOut()
    }
}
