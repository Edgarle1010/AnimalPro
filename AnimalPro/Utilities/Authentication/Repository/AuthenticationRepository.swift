//
//  AuthenticationRepository.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation

protocol AuthenticationRepositoryProtocol {
    var authenticationFirebaseDatasource: AuthenticationFirebaseDatasource { get }
    
    func loginApple() async throws
    func loginFacebook() async throws -> UserModel
    func getVerificationID(phoneNumber: String) async throws -> String
    func singOut() async throws
}


final class AuthenticationRepository: AuthenticationRepositoryProtocol {
    var authenticationFirebaseDatasource: AuthenticationFirebaseDatasource
    
    init(authenticationFirebaseDatasource: AuthenticationFirebaseDatasource) {
        self.authenticationFirebaseDatasource = authenticationFirebaseDatasource
    }
    
    func loginApple() async throws {
        return try await authenticationFirebaseDatasource.loginWithApple()
    }
    
    func loginFacebook() async throws -> UserModel {
        return try await authenticationFirebaseDatasource.loginWithFacebook()
    }
    
    func getVerificationID(phoneNumber: String) async throws -> String {
        return try await authenticationFirebaseDatasource.getVerificationID(phoneNumber: phoneNumber)
    }
    
    func singOut() async throws {
        try await authenticationFirebaseDatasource.signOut()
    }
}
