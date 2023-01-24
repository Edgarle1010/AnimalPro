//
//  PetsView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import SwiftUI
import URLImage

struct PetsView: View {
    // MARK: - PROPERTIES
    
    @StateObject var petsVM: PetsViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var currentIndex: Int = 0
    @State private var currendIndexPet: Int = 0
    @State private var selectedPet: PetModel?
    @Namespace private var animation
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                carouselSection()
                
                VStack {
                    titlePetsSection()
                    carouselPetsSection()
                        .spinner($petsVM.isLoading)
                }
                .animation(.easeInOut, value: petsVM.pets)
                .vAling(.top)
                .padding()
                .background {
                    backgroundPets()
                        .scaleEffect(petsVM.showDetailPet ? 1.8 : 1, anchor: .bottomLeading)
                }
                .offset(y: -10)
                .shadow(radius: 5, y: -1)
                .padding(.bottom, 50)
            } //:VSTACK
            .opacity(petsVM.showDetailPet ? 0 : 1)
        } //: SCROLL
        .background {
            backgroundPets()
        }
        .fullScreenCover(isPresented: $petsVM.showAddPet) {
            AddPetView()
                .environmentObject(petsVM)
        }
        .ignoresSafeArea()
        .vAling(.top)
        .background {
            Color.theme.primary.opacity(0.1)
                .ignoresSafeArea()
        }
        .overlay {
            logoImage()
        }
        .overlay(content: {
            if let selectedPet, petsVM.showDetailPet {
                PetDetailView(animation: animation, petId: selectedPet.id, show: $petsVM.showDetailPet)
                    .environmentObject(petsVM)
            }
        })
        .task {
            do {
                try? await petsVM.fetchBanners()
                try await petsVM.fetchPets()
            } catch {
                notificationService.showBanner(error.localizedDescription, .danger)
            }
        }
    }
}

// MARK: - EXTENSION

extension PetsView {
    @ViewBuilder
    private func carouselSection() -> some View {
        GeometryReader { geometry in
            InfiniteCarouselView(banners: $petsVM.banners, currentIndex: $currentIndex)
                .animation(computedHeaderAnimation(geometry), value: 0)
                .offset(y: computedHeaderOffset(geometry))
        }
        .frame(height: 280)
    }
    
    @ViewBuilder
    private func logoImage() -> some View {
        Image("logo-red")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .shadow(radius: 6)
            .padding(.horizontal, 10)
            .offset(y: -10)
            .vAling(.top)
            .hAling(.trailing)
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
        }
    }
    
    @ViewBuilder
    private func titlePetsSection() -> some View {
        HStack {
            Text("Tus mascotas")
                .font(.title.bold())
                .foregroundColor(.white)
            
            Spacer()
            Button {
                petsVM.showAddPet.toggle()
            } label: {
                CircleButtonView(iconName: "plus", circleForegroundColor: .theme.primary)
            }
        }
    }
    
    @ViewBuilder
    private func carouselPetsSection() -> some View {
        if petsVM.pets.isEmpty {
            (Text("Aquí se mostraran tus mascotas.")
                .font(.title2)
                .fontWeight(.medium) +
             Text("\n\nPresiona + para agregar tu mascota")
                .font(.callout)
            )
            .multilineTextAlignment(.center)
            .foregroundColor(.gray)
            .padding()
            .hAling(.center)
            .frame(height: 200)
        } else {
            CustomCarousel(index: $currendIndexPet, items: petsVM.pets, cardPadding: 150, id: \.id) { pet, cardSize in
                VStack {
                    ZStack {
                        if petsVM.showDetailPet && selectedPet?.id == pet.id {
                            petImage(imageUrl: pet.urlImage)
                                .frame(width: cardSize.width, height: cardSize.height)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        } else {
                            petImage(imageUrl: pet.urlImage)
                                .frame(width: cardSize.width, height: cardSize.height)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .matchedGeometryEffect(id: pet.id, in: animation)
                        }
                    }
                    
                    Text(pet.names)
                        .font(.title.bold()).foregroundColor(.white)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)) {
                        selectedPet = pet
                        petsVM.showDetailPet.toggle()
                    }
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, -15)
            .frame(height: 450)
        }
    }
    
    @ViewBuilder
    private func backgroundPets() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            TabView(selection: $currendIndexPet) {
                ForEach(petsVM.pets.indices, id: \.self) { index in
                    petImage(imageUrl: petsVM.pets[index].urlImage)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currendIndexPet)
            
            Rectangle()
                .fill(.ultraThinMaterial)
            
            LinearGradient(colors: [
                .clear], startPoint: .top, endPoint: .bottom)
        } //:GEOMETRY
        .cornerRadius(20)
    }
    
    // MARK: - FUNCTIONS
    
    func computedHeaderAnimation(_ geometry:GeometryProxy) -> Optional<Animation> {
        let offset = computedHeaderOffset(geometry)
        return offset < 0  ? .linear : .none
    }
    
    func computedHeaderOffset(_ geometry:GeometryProxy) -> CGFloat {
        let minY = geometry.frame(in: .global).minY
        let offset = 0 - minY
        return offset
    }
}

// MARK: - PREVIEW

struct PetsView_Previews: PreviewProvider {
    static var previews: some View {
        PetsView(petsVM: dev.petsVM)
            .environment(\.urlImageService, dev.urlImageService)
        
        PetsView(petsVM: dev.petsVM1)
            .environment(\.urlImageService, dev.urlImageService)
    }
}
