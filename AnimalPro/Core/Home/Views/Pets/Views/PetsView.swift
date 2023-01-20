//
//  PetsView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import SwiftUI

struct PetsView: View {
    // MARK: - PROPERTIES
    
    @StateObject var petsVM: PetsViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State private var currentIndex: Int = 0
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            carouselSection()
        }
        .vAling(.top)
        .background {
            Color.theme.primary.opacity(0.1).ignoresSafeArea()
        }
        .task {
            do {
                try await petsVM.fetchBanners()
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
        InfiniteCarouselView(banners: $petsVM.banners, currentIndex: $currentIndex)
            .overlay {
                Image("logo-red")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .shadow(radius: 6)
                    .padding(.horizontal, 8)
                    .offset(y: -8)
                    .vAling(.top)
                    .hAling(.trailing)
            }
    }
}

// MARK: - PREVIEW

struct PetsView_Previews: PreviewProvider {
    static var previews: some View {
        PetsView(petsVM: dev.petsVM)
    }
}
