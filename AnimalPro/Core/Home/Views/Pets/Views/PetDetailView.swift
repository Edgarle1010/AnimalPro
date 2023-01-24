//
//  PetDetailView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 23/01/23.
//

import SwiftUI
import URLImage

struct PetDetailView: View {
    // MARK: - PROPERTIES
    
    var animation: Namespace.ID
    var petId: String
    @Binding var show: Bool
    
    @EnvironmentObject private var petsVM: PetsViewModel
    @State private var showPetProfile: Bool = false
    
    private var pet: PetModel {
        return petsVM.pets.first { $0.id == petId }!
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            titleSection()
            ScrollView {
                petImage(imageUrl: pet.urlImage)
                
                VStack(spacing: 20) {
                    ZStack {
                        Image("background-img-4")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                        
                        Text("Agendar cita medica")
                    }
                    .cornerRadius(20)
                    
                    ZStack {
                        Image("background-img-4")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 120)
                        
                        Text("Agendar cita medica")
                    }
                    .cornerRadius(20)
                    
                    meetingSection()
                }
                .padding()
            }
        } //:VSTACK
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Color.white.ignoresSafeArea()
            Color.theme.accent.opacity(0.1).ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showPetProfile) {
            PetProfileView(type: pet.petType, isFromDetail: true)
                .environmentObject(petsVM)
        }
    }
}

// MARK: - EXTENSION

extension PetDetailView {
    @ViewBuilder
    private func titleSection() -> some View {
        HStack {
            Button {
                withAnimation {
                    show.toggle()
                }
            } label: {
                CircleButtonView(iconName: "xmark")
            }
            
            Spacer()
            
            Text(pet.names)
                .font(.title3.bold())
            
            Spacer()
            
            Button {
                withAnimation {
                    petsVM.currentPet = pet
                    showPetProfile.toggle()
                }
            } label: {
                CircleButtonView(iconName: "info")
            }
            
        }
        .hAling(.center)
    }
    
    @ViewBuilder
    private func petImage(imageUrl: URL) -> some View {
        URLImage(imageUrl) { progress in
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
                .frame(width: 200, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
    
    @ViewBuilder
    private func meetingSection() -> some View {
        VStack(alignment: .leading) {
            Text("Proximas citas")
                .font(.title.bold())
            
            Text("Sin citas proximas.")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .hAling(.center)
                .padding(.top)
        }
        .hAling(.leading)
    }
}

// MARK: - PREVIEW

struct PetDetailView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        PetDetailView(animation: namespace, petId: dev.petsVM.pets[0].id, show: .constant(true))
            .environment(\.urlImageService, dev.urlImageService)
            .environmentObject(dev.petsVM)
    }
}
