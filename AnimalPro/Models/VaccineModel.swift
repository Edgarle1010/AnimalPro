//
//  VaccineModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 16/01/23.
//

import Foundation

struct VaccineModel: Codable {
    let id: Int
    let name: String
    let laboratory: String
    let lote: String
    let dateExpiry: Date
    let applicationDate: Date
    let periodValidity: Date
}
