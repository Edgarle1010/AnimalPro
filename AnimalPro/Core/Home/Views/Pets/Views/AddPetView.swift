//
//  AddPetView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 21/01/23.
//

import SwiftUI

struct AddPetView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var petsVM: PetsViewModel
    @State private var selection: PetType = .dog
    @State private var localSelection: PetType = .dog
    @State private var showRaceView: Bool = false
    let petTypes: [PetType] = [.dog, .cat, .other]
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
                backButton()
                titleSection()
                petTypeSection()
                nextButton()
            }
            .vAling(.top)
            .background {
                NavigationLink(
                    destination: PetProfileView(type: selection).environmentObject(petsVM),
                    isActive: $showRaceView,
                    label: { EmptyView() })
                
                Color.theme.accent.opacity(0.1).ignoresSafeArea()
            }
        }
        .navigationViewStyle(.stack)
        .banner()
    }
}

// MARK: - EXTENSION

extension AddPetView {
    @ViewBuilder
    private func backButton() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                CircleButtonView(iconName: "xmark")
            }
        }
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func titleSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Información de tu mascota")
                .font(.title.bold())
        }
        .padding(.horizontal)
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func petTypeSection() -> some View {
        HStack(spacing: 20) {
            ForEach(petTypes, id: \.self) { type in
                CirclePetTypeItem(type: type, localSelection: $localSelection)
                    .onTapGesture {
                        selection = type
                    }
            }
        }
        .hAling(.center)
        .onChange(of: selection) { value in
            withAnimation(.easeInOut) {
                localSelection = value
            }
        }
        .padding(.top, 50)
        .padding(.horizontal)
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func nextButton() -> some View {
        Button {
            petsVM.currentPet = .init(id: UUID().uuidString, petType: selection, names: "")
            showRaceView.toggle()
        } label: {
            HStack(spacing: 15) {
                Image(systemName: "pawprint.fill")
                    .imageScale(.large)
                Text("Continuar")
            }
        }
        .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: Color.theme.tertiary))
        .padding(.top, 40)
    }
}

// MARK: - PREVIEW

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView()
            .environmentObject(dev.notifierVM)
            .environmentObject(dev.petsVM1)
    }
}
