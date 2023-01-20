//
//  ProfileViewModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

protocol ProfileViewModelProtocol: ObservableObject {
    var user: UserModel? { get set }
    var isLoading: Bool { get set }
    var showAlert: Bool { get set }
    var showProfileData: Bool { get set }
    var dataUserItems: [ListTextFieldItemView] { get set }
    var inputImage: UIImage? { get set }
    var firebaseAuth: Auth { get }
    var db: Firestore { get }
    var storage: Storage { get }
    var delegate: ProfileDelegate? { get set }
    var urlProfileImage: URL { get }
    var authVM: AuthViewModel { get }
    
    func fetchUserData() async throws
    func fetchProfileTextField() async
    func rowItemAction(_ item: ListRowItem)
    func validatePhoneNumber() -> Bool
    func loadImage() async throws
}

class ProfileViewModel: ProfileViewModelProtocol {
    @Published var user: UserModel?
    @Published var isLoading: Bool = false
    @Published var showAlert: Bool = false
    @Published var showProfileData: Bool = false
    @Published var dataUserItems: [ListTextFieldItemView] = []
    @Published var inputImage: UIImage?
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var delegate: ProfileDelegate?
    
    var urlProfileImage: URL {
        URL(string: user?.profileImageUrl ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png")!
    }
    
    lazy var authVM = AuthViewModel()
    
    // MARK: - PUBLIC
    
    @MainActor
    func fetchUserData() async throws {
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        do {
            let document = try await docRef.getDocument()
            user = try document.data(as: UserModel.self)
        } catch {
            throw error
        }
    }
    
    @MainActor
    func fetchProfileTextField() async {
        guard var user = user else { return }
        
        dataUserItems = [
            .init(textFieldText: Binding(
                get: { user.names ?? "" },
                set: { user.names = $0 }
            ), type: .names),
            .init(textFieldText: Binding(
                get: { user.lastNames ?? "" },
                set: { user.lastNames = $0 }
            ), type: .lastNames),
            .init(textFieldText: Binding(
                get: { user.email ?? "" },
                set: { user.email = $0 }
            ), type: .email),
            .init(textFieldText: Binding(
                get: { user.phoneNumber ?? "" },
                set: { user.phoneNumber = $0 }
            ), type: .phoneNumber),
            .init(textFieldText: Binding(
                get: { user.birthday ?? "" },
                set: { user.birthday = $0 }
            ), type: .birthday)]
    }
    
    @MainActor
    func updateUserData() async throws {
        var updateDate: [String: Any] = [:]
        for item in dataUserItems {
            updateDate[item.type.rawValue] = item.textFieldText
        }
        
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        let docRef = db.collection("users").document(uid)
        
        isLoading = true
        do {
            try await docRef.updateData(updateDate)
            isLoading = false
        } catch {
            isLoading = false
            throw error
        }
    }
    
    func rowItemAction(_ item: ListRowItem) {
        switch item {
        case .profile:
            showProfileData.toggle()
        case .centerHelp:
            print(item.title)
        case .history:
            print(item.title)
        case .payments:
            print(item.title)
        case .myPets:
            print(item.title)
        case .addresses:
            print(item.title)
        case .language:
            print(item.title)
        case .notifications:
            print(item.title)
        case .termsAndConditions:
            print(item.title)
        case .logOut:
            withAnimation(.easeInOut) {
                showAlert.toggle()
            }
        }
    }
    
    func validatePhoneNumber() -> Bool {
        guard let firestoreUser = user else { return false }
        guard let authUser = firebaseAuth.currentUser else  { return false }
        
        if firestoreUser.phoneNumber == authUser.phoneNumber {
            return true
        }
        return false
    }
    
    @MainActor
    func loadImage() {
        guard let inputImage = inputImage else { return }
        guard let uid = firebaseAuth.currentUser?.uid else { return }
        guard let data = inputImage.jpegData(compressionQuality: 0.5) else { return }
        let storageRef = storage.reference().child("images/users/\(uid)/profile.jpg")
        
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
                
                let docRef = self.db.collection("users").document(uid)
                docRef.updateData(["profileImageUrl": url!.absoluteString]) { error in
                    if let error = error {
                        self.delegate?.onError(error.localizedDescription)
                        return
                    }
                    self.delegate?.onSuccess("Tu imagén de perfil se actualizó correctamente.")
                    Task {
                        try? await self.fetchUserData()
                    }
                }
            }
        }
    }
}
