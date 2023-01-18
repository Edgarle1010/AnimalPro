//
//  HospitalizationModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 16/01/23.
//

import Foundation

enum HospitalizationType: String, Codable {
    case critical, normal
}

struct HospitalizationModel: Codable {
    let id: Int
    let petId: Int
    let ownerId: String
    let medicalRecordId: Int
    let type: HospitalizationType
    let dateAdmission: Date
    let egressDate: Date
    let notes: [String]
}
