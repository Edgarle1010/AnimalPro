//
//  ListTextFieldItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

enum ListTextFieldType: String {
    case names, lastNames, email, phoneNumber, birthday
    
    var title: String {
        switch self {
        case .names: return "Nombres"
        case .lastNames: return "Apellidos"
        case .email: return "E-mail"
        case .phoneNumber: return "Celular"
        case .birthday: return "Fecha de nacimiento"
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .names, .lastNames: return .default
        case .email: return .emailAddress
        case .phoneNumber: return .numberPad
        case .birthday: return .default
        }
    }
    
    var textContent: UITextContentType {
        switch self {
        case .names: return .givenName
        case .lastNames: return .familyName
        case .email: return .emailAddress
        case .phoneNumber: return .telephoneNumber
        case .birthday: return .dateTime
        }
    }
}

struct ListTextFieldItemView: View {
    // MARK: - PROPERTIES
    
    @Binding var textFieldText: String
    let type: ListTextFieldType
    @State private var date: Date = Date()
    
    init(textFieldText: Binding<String>, type: ListTextFieldType) {
        self._textFieldText = textFieldText
        self.type = type
        self.date = DateFormatter.formate.date(from: self.textFieldText) ?? Date()
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(type.title)
                .font(.subheadline)
            
            if type == .birthday {
                birthdayOpcion()
            } else {
                othersOpcion()
            }
        }
    }
}

// MARK: - EXTENSION

extension ListTextFieldItemView {
    @ViewBuilder
    private func birthdayOpcion() -> some View {
        HStack(spacing: 10) {
            TextField("", text: $textFieldText)
                .font(.title3.bold())
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.1)
                }
                .disabled(true)
            
            Image(systemName: "calendar")
                .font(.title)
                .overlay {
                    DatePicker("", selection: $date.onChange({ _ in
                        textFieldText = DateFormatter.formate.string(from: date)
                    }), in: ...Date.now, displayedComponents: .date)
                    .blendMode(.destinationOver)
                }
        }
    }
    
    @ViewBuilder
    private func othersOpcion() -> some View {
        TextField("", text: $textFieldText)
            .keyboardType(type.keyboard)
            .textContentType(type.textContent)
            .font(.title3.bold())
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.1)
            }
            .disabled(type == .phoneNumber)
    }
}

// MARK: - PREVIEW

struct ListTextFieldItemView_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ListTextFieldItemView(textFieldText: .constant("Edgar Francisco"), type: .names)
            ListTextFieldItemView(textFieldText: .constant("10 de octubre de 1994"), type: .birthday)
        }
        .padding(.horizontal)
    }
}
