//
//  MedicalAppointmentModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 16/01/23.
//

import Foundation

enum MedicalAppointmentType: String, Codable {
    case vaccine, dewormer, medical
}

struct MedicalAppointmentModel: Codable {
    let id: Int
    let scheduledDate: Date
    let name: String
    let type: MedicalAppointmentType
}
