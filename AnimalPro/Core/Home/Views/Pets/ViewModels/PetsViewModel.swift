//
//  PetsViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 19/01/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PetsViewModelProtocol: ObservableObject {
    var banners: [BannerModel] { get set }
    var db: Firestore { get }
    
    func fetchBanners() async throws
}

class PetsViewModel: PetsViewModelProtocol {
    @Published var banners: [BannerModel] = []
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    // MARK: - PRIVATE
    
    @MainActor
    func fetchBanners() async throws {
        do {
            let snapshot = try await db.collection("banners").getDocuments()
            banners = snapshot.documents.compactMap { return try? $0.data(as: BannerModel.self) }
        } catch {
            throw error
        }
    }
}
