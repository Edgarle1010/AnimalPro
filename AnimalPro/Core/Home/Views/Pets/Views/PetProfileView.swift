//
//  PetProfileView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 21/01/23.
//

import SwiftUI
import URLImage

struct PetProfileView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var petsVM: PetsViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var showingImagePicker: Bool = false
    @State private var showAlert: Bool = false
    let type: PetType
    var isFromDetail: Bool = false
    
    private var urlImage: URL {
        URL(string: petsVM.currentPet?.imageUrl ?? type.defaultUrlImage)!
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            backButton()
            ScrollView {
                photoSection()
                listRowsItems()
                saveButton()
            }
        }
        .spinner($petsVM.isLoading)
        .navigationBarHidden(true)
        .vAling(.top)
        .background {
            Color.theme.accent.opacity(0.1).ignoresSafeArea()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $petsVM.inputImage)
        }
        .task {
            await petsVM.fetchProfileTextField()
        }
        .onAppear {
            petsVM.delegate = self
            petsVM.inputImage = nil
        }
        .onDisappear { petsVM.delegate = nil }
        .customAlert($showAlert, title: "¿Seguro deseas agregar tu mascota?", message: "Una vez agregada solo podrás modificar su foto.") {
            petsVM.savePet()
        }
    }
}

// MARK: - EXTENSION

extension PetProfileView: PetsDelegate {
    @ViewBuilder
    private func backButton() -> some View {
        ZStack {
            Text(type.title)
                .font(.title3.bold())
                .hAling(.center)
            
            Button {
                dismiss()
            } label: {
                CircleButtonView(iconName: "chevron.left")
            }
            .hAling(.leading)
            
            Button {
                
            } label: {
                CircleButtonView(iconName: "book")
            }
            .hAling(.trailing)
            .opacity(isFromDetail ? 1 : 0)

        }
    }
    
    @ViewBuilder
    private func photoSection() -> some View {
        VStack {
            if let image = petsVM.inputImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            } else {
                URLImage(urlImage) { progress in
                    LoadingImageView()
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                } failure: { error, retry in
                    VStack {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 60))
                        
                        Text("Error")
                            .font(.caption2.bold())
                    }
                    .frame(width: 150, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundColor(.theme.red)
                } content: { image, info in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
            }
            
            Button {
                showingImagePicker.toggle()
            } label: {
                Text(isFromDetail ? "Editar foto" : "Agregar foto")
                    .font(.headline.bold())
                    .foregroundColor(.theme.tertiary)
            }
        }
    }
    
    @ViewBuilder
    private func listRowsItems() -> some View {
        VStack(alignment: .leading) {
            ForEach(petsVM.dataPetItems, id: \.type) { itemView in
                itemView
                    .padding(.vertical, 10)
            }
        }
        .padding()
        .padding(.top)
        .disabled(isFromDetail ? true : false)
    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            if petsVM.validatePetData() {
                if isFromDetail {
                    petsVM.updatePet()
                } else {
                    withAnimation {
                        showAlert.toggle()
                    }
                }
            } else {
                notificationService.showBanner("Revisa que hayas agregado una foto y llenado todos los campos", .info)
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: "pawprint.fill")
                    .imageScale(.large)
                Text(isFromDetail ? "Actualizar información" : "Guardar mascota")
            }
        }
        .buttonStyle(ButtonPrimaryStyle(hPadding: 20, color: Color.theme.tertiary))
    }
    
    // MARK: - DELEGATE
    
    func onError(_ error: String) {
        notificationService.showBanner(error, .danger)
    }
    
    func onSuccess(_ message: String) {
        notificationService.showBanner(message, .success)
        if isFromDetail {
            dismiss()
        } else {
            petsVM.showAddPet.toggle()
        }
    }
}

// MARK: - PREVIEW

struct RaceView_Previews: PreviewProvider {
    static var previews: some View {
        PetProfileView(type: .cat)
            .environmentObject(dev.petsVM)
        
        PetProfileView(type: .cat, isFromDetail: true)
            .environmentObject(dev.petsVM)
    }
}
