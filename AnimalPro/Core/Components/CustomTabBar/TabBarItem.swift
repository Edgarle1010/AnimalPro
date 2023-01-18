//
//  TabBarItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

enum TabBarItem: Hashable {
    case home, vet, profile
    
    var iconName: String {
        switch self {
        case .home: return "pawprint"
        case .vet: return "stethoscope"
        case .profile: return "person"
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .theme.red
        case .vet: return .theme.red
        case .profile: return .theme.red
        }
    }
}
