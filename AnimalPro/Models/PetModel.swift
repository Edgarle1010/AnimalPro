//
//  PetModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import Foundation

enum PetType: String, Codable, Hashable {
    case dog, cat, other
    
    var defaultUrlImage: String {
        switch self {
        case .cat: return "https://us.123rf.com/450wm/agrino/agrino1904/agrino190400005/agrino190400005.jpg?ver=6"
        case .dog: return "https://media.istockphoto.com/id/1307938519/vector/dog-silhouette-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=cVH6U7XMY3RVkdOAXpdlhDJRpPa1ILkAbS1Zag08V2M="
        case .other: return "https://i.pinimg.com/originals/b3/3b/af/b33baf9dfc063800c317dd3f269ae350.png"
        }
    }
    
    var title: String {
        switch self {
        case .dog: return "Perro"
        case .cat: return "Gato"
        case .other: return "Otro"
        }
    }
    
    var image: String {
        switch self {
        case .dog: return "dog"
        case .cat: return "cat"
        case .other: return "other"
        }
    }
}

enum BiologicalSex: String, Codable, Hashable {
    case male, female
    
    var title: String {
        switch self {
        case .male: return "Macho"
        case .female: return "Hembra"
        }
    }
    
    var image: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        }
    }
}

enum ReproductiveStatus: String, Codable {
    case whole, castrated
}

struct PetModel: Codable, Equatable {
    var id: String
    var petType: PetType
    var biologicalSex: BiologicalSex?
    var owners: [String]?
    var names: String
    var lastNames: String?
    var weight: Double?
    var birthday: String?
    var imageUrl: String?
    var race: String?
    var color: String?
    var reproductiveStatus: ReproductiveStatus?
    var vaccines: [VaccineModel]?
    var deworming: [DewormerModel]?
    var medicalRecord: [MedicalRecordModel]?
    var hospitalizations: [HospitalizationModel]?
    var upcomingAppointments: [MedicalAppointmentModel]?
    var isAlive: Bool?
    var deathDate: String?
    
    var urlImage: URL {
        return URL(string: imageUrl ?? petType.defaultUrlImage)!
    }
    
    init(id: String, petType: PetType, biologicalSex: BiologicalSex? = nil, owners: [String]? = nil, names: String, lastNames: String? = nil, weight: Double? = nil, birthday: String? = nil, imageUrl: String? = nil, race: String? = nil, color: String? = nil, reproductiveStatus: ReproductiveStatus? = nil, vaccines: [VaccineModel]? = nil, deworming: [DewormerModel]? = nil, medicalRecord: [MedicalRecordModel]? = nil, hospitalizations: [HospitalizationModel]? = nil, upcomingAppointments: [MedicalAppointmentModel]? = nil, isAlive: Bool? = nil, deathDate: String? = nil) {
        self.id = id
        self.petType = petType
        self.biologicalSex = biologicalSex
        self.owners = owners
        self.names = names
        self.lastNames = lastNames
        self.weight = weight
        self.birthday = birthday
        self.imageUrl = imageUrl
        self.race = race
        self.color = color
        self.reproductiveStatus = reproductiveStatus
        self.vaccines = vaccines
        self.deworming = deworming
        self.medicalRecord = medicalRecord
        self.hospitalizations = hospitalizations
        self.upcomingAppointments = upcomingAppointments
        self.isAlive = isAlive
        self.deathDate = deathDate
    }
}

extension PetModel {
    static func ==(lhs: PetModel, rhs: PetModel) -> Bool {
        return lhs.id == rhs.id
    }
}
