//
//  PreviewProvider.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import SwiftUI
import CoreData

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() { }
    
    let authVM = AuthViewModel()
    
    @StateObject var notifierVM: NotificationService = {
        let vm = NotificationService()
        vm.showBanner = true
        vm.bannerTitle = "No has dado los permisos para iniciar con Facebook"
        vm.bannerType = .danger
        return vm
    }()
    
    @StateObject var profileVM: ProfileViewModel = {
        let vm = ProfileViewModel()
        return vm
    }()
}
