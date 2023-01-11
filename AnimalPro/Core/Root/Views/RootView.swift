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
    
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                if isLogged {
                    HomeView()
                        .navigationBarHidden(true)
                        .transition(.slide)
                } else {
                    WelcomeView()
                        .navigationBarHidden(true)
                        .transition(.slide)
                }
            }
            .animation(.easeInOut, value: isLogged)
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
