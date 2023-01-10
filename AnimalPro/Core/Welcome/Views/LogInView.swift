//
//  LogInView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 07/01/23.
//

import SwiftUI

struct LogInView: View {
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Iniciar sesión")
                    .font(.title.bold())
                    .foregroundColor(Color.white)
                Spacer()
            }
            
            Divider()
                .padding(.horizontal)
            emailButton()
            phoneButton()
            Divider()
                .padding(.horizontal)
            guestButton()
            Spacer()
        } //:VSTACK
        .padding(.top, 20)
        .padding()
    }
}

// MARK: - EXTENSION

extension LogInView {
    @ViewBuilder
    private func emailButton() -> some View {
        Button {
            
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
                .foregroundColor(Color.white)
                .font(Font.body.bold())
        }
    }
}

// MARK: - PREVIEW

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
