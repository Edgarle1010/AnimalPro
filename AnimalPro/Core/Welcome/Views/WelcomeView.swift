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
    
    @StateObject private var authVM = AuthViewModel()
    @State private var showSignIn: Bool = false
    @State private var showPhoneView: Bool = false
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(showSignIn ? 0.5 : 0)
                .ignoresSafeArea()
                .zIndex(1)
            
            ZStack {
                NavigationLink(
                    destination: PhoneNumberView().environmentObject(authVM),
                    isActive: $showPhoneView,
                    label: {
                        EmptyView()
                    })
                
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
                            .background(Color.theme.accent.opacity(0.1))
                    }
                    .ignoresSafeArea()
                }
            } //:ZSTACK
            .background {
                GeometryReader { geometry in
                    Image("background-img-4")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                }
            }
        } //:ZSTACK
        .animation(.easeInOut, value: showSignIn)
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
            showPhoneView.toggle()
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
                    await authVM.handleSignInWithAppleCompletion(result)
                }
            }
            .blendMode(.destinationOver)
        }
    }
    
    @ViewBuilder
    private func facebookButton() -> some View {
        Button {
            Task {
                await authVM.loginFacebook()
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
    }
}
