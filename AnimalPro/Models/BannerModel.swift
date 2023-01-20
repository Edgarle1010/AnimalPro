//
//  BannerModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import Foundation

enum BannerAction: String, Codable {
    case shop, medic
}

struct BannerModel: Codable, Identifiable, Hashable {
    var id: String
    let imageUrl: String
    let action: BannerAction
    
    var urlImage: URL {
        return URL(string: imageUrl)!
    }
    
    init(id: String, imageUrl: String, action: BannerAction) {
        self.id = id
        self.imageUrl = imageUrl
        self.action = action
    }
}
