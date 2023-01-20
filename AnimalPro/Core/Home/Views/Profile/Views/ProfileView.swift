//
//  ProfileView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

struct ProfileView: View {
    // MARK: - PROPERTIES
    
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var profileVM: ProfileViewModel
    let mainOptionsItems: [ListRowItem] = [.profile, .centerHelp, .history, .payments]
    let myAccountItems: [ListRowItem] = [.myPets, .addresses, .language, .notifications]
    let informationItem: [ListRowItem] = [.termsAndConditions, .logOut]
    
    // MARK: -  BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 40) {
                titleSection()
                mainOptionsSection()
                accountSection()
                informationSection()
            }
            .padding(.bottom, 70)
        } //:SCROLL
        .padding(20)
        .vAling(.top)
        .edgesIgnoringSafeArea(.bottom)
        .background {
            NavigationLink(
                destination: DataProfileView()
                    .environmentObject(profileVM),
                isActive: $profileVM.showProfileData,
                label: { EmptyView() })
            
            Color.theme.primary.opacity(0.1).ignoresSafeArea()
        }
        .task {
            try? await profileVM.fetchUserData()
        }
    }
}

// MARK: - EXTENSION

extension ProfileView {
    @ViewBuilder
    private func titleSection() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Hola")
                .font(.title2)
            
            Text(profileVM.user?.names ?? "Usuario")
                .font(.title).bold()
        }
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func mainOptionsSection() -> some View {
        HStack {
            ForEach(mainOptionsItems, id: \.self) { item in
                VStack(spacing: 0) {
                    CircleButtonView(iconName: item.iconName)
                    Text(item.title)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                }
                .onTapGesture {
                    profileVM.rowItemAction(item)
                }
            }
        } //:HSTACK
        .padding(10)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func accountSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Mi cuenta")
                .font(.title2).bold()
            
            VStack(spacing: 0) {
                ForEach(myAccountItems, id: \.self) { item in
                    ListItemView(item: item)
                        .onTapGesture {
                            profileVM.rowItemAction(item)
                        }
                    if myAccountItems.last != item {
                        Divider()
                    }
                }
            }
        }
        .hAling(.leading)
    }
    
    @ViewBuilder
    private func informationSection() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Información")
                .font(.title2).bold()
            
            VStack(spacing: 0) {
                ForEach(informationItem, id: \.self) { item in
                    ListItemView(item: item)
                        .onTapGesture {
                            profileVM.rowItemAction(item)
                        }
                    if informationItem.last != item {
                        Divider()
                    }
                }
            }
        }
        .hAling(.leading)
    }
}

// MARK: - PREVIEW

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView(tabSelection: .profile)
                .environmentObject(dev.authVM)
                .environmentObject(dev.profileVM)
        }
    }
}
