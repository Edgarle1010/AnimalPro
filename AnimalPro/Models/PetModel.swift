//
//  PetModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import Foundation

enum PetType: String, Codable {
    case dog, cat, other
}

enum BiologicalSex: String, Codable {
    case male, female
}

enum ReproductiveStatus: String, Codable {
    case whole, castrated
}

struct PetModel: Codable {
    let id: Int
    let petType: PetType
    let biologicalSex: BiologicalSex
    let owners: [String]
    let names: String
    let lastNames: String
    let weight: Double
    let birthday: Date
    let imageUrl: String?
    let race: String
    let color: String
    let reproductiveStatus: ReproductiveStatus
    let vaccines: [VaccineModel]
    let deworming: [DewormerModel]
    let medicalRecord: [MedicalRecordModel]
    let upcomingAppointments: [MedicalAppointmentModel]
    let isAlive: Bool
}
