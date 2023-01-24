//
//  RaceListView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 22/01/23.
//

import SwiftUI

struct RaceListView: View {
    // MARK: - PROPERTIES
    
    @Binding var race: String
    let type: PetType
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var petsVM = PetsViewModel()
    @StateObject private var notificationService: NotificationService = .shared
    @State private var searchText: String = ""
    @State private var races: [String] = []
    
    private var searchResult: [String] {
        if searchText.isEmpty {
            return races
        }
        return races.filter { $0.contains(searchText) }
    }
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            backButton()
            SearchBarView(searchText: $searchText)
            listSection()
        }
        .vAling(.top)
        .task {
            do {
                races = try await petsVM.fetchRaces(type: type)
            } catch {
                notificationService.showBanner(error.localizedDescription, .danger)
            }
            
        }
        .spinner($petsVM.isLoading)
    }
}

// MARK: - EXTENSION

extension RaceListView {
    @ViewBuilder
    private func backButton() -> some View {
        ZStack {
            Text("Selecciona una raza")
                .font(.title3.bold())
                .hAling(.center)
            
            Button {
                dismiss()
            } label: {
                CircleButtonView(iconName: "xmark")
            }
            .hAling(.trailing)
        } //:HSTACK
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func listSection() -> some View {
        List {
            ForEach(searchResult.sorted(), id: \.self) { race in
                VStack {
                    Text(race)
                }
                .padding()
                .background(Color.white)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .onTapGesture {
                    self.race = race
                    dismiss()
                }
            }
        } //:LIST
        .listStyle(.plain)
    }
}

// MARK: - PREVIEW

struct RaceListView_Previews: PreviewProvider {
    static var previews: some View {
        RaceListView(race: .constant("Mestizo"), type: .dog)
    }
}
