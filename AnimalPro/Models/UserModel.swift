//
//  User.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation

enum LoginType: String, Codable {
    case guest
    case facebook
    case apple
    case phone
    case email
}

struct UserModel: Codable {
    let uid: String
    var names: String?
    var lastNames: String?
    var email: String?
    var phoneNumber: String?
    var birthday: String?
    var profileImageUrl: String?
    var locations: [String]?
    var pets: [PetModel]?
    var loginType: LoginType
    var isActive: Bool?
    
    init(uid: String, names: String? = nil, lastNames: String? = nil, email: String? = nil, phoneNumber: String? = nil, birthday: String? = nil, profileImageUrl: String? = nil, locations: [String]? = nil, pets: [PetModel]? = nil, loginType: LoginType, isActive: Bool? = nil) {
        self.uid = uid
        self.names = names
        self.lastNames = lastNames
        self.email = email
        self.phoneNumber = phoneNumber
        self.birthday = birthday
        self.profileImageUrl = profileImageUrl
        self.locations = locations
        self.pets = pets
        self.loginType = loginType
        self.isActive = isActive
    }
}
