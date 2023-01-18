//
//  HomeView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import SwiftUI

struct HomeView: View {
    // MARK: - PROPERTIES
    
    @AppStorage(SessionAppValue.loggedSuccess.rawValue) private var loggedSuccess = false
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    @StateObject private var notificationService: NotificationService = .shared
    @State var tabSelection: TabBarItem
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            if loggedSuccess {
                LoginSuccessView()
                    .transition(.opacity)
            } else {
                CustomTabBarContainerView(selection: $tabSelection) {
                    Color.theme.accent.opacity(0.1)
                        .tabBarItem(tab: .home, selection: $tabSelection)
                    
                    Color.theme.accent.opacity(0.1)
                        .tabBarItem(tab: .vet, selection: $tabSelection)
                    
                    ProfileView()
                        .tabBarItem(tab: .profile, selection: $tabSelection)
                }
            }
        }
        .spinner($authVM.isLoading)
        .customAlert($profileVM.showAlert, title: "¿Seguro deseas cerrar sesión?") {
            Task {
                do {
                    try await authVM.signOut()
                } catch {
                    notificationService.showBanner(error.localizedDescription, .danger)
                }
            }
        }
    }
}

// MARK: - PREVIEW

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(tabSelection: .home)
            .environmentObject(dev.authVM)
            .environmentObject(dev.profileVM)
    }
}
