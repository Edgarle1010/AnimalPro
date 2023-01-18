//
//  CustomAlert.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

struct CustomAlert: View {
    // MARK: - PROPERTIES
    @Binding var presentAlert: Bool
    var alertType: AlertType = .success
    let title: String
    let message: String
    var action: (() -> ())?
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 15) {
            titleAndMessageSection()
            verticalButtons()
        } //:VSTACK
        .padding(.vertical, 30)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
    }
}

// MARK: - EXTENSION

extension CustomAlert {
    @ViewBuilder
    private func titleAndMessageSection() -> some View {
        if title != "" {
            Text(title)
                .font(.title.weight(.black))
                .fixedSize(horizontal: false, vertical: true)
                .hAling(.leading)
        }

        if message != "" {
            Text(message)
                .font(.callout)
                .hAling(.leading)
        }
    }
    
    @ViewBuilder
    private func verticalButtons() -> some View {
        VStack(spacing: 5) {
            Button {
                withAnimation(.easeInOut) {
                    presentAlert = false
                    action?()
                }
            } label: {
                Text(alertType.leftActionText)
            }
            .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: .theme.red))
            
            Button {
                withAnimation(.easeInOut) {
                    presentAlert = false
                }
            } label: {
                Text(alertType.rightActionText)
                    .foregroundColor(.black)
            }
            .buttonStyle(ButtonPrimaryStyle(color: .white))
        }
    }
}

// MARK: - PREVIEW

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(presentAlert: .constant(true), title: "¿Seguro deseas cerrar sesión?", message: "Tendrás que volver a validar tus datos cuando vuelvas a ingresar a la app.")
    }
}
