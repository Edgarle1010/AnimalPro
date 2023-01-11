//
//  User.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 08/01/23.
//

import Foundation

enum LoginType: String {
    case guest = "guest"
    case facebook = "FB"
    case apple = "APL"
    case phone = "Phone"
    case email = "Email"
}

struct UserModel {
    let email: String
}
