//
//  EmailView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 11/01/23.
//

import SwiftUI
import Combine
import Firebase

struct EmailView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var isValidEmail: Bool = false
    @State private var email: String = ""
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 20) {
            backButton()
            titleSection()
            VStack {
                emailSection()
                fetchLinkButton()
            }
            .animation(.easeInOut, value: isValidEmail)
            .padding(.top, 100)
        }
        .vAling(.top)
        .navigationBarHidden(true)
        .spinner($authVM.isLoading)
        .background(Color.theme.accent.opacity(0.1))
        .onOpenURL { url in
            let link = url.absoluteString
            if Auth.auth().isSignIn(withEmailLink: link) {
                Task {
                    do {
                        try await authVM.passwordlessSignIn(email: email, link: link)
                    } catch {
                        notificationService.showBanner(error.localizedDescription, .danger)
                    }
                }
            }
        }
    }
}

// MARK: - EXTENSION

extension EmailView {
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
        Text("Agrega tu correo")
            .padding(.horizontal)
            .font(.title.bold())
            .hAling(.leading)
    }
    
    @ViewBuilder
    private func emailSection() -> some View {
        TextField("Tu correo", text: $email)
        .font(.title2.bold())
        .keyboardType(.emailAddress)
        .padding(.horizontal)
        .onReceive(Just(email)) { newValue in
            isValidEmail = authVM.textFieldValidatorEmail(newValue)
            email = newValue.lowercased()
        }
    }
    
    @ViewBuilder
    private func fetchLinkButton() -> some View {
        if isValidEmail {
            Button {
                Task {
                    do {
                        try await authVM.sendSignInLink(email: email)
                        notificationService.showBanner("Enviamos un enlace al \(email). Ábrelo para iniciar sesión", .success)
                    } catch {
                        notificationService.showBanner(error.localizedDescription, .danger)
                    }
                }
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "envelope.badge")
                        .imageScale(.large)
                    Text("Recibir enlace por correo")
                }
            }
            .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: Color.theme.tertiary))
            .padding(.top, 20)
            .transition(.opacity)
        }
    }
}

// MARK: - PREVIEW

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
            .environmentObject(dev.authVM)
    }
}
