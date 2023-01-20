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
    
    @StateObject var petsVM: PetsViewModel = {
        let vm = PetsViewModel()
        vm.banners = [
            .init(
                id: "1",
                imageUrl: "https://firebasestorage.googleapis.com/v0/b/animalpro-d745f.appspot.com/o/images%2Fbanners%2Fbanner-2x1-gatos.jpg?alt=media&token=156dd004-4fb6-4e53-b675-ed2364a60d33",
                action: .shop),
            .init(id: "2", imageUrl: "https://firebasestorage.googleapis.com/v0/b/animalpro-d745f.appspot.com/o/images%2Fbanners%2Fbanner-food-10.jpg?alt=media&token=11f6ab26-ccbc-4a3f-8651-bf0bdd214c05", action: .shop)]
        return vm
    }()
    
    @State var banners: [BannerModel] = [
        .init(id: "1",
              imageUrl: "https://firebasestorage.googleapis.com/v0/b/animalpro-d745f.appspot.com/o/images%2Fbanners%2Fbanner-2x1-gatos.jpg?alt=media&token=156dd004-4fb6-4e53-b675-ed2364a60d33",
              action: .shop),
        .init(id: "2", imageUrl: "https://firebasestorage.googleapis.com/v0/b/animalpro-d745f.appspot.com/o/images%2Fbanners%2Fbanner-food-10.jpg?alt=media&token=11f6ab26-ccbc-4a3f-8651-bf0bdd214c05", action: .shop)]
}
