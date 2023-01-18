//
//  VerificationCodeView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import SwiftUI

struct VerificationCodeView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @StateObject private var otpVM: OTPViewModel = .init()
    @FocusState private var activeField: OTPField?
    var isFromProfile: Bool = false
    var phoneNumber: String
    
    // MARK: - FUNCTIONS
    
    private func activeStateForIndex(index: Int) -> OTPField {
        switch index {
        case 0: return .field1
        case 1: return .field2
        case 2: return .field3
        case 3: return .field4
        case 4: return .field5
        default: return .field6
        }
    }
    
    private func OTPCondition(value: [String]) {
        for index in 0..<6 {
            if value[index].count == 6 {
                DispatchQueue.main.async {
                    otpVM.otpText = value[index]
                    otpVM.otpField[index] = ""
                    
                    for item in otpVM.otpText.enumerated() {
                        otpVM.otpField[item.offset] = String(item.element)
                    }
                }
                return
            }
        }
        
        for index in 0..<5 {
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField {
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        
        for index in 1...5 {
            if value[index].isEmpty && !value[index - 1].isEmpty {
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        
        for index in 0..<6 {
            if value[index].count > 1 {
                otpVM.otpField[index] = String(value[index].last!)
            }
        }
    }
    
    private func checkStates() -> Bool {
        for index in 0..<6 {
            if otpVM.otpField[index].isEmpty { return true }
        }
        return false
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            backButton()
            titleSection()
            VStack {
                OTPField()
                verifyCodeButton()
            }
            .animation(.easeInOut(duration: 0.5), value: checkStates())
            .padding(.top, 50)
            
            Spacer()
            resendCode()
            Spacer()
        } //:VSTACK
        .background(Color.theme.accent.opacity(0.1))
        .spinner($authVM.isLoading)
        .onChange(of: otpVM.otpField) { newValue in
            OTPCondition(value: newValue)
        }
    }
}

// MARK: - EXTENSION

extension VerificationCodeView {
    @ViewBuilder
    private func backButton() -> some View {
        CircleButtonView(iconName: "chevron.left")
            .onTapGesture {
                dismiss()
            }
            .hAling(.leading)
    }
    
    @ViewBuilder
    private func titleSection() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ingresa el código que enviamos")
                .font(.title.bold())
            
            HStack(spacing: 5) {
                Text("A tu número celular")
                    .font(.footnote.bold())
                Text(phoneNumber)
                    .font(.footnote.bold())
                    .foregroundColor(Color.theme.red)
            }
        } //:VSTACK
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func OTPField() -> some View {
        HStack(spacing: 14) {
            ForEach(0..<6, id: \.self) { index in
                VStack(spacing: 8) {
                    TextField("", text: $otpVM.otpField[index])
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .focused($activeField, equals: activeStateForIndex(index: index))
                    
                    Rectangle()
                        .fill(activeField == activeStateForIndex(index: index) ? Color.black : .gray.opacity(0.3))
                        .frame(height: 4)
                } //:VSTACK
                .frame(width: 40)
            }
        } //:HSTACK
        .hAling(.center)
    }
    
    @ViewBuilder
    private func verifyCodeButton() -> some View {
        if !checkStates() {
            Button {
                Task {
                    if isFromProfile {
                        do {
                            try await authVM.verifyPhoneCodeToLink(verificationCode: otpVM.getOTPString())
                            notificationService.showBanner("Se ha vinculado tu número de teléfono correctamente", .success)
                        } catch {
                            notificationService.showBanner(error.localizedDescription, .danger)
                        }
                    } else {
                        do {
                            try await authVM.verifyPhoneCode(verificationCode: otpVM.getOTPString())
                        } catch {
                            notificationService.showBanner(error.localizedDescription, .danger)
                        }
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                    Text("Verificar código")
                }
            }
            .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: Color.theme.tertiary))
            .padding(.top, 20)
            .transition(.opacity)
        }
    }
    
    @ViewBuilder
    private func resendCode() -> some View {
        VStack {
            Text(otpVM.timeRemaining < 1 ? "¿No recibiste el código?" : "Podrás solicitar un código nuevo en")
                .font(.system(.footnote, design: .rounded)).opacity(0.8)
            
            Text(otpVM.timeRemaining < 1 ? "Reenviar código" : "\(otpVM.timeRemaining) segundos")
                .font(.footnote.bold())
                .foregroundColor(otpVM.timeRemaining < 1 ? Color.theme.red : Color.gray)
                .onTapGesture {
                    if otpVM.timeRemaining < 1 {
                        Task {
                            do {
                                try await authVM.getVerificationID(phoneNumber: phoneNumber)
                                notificationService.showBanner("Enviamos un código al \(phoneNumber)", .success)
                                otpVM.timeRemaining = 60
                            } catch {
                                notificationService.showBanner(error.localizedDescription, .danger)
                            }
                        }
                    }
                }
        }
        .navigationBarHidden(true)
        .hAling(.center)
        .onReceive(otpVM.timer) { _ in
            if otpVM.timeRemaining > 0 {
                otpVM.timeRemaining -= 1
            }
        }
    }
}

// MARK: - PREVIEW

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView(phoneNumber: "+526251057494")
            .environmentObject(dev.authVM)
    }
}

// MARK: - FocusState Enum
enum OTPField {
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
