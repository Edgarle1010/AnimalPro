//
//  DataProfileView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI
import URLImage

struct DataProfileView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileVM: ProfileViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var showingImagePicker = false
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            HStack {
                backButton()
                Spacer()
                saveButton()
            }
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    titleSection()
                    listRowsItems()
                }
                .hAling(.leading)
            }
        }
        .vAling(.top)
        .navigationBarHidden(true)
        .spinner($profileVM.isLoading)
        .background {
            Color.theme.accent
                .opacity(0.1)
                .ignoresSafeArea()
        }
        .onAppear { profileVM.delegate = self }
        .onDisappear { profileVM.delegate = nil }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .task {
            await profileVM.fetchProfileTextField()
            try? await profileVM.fetchUserData()
        }
        .onChange(of: profileVM.inputImage) { _ in profileVM.loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $profileVM.inputImage)
        }
    }
}

// MARK: - EXTENSION

extension DataProfileView: ProfileDelegate {
    @ViewBuilder
    private func backButton() -> some View {
        CircleButtonView(iconName: "chevron.left")
            .onTapGesture {
                dismiss()
            }
    }
    
    @ViewBuilder
    private func titleSection() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Mi Perfil")
                    .font(.title.bold())
                
                Text("Actualiza tus datos personales")
                    .font(.callout)
                    .minimumScaleFactor(0.5)
            }
            
            Spacer()
            
            VStack {
                URLImage(profileVM.urlProfileImage) { progress in
                    LoadingImageView()
                } failure: { error, retry in
                    VStack {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 60))
                        
                        Text("Error")
                            .font(.caption2.bold())
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .foregroundColor(.theme.red)
                } content: { image, info in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                .overlay(Circle().stroke(Color.theme.primary, lineWidth: 4))
                .padding(.top)
                
                Button {
                    showingImagePicker.toggle()
                } label: {
                    Text("Editar")
                        .font(.footnote.bold())
                        .foregroundColor(.theme.tertiary)
                }

            }

        } //:HSTACK
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    private func listRowsItems() -> some View {
        VStack(alignment: .leading) {
            ForEach(profileVM.dataUserItems, id: \.type) { itemView in
                itemView
                    .padding(.vertical, 10)
                    .overlay {
                        if itemView.type == .phoneNumber {
                            NavigationLink(
                                destination: PhoneNumberView(isFromProfile: true)
                                    .environmentObject(profileVM.authVM),
                                isActive: $profileVM.authVM.showDataProfile,
                                label: { Text("Click aquí").hAling(.center) })
                                .blendMode(.destinationOver)
                        }
                    }
                
                if itemView.type == .phoneNumber && profileVM.validatePhoneNumber() {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("Tu número ha sido verificado")
                            .font(.footnote)
                    }
                    .foregroundColor(.green)
                }
            }
        }
        .padding()
        .padding(.top)
    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        CircleButtonView(iconName: "checkmark")
            .onTapGesture {
                Task {
                    do {
                        try await profileVM.updateUserData()
                        notificationService.showBanner("Se actualizaron tus datos correctamente", .success)
                        dismiss()
                    } catch {
                        notificationService.showBanner(error.localizedDescription, .danger)
                    }
                }
            }
    }
    
    // MARK: - DELEGATE
    
    func onError(_ error: String) {
        notificationService.showBanner(error, .danger)
    }
    
    func onSuccess(_ message: String) {
        notificationService.showBanner(message, .success)
    }
}

// MARK: - PREVIEW

struct DataProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DataProfileView()
            .environmentObject(dev.profileVM)
    }
}
