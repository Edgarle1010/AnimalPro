//
//  EmailAuthentication.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 11/01/23.
//

import Foundation
import FirebaseAuth

final class EmailAuthentication {
    func sendSignInLink(email: String, completionBlock: @escaping (Result<Bool, Error>) -> Void) {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "https://animalpro.page.link/login_email")
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                completionBlock(.failure(error))
                return
            }
            completionBlock(.success(true))
        }
    }
    
    func sendSignInLink(email: String) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            sendSignInLink(email: email) { result in
                continuation.resume(with: result)
            }
        }
    }
}
