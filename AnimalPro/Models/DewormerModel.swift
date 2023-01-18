//
//  DewormerModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 16/01/23.
//

import Foundation

enum DewormerType: String, Codable {
    case inter, exter
}

struct DewormerModel: Codable {
    let id: Int
    let type: DewormerType
    let name: String
    let laboratory: String
    let dose: String
    let dateExpiry: Date
    let applicationDate: Date
}
