//
//  PetsViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 19/01/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

protocol PetsViewModelProtocol: ObservableObject {
    var banners: [BannerModel] { get set }
    var pets: [PetModel] { get set }
    var inputImage: UIImage? { get set }
    var dataPetItems: [ListTextFieldItemView] { get set }
    var showAddPet: Bool { get set }
    var showDetailPet: Bool { get set }
    var isLoading: Bool { get set }
    var firebaseAuth: Auth { get }
    var db: Firestore { get }
    var storage: Storage { get }
    var delegate: PetsDelegate? { get set }
    
    func fetchBanners() async throws
    func fetchRaces(type: PetType) async throws -> [String]
    func fetchProfileTextField() async
    func validatePetData() -> Bool
    func savePet()
}

class PetsViewModel: PetsViewModelProtocol {
    @Published var banners: [BannerModel] = []
    @Published var pets: [PetModel] = []
    @Published var currentPet: PetModel?
    @Published var inputImage: UIImage?
    @Published var dataPetItems: [ListTextFieldItemView] = []
    @Published var showAddPet: Bool = false
    @Published var showDetailPet: Bool = false
    @Published var isLoading: Bool = false
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var delegate: PetsDelegate?
    
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
    
    @MainActor
    func fetchRaces(type: PetType) async throws -> [String] {
        isLoading = true
        do {
            let snapshot = try await db.collection("races").document("\(type)s").collection("races").getDocuments()
            let data = snapshot.documents.compactMap { return $0.data() }
            let result = data.compactMap { $0["nameEs"] as? String }
            isLoading = false
            return result
        } catch {
            isLoading = false
            throw error
        }
    }
    
    @MainActor
    func fetchProfileTextField() async {
        if currentPet != nil {
            dataPetItems = [
                .init(textFieldText: Binding(
                    get: { self.currentPet!.biologicalSex?.rawValue ?? "male" },
                    set: { self.currentPet!.biologicalSex = BiologicalSex(rawValue: $0) }
                ), type: .biologicalSex),
                .init(textFieldText: Binding(
                    get: { self.currentPet!.names },
                    set: { self.currentPet!.names = $0 }
                ), type: .names),
                .init(textFieldText: Binding(
                    get: { self.currentPet!.lastNames ?? "" },
                    set: { self.currentPet!.lastNames = $0 }
                ), type: .lastNames),
                .init(textFieldText: Binding(
                    get: { self.currentPet!.race ?? "" },
                    set: { self.currentPet!.race = $0 }
                ), type: .race, petType: self.currentPet!.petType),
                .init(textFieldText: Binding(
                    get: { self.currentPet!.birthday ?? "" },
                    set: { self.currentPet!.birthday = $0 }
                ), type: .birthday)]
        }
    }
    
    func validatePetData() -> Bool {
        guard let pet = currentPet else { return false }
        if inputImage == nil { return false }
        if pet.names.isEmpty { return false }
        if ((pet.lastNames?.isEmpty) == nil) { return false }
        if ((pet.race?.isEmpty) == nil) { return false }
        if ((pet.birthday?.isEmpty) == nil) { return false }
        return true
    }
    
    @MainActor
    func updatePet() {
        guard let pet = currentPet else { return }
        guard let inputImage = inputImage else { return }
        guard let data = inputImage.jpegData(compressionQuality: 0.5) else { return }
        let storageRef = storage.reference().child("images/pets/\(pet.id)/profile.jpg")
        
        isLoading = true
        storageRef.putData(data) { metadata, error in
            self.isLoading = false
            if let error = error {
                self.delegate?.onError(error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self.delegate?.onError(error.localizedDescription)
                    return
                }
                
                self.isLoading = true
                self.db.collection("pets").whereField("id", isEqualTo: pet.id).getDocuments { querySnapshot, error in
                    self.isLoading = false
                    if let error = error {
                        self.delegate?.onError(error.localizedDescription)
                        return
                    }
                    
                    let document = querySnapshot?.documents.first?.reference
                    
                    Task {
                        self.isLoading = true
                        do {
                            try await document?.updateData(["imageUrl": url!.absoluteString])
                            try? await self.fetchPets()
                            self.isLoading = false
                            self.delegate?.onSuccess("Se actualizaró la información de tu mascota.")
                        } catch {
                            self.delegate?.onError(error.localizedDescription)
                            self.isLoading = false
                        }
                    }
                }
            }
        }
    }
    
    func savePet() {
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        guard var pet = currentPet else { return }
        guard let inputImage = inputImage else { return }
        guard let data = inputImage.jpegData(compressionQuality: 0.5) else { return }
        let storageRef = storage.reference().child("images/pets/\(pet.id)/profile.jpg")
        
        isLoading = true
        storageRef.putData(data) { metadata, error in
            self.isLoading = false
            if let error = error {
                self.delegate?.onError(error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    self.delegate?.onError(error.localizedDescription)
                    return
                }
                
                let docRef = self.db.collection("pets").document()
                pet.imageUrl = url!.absoluteString
                pet.owners = [uid]
                self.isLoading = true
                do {
                    try docRef.setData(from: pet)
                    self.delegate?.onSuccess("Tu mascota se guardó correctamente.")
                    self.isLoading = false
                    Task {
                        try await self.fetchPets()
                    }
                } catch {
                    self.delegate?.onError(error.localizedDescription)
                    self.isLoading = false
                }
            }
        }
    }
    
    @MainActor
    func fetchPets() async throws {
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        
        isLoading = true
        do {
            let snapshot = try await db.collection("pets").whereField("owners", arrayContains: uid).getDocuments()
            pets = snapshot.documents.compactMap { return try? $0.data(as: PetModel.self) }
            isLoading = false
        } catch {
            isLoading = false
            throw "Ocurrio un problema al actualizar la información de tus mascotas."
        }
    }
}
