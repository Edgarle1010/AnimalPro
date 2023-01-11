//
//  OTPViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/01/23.
//

import Foundation

class OTPViewModel: ObservableObject {
    @Published var otpText: String = ""
    @Published var otpField: [String] = Array(repeating: "", count: 6)
    @Published var timeRemaining: Int = 60
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func getOTPString() -> String {
        otpText = otpField.reduce("") { partialResult, value in
           partialResult + value
        }
        return otpText
    }
}
