//
//  NotificationVM.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/01/23.
//

import SwiftUI

class NotificationService: ObservableObject {
    static let shared = NotificationService()
    
    @Published var showBanner: Bool = false
    @Published var bannerTitle: String = ""
    @Published var bannerType: AlertGeneralType = .normal
    
    func showBanner(_ title: String, _ type: AlertGeneralType = .normal) {
        bannerTitle = title
        bannerType = type
        withAnimation(.spring()) {
            showBanner = true
        }
    }
}

enum AlertGeneralType: String {
    case normal
    case danger
    case warning
    case success
    case info
    
    var icon: String {
        switch self {
        case .normal: return ""
        case .danger: return "exclamationmark.circle"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle"
        case .info: return "info.bubble"
        }
    }
    
    var colorIcon: Color {
        switch self {
        case .normal: return Color.clear
        case .danger: return Color.red
        case .warning: return Color.white
        case .success: return Color.green
        case .info: return Color.blue
        }
    }
}
