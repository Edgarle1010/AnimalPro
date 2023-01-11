//
//  LogInView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 07/01/23.
//

import SwiftUI

struct LogInView: View {
    // MARK: - BODY
    
    @Environment(\.dismiss) private var dismiss
    @State private var showEmailView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(
                destination: EmailView(),
                isActive: $showEmailView,
                label: { EmptyView() })
            
            titleSection()
            Divider()
                .padding(.horizontal)
            emailButton()
            phoneButton()
            Divider()
                .padding(.horizontal)
            guestButton()
            Spacer()
        } //:VSTACK
        .padding()
    }
}

// MARK: - EXTENSION

extension LogInView {
    @ViewBuilder
    private func titleSection() -> some View {
        HStack {
            Text("Iniciar sesión")
                .font(.title.bold())
            
            Spacer()
            
            CircleButtonView(iconName: "xmark")
                .onTapGesture {
                    dismiss()
                }
        }
    }
    
    @ViewBuilder
    private func emailButton() -> some View {
        Button {
            showEmailView.toggle()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "envelope")
                    .imageScale(.large)
                Text("Ingresa con tu correo")
            }
            .foregroundColor(.theme.tertiary)
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.white))
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func phoneButton() -> some View {
        Button {
            
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "phone.circle")
                    .imageScale(.large)
                Text("Ingresa con tu celular")
            }
            .foregroundColor(.theme.tertiary)
        }
        .buttonStyle(ButtonPrimaryStyle(color: Color.theme.accent))
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    private func guestButton() -> some View {
        Button {
            
        } label: {
            Text("Continuar como invitado")
                .foregroundColor(Color.theme.tertiary)
                .font(Font.body.bold())
        }
    }
}

// MARK: - PREVIEW

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView()
        }
    }
}
