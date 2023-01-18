//
//  WelcomeView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 07/01/23.
//

import SwiftUI
import AuthenticationServices

struct WelcomeView: View {
    // MARK: - PROPERTIES
    
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var showSignIn: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(showSignIn ? 0.5 : 0)
                .ignoresSafeArea()
                .zIndex(1)
            
            VStack(spacing: 10) {
                logoImage()
                Spacer()
                appleButton()
                facebookButton()
                phoneButton()
                signInButton()
            }
            .sheet(isPresented: $showSignIn) {
                HalfSheet {
                    LogInView()
                        .environmentObject(authVM)
                        .background(Color.theme.accent.opacity(0.1))
                }
                .ignoresSafeArea()
            }
            .background {
                NavigationLink(
                    destination: PhoneNumberView().environmentObject(authVM),
                    isActive: $authVM.showPhoneView,
                    label: {EmptyView() })
                
                NavigationLink(
                    destination: EmailView().environmentObject(authVM),
                    isActive: $authVM.showEmailView,
                    label: { EmptyView() })
                
                GeometryReader { geometry in
                    Image("background-img-4")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            }
        } //:ZSTACK
        .animation(.easeInOut, value: showSignIn)
        .spinner($authVM.isLoading)
    }
}

// MARK: - EXTENSION

extension WelcomeView {
    @ViewBuilder
    private func logoImage() -> some View {
        VStack {
            Image("logo-title-white")
                .resizable()
                .scaledToFit()
        }
        .padding(20)
        .padding(.top, 150)
    }
    
    @ViewBuilder
    private func phoneButton() -> some View {
        Button {
            authVM.showPhoneView.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "phone.circle")
                    .imageScale(.large)
                Text("Continúa con tu celular")
            }
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.theme.red))
    }
    
    @ViewBuilder
    private func appleButton() -> some View {
        Button {
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "apple.logo")
                    .imageScale(.large)
                Text("Continúa con Apple")
            }
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.black))
        .overlay {
            SignInWithAppleButton { request in
                authVM.handleSignInWithAppleRequest(request)
            } onCompletion: { result in
                Task {
                    do {
                        try await authVM.handleSignInWithAppleCompletion(result)
                    } catch {
                        notificationService.showBanner(error.localizedDescription, .danger)
                    }
                }
            }
            .blendMode(.destinationOver)
            .opacity(authVM.isLoading ? 0 : 1)
        }
    }
    
    @ViewBuilder
    private func facebookButton() -> some View {
        Button {
            Task {
                do {
                    try await authVM.loginFacebook()
                } catch {
                    notificationService.showBanner(error.localizedDescription, .danger)
                }
            }
        } label: {
            HStack(spacing: 10) {
                Image("facebook-circle-fill")
                    .imageScale(.large)
                Text("Continúa con Facebook")
            }
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.theme.facebookBlue))
    }
    
    @ViewBuilder
    private func signInButton() -> some View {
        Button {
            showSignIn.toggle()
        } label: {
            Text("Ya tengo una cuenta")
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.theme.tertiary))
    }
}

// MARK: - PREVIEW

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(dev.authVM)
    }
}
