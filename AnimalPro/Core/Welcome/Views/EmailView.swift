//
//  EmailView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 11/01/23.
//

import SwiftUI

struct EmailView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
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
            //.animation(.easeInOut(duration: 0.5), value: phoneNumber)
            .padding(.top, 100)
        }
        .vAling(.top)
        .navigationBarHidden(true)
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
            //.onReceive(Just(phoneNumber)) { _ in limitText(10) }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func fetchLinkButton() -> some View {
        //if phoneNumber.count == 10 {
            Button {
                Task {
                    
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
        //}
    }
}

// MARK: - PREVIEW

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
    }
}
