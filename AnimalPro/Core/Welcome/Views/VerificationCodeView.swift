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
    var phoneNumber: String
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            backButton()
            titleSection()
            Spacer()
        }
    }
}

// MARK: - EXTENSION

extension VerificationCodeView {
    @ViewBuilder
    private func backButton() -> some View {
        HStack {
            CircleButtonView(iconName: "chevron.left")
                .onTapGesture {
                    dismiss()
                }
            Spacer()
        }
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
        }
        .padding(.horizontal)
    }
}

// MARK: - PREVIEW

struct VerificationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeView(phoneNumber: "+526251057494")
            .environmentObject(dev.authVM)
    }
}
