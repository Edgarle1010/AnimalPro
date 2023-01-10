//
//  PhoneNumberView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var phoneNumber: String = ""
    @State private var showCountryList: Bool = false
    @State private var countryCode: String = "+52"
    @State private var countryFlag: String = "🇲🇽"
    
    private var phoneWithCountryCode: String {
        return countryCode + phoneNumber
    }
    
    // MARK: - FUNCTIONS
    
    func limitText(_ upper: Int) {
        if phoneNumber.count > upper {
            phoneNumber = String(phoneNumber.prefix(upper))
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: CountryListView(countryCode: $countryCode, countryFlag: $countryFlag),
                isActive: $showCountryList,
                label: {
                    EmptyView()
                })
            
            NavigationLink(
                destination: VerificationCodeView(phoneNumber: phoneWithCountryCode),
                isActive: $authVM.showVerificationCodeView,
                label: {
                    EmptyView()
                })
            
            backButton()
            titleSection()
            Spacer()
            phoneSection()
            fetchCodeButton()
            Spacer()
        }
        .animation(.easeInOut(duration: 0.5), value: phoneNumber)
        .navigationBarHidden(true)
    }
}

// MARK: - EXTENSION

extension PhoneNumberView {
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
        VStack(alignment: .leading, spacing: 10) {
            Text("Ingresa tu número celular")
                .font(.title.bold())
            
            Text("Te enviaremos un código para confirmarlo")
                .font(.footnote.bold())
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func phoneSection() -> some View {
        HStack {
            Button {
                showCountryList.toggle()
            } label: {
                HStack {
                    Text(countryFlag)
                        .font(.title2)
                    Text(countryCode)
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(ButtonPrimaryStyle(hPadding: 10, color: Color.white))
            .fixedSize()
            .shadow(radius: 3)
            
            TextField("Número de teléfono", text: $phoneNumber)
                .font(.title2.bold())
                .keyboardType(.numberPad)
                .onReceive(Just(phoneNumber)) { _ in limitText(10) }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func fetchCodeButton() -> some View {
        if phoneNumber.count == 10 {
            Button {
                Task {
                    await authVM.getVerificationID(phoneNumber: phoneWithCountryCode)
                }
            } label: {
                HStack(spacing: 15) {
                    Image(systemName: "ellipsis.message")
                        .imageScale(.large)
                    Text("Recibir código por SMS")
                }
            }
            .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: Color.theme.tertiary))
            .padding(.top, 20)
            .transition(.opacity)
        }
    }
}

// MARK: - PREVIEW

struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
            .environmentObject(dev.authVM)
    }
}
