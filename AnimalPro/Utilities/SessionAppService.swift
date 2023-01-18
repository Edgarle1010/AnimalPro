//
//  SessionAppService.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation

enum SessionAppValue: String {
    case isLogged = "isLogged"
    case loggedBy = "loggedBy"
    case loggedSuccess = "loggedSuccess"
    case authVerificationID = "authVerificationID"
}

protocol SessionAppServiceProtocol: ObservableObject {
    var user: UserModel? { get }
    var userDefaults: UserDefaults { get }
    
    func set(_ value: Any, forKey: SessionAppValue)
    func setUser(user: UserModel, loggedBy: LoginType)
    func getString(forKey: SessionAppValue) -> String?
}

final class SessionAppService: SessionAppServiceProtocol {
    static let shared = SessionAppService()
    
    var user: UserModel?
    var userDefaults: UserDefaults = .standard
    
    func set(_ value: Any, forKey: SessionAppValue) {
        userDefaults.set(value, forKey: forKey.rawValue)
    }
    
    func setUser(user: UserModel, loggedBy: LoginType) {
        self.user = user
        set(true, forKey: .isLogged)
        set(loggedBy.rawValue, forKey: .loggedBy)
    }
    
    func getString(forKey: SessionAppValue) -> String? {
        return userDefaults.string(forKey: forKey.rawValue)
    }
}
