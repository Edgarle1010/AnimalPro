//
//  ListTextFieldItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

enum ListTextFieldType: String {
    case names, lastNames, email, phoneNumber, birthday, race, biologicalSex
    
    var title: String {
        switch self {
        case .names: return "Nombre(s)"
        case .lastNames: return "Apellido(s)"
        case .email: return "E-mail"
        case .phoneNumber: return "Celular"
        case .birthday: return "Fecha de nacimiento"
        case .race: return "Raza"
        case .biologicalSex: return "Sexo biológico"
        }
    }
    
    var keyboard: UIKeyboardType {
        switch self {
        case .names, .lastNames: return .default
        case .email: return .emailAddress
        case .phoneNumber: return .numberPad
        case .birthday: return .default
        case .race: return .default
        case .biologicalSex: return .default
        }
    }
    
    var textContent: UITextContentType {
        switch self {
        case .names: return .givenName
        case .lastNames: return .familyName
        case .email: return .emailAddress
        case .phoneNumber: return .telephoneNumber
        case .birthday: return .dateTime
        case .race: return .givenName
        case .biologicalSex: return .name
        }
    }
}

struct ListTextFieldItemView: View {
    // MARK: - PROPERTIES
    
    @Binding var textFieldText: String
    let type: ListTextFieldType
    let petType: PetType?
    @State private var date: Date = Date()
    @State private var showRaceList: Bool = false
    @State private var localSelection: BiologicalSex = .male
    let biologicalsSexs: [BiologicalSex] = [.male, .female]
    
    init(textFieldText: Binding<String>, type: ListTextFieldType, petType: PetType? = nil) {
        self._textFieldText = textFieldText
        self.type = type
        self.petType = petType
        self.date = DateFormatter.formate.date(from: self.textFieldText) ?? Date()
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(type.title)
                .font(.subheadline)
            
            if type == .birthday {
                birthdayOption()
            } else if type == .race {
                raceOption()
            } else if type == .biologicalSex {
                biologicalSexOption()
            } else {
                othersOption()
            }
        }
        .fullScreenCover(isPresented: $showRaceList) {
            RaceListView(race: $textFieldText, type: petType ?? .dog)
        }
        .onAppear {
            withAnimation {
                localSelection = BiologicalSex(rawValue: textFieldText) ?? .male
            }
        }
    }
}

// MARK: - EXTENSION

extension ListTextFieldItemView {
    @ViewBuilder
    private func birthdayOption() -> some View {
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
    private func raceOption() -> some View {
        HStack(spacing: 10) {
            TextField("", text: $textFieldText)
                .font(.title3.bold())
                .padding(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.1)
                }
                .disabled(true)
            
            Image(systemName: "pawprint.fill")
                .font(.title)
                .onTapGesture {
                    showRaceList.toggle()
                }
        }
    }
    
    @ViewBuilder
    private func biologicalSexOption() -> some View {
        HStack(spacing: 30) {
            ForEach(biologicalsSexs, id: \.self) { type in
                CircleBiologicalSexItem(type: type, localSelection: $localSelection)
                .onTapGesture {
                    textFieldText = type.rawValue
                    withAnimation(.easeInOut) {
                        localSelection = BiologicalSex(rawValue: textFieldText) ?? .male
                    }
                }
            }
        } //:HSTACK
        .hAling(.center)
        .padding()
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func othersOption() -> some View {
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
            ListTextFieldItemView(textFieldText: .constant(""), type: .race)
            ListTextFieldItemView(textFieldText: .constant("male"), type: .biologicalSex)
        }
        .padding(.horizontal)
    }
}
