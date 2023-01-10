//
//  HomeView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authVM = AuthViewModel()
    
    var body: some View {
        Button {
            Task {
                await authVM.signOut()
            }
        } label: {
            Text("LogOut")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
