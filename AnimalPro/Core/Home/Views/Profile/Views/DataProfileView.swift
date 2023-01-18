//
//  DataProfileView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

struct DataProfileView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var profileVM: ProfileViewModel
    @StateObject private var notificationService: NotificationService = .shared
    
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
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .task {
            await profileVM.fetchProfileTextField()
            try? await profileVM.fetchUserData()
        }
    }
}

// MARK: - EXTENSION

extension DataProfileView {
    @ViewBuilder
    private func backButton() -> some View {
        CircleButtonView(iconName: "chevron.left")
            .onTapGesture {
                dismiss()
            }
    }
    
    @ViewBuilder
    private func titleSection() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Mi Perfil")
                    .font(.title.bold())
                
                Text("Actualiza tus datos personales")
                    .font(.callout)
            }
        } //:HSTACK
        .padding(.horizontal)
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
}

// MARK: - PREVIEW

struct DataProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DataProfileView()
            .environmentObject(dev.profileVM)
    }
}
