//
//  PhoneAuthentication.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import Foundation
import FirebaseAuth

final class PhoneAuthentication {
    func getVerificationID(phoneNumber: String, completionBlock: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error geting verificationID: \(error.localizedDescription)")
                completionBlock(.failure(error))
                return
            }
            completionBlock(.success(verificationID ?? ""))
        }
    }
    
    @MainActor
    func getVerificationID(phoneNumber: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            getVerificationID(phoneNumber: phoneNumber) { result in
                continuation.resume(with: result)
            }
        }
    }
}
