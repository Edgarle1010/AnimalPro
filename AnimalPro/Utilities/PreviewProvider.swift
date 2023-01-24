//
//  PreviewProvider.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import SwiftUI
import CoreData
import URLImage
import URLImageStore

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() { }
    
    let authVM = AuthViewModel()
    let urlImageService = URLImageService(fileStore: URLImageFileStore(),
                                              inMemoryStore: URLImageInMemoryStore())
    
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
                imageUrl: "https://animalpro-storage-cfa8f616163310-staging.s3.amazonaws.com/images/banners/banner-food-10.jpg",
                action: .shop),
            .init(
                id: "2",
                imageUrl: "https://animalpro-storage-cfa8f616163310-staging.s3.amazonaws.com/images/banners/banner-2x1-gatos.jpg",
                action: .shop)]
        vm.pets = [.init(id: "1", petType: .dog, biologicalSex: .male, names: "Paco", imageUrl: "https://images.alphacoders.com/247/thumb-1920-247333.jpg"),
                   .init(id: "2", petType: .cat, biologicalSex: .female, names: "Michi", imageUrl: "https://c4.wallpaperflare.com/wallpaper/348/422/333/cat-4k-hd-wallpaper-preview.jpg"),
                   .init(id: "3", petType: .dog, biologicalSex: .male, names: "Paco", imageUrl: "https://images.alphacoders.com/247/thumb-1920-247333.jpg"),
                   .init(id: "4", petType: .cat, biologicalSex: .female, names: "Michi", imageUrl: "https://c4.wallpaperflare.com/wallpaper/348/422/333/cat-4k-hd-wallpaper-preview.jpg")]
        vm.currentPet = .init(id: UUID().uuidString, petType: .dog, names: "")
        return vm
    }()
    
    @StateObject var petsVM1: PetsViewModel = {
        let vm = PetsViewModel()
        vm.banners = [
            .init(
                id: "1",
                imageUrl: "https://animalpro-storage-cfa8f616163310-staging.s3.amazonaws.com/images/banners/banner-food-10.jpg",
                action: .shop),
            .init(
                id: "2",
                imageUrl: "https://animalpro-storage-cfa8f616163310-staging.s3.amazonaws.com/images/banners/banner-2x1-gatos.jpg",
                action: .shop)]
        return vm
    }()
}
