//
//  CustomAlertModifier.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    var alertType: AlertType = .success
    let title: String
    let message: String
    var action: (() -> ())?
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(showAlert)
                .zIndex(0)
            
            if showAlert {
                Color.black.opacity(0.75)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1)
                
                CustomAlert(presentAlert: $showAlert, title: title, message: message, action: action)
                    .transition(.opacity)
                    .zIndex(2)
            }
        }
    }
}

struct CustomAlertModifier_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .customAlert(.constant(true), title: "¿Seguro deseas cerrar sesión?", action: {
                
            })
            .environmentObject(dev.authVM)
    }
}
