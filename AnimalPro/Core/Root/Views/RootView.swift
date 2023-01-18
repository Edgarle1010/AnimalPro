//
//  RootView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import SwiftUI

struct RootView: View {
    // MARK: - PROPERTIES
    
    @AppStorage(SessionAppValue.isLogged.rawValue) private var isLogged = false
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var profileVM = ProfileViewModel()
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLogged {
                    HomeView(tabSelection: .home)
                        .navigationBarHidden(true)
                        .transition(.opacity)
                } else {
                    WelcomeView()
                        .navigationBarHidden(true)
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: isLogged)
            .environmentObject(authVM)
            .environmentObject(profileVM)
        }
        .navigationViewStyle(.stack)
        .banner()
    }
}

// MARK: - PREVIEW

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .environmentObject(dev.notifierVM)
    }
}
