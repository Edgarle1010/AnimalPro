//
//  MedicalProcedureModel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 16/01/23.
//

import Foundation

struct MedicalRecordModel: Codable {
    let id: Int
    let petId: Int
    let ownerId: String
    let medicId: Int
    let anamnesis: String
    let physicalExam: [PhysicalExamModel]
    let signs: [String]
    let presumptiveDiagnosis: [String]
    let diagnosticTests: [DiagnosticTestsModel]
    let process: String
    let definitiveDiagnosis: [String]
    let temporaryOwner: TemporaryOwnerModel
    let progressSheets: [ProgressSheetsModel]
    
    enum PhysicalExamType: String, Codable {
        case heartRate, breathingRate, temperature, swallowingReflex, coughReflex,
             spanPercussion, lungFields, abdominalPalpation, pulse, mucousMembranes,
             capitalFillingTime, lymphNodes, bodyCondition, weight, consciousnessState
    }
    
    struct PhysicalExamModel: Codable {
        let id: Int
        let type: PhysicalExamType
        let result: String
    }
    
    struct DiagnosticTestsModel: Codable {
        let id: Int
        let name: String
        let result: String
        let evidences: [URL]
        let notes: String
    }
    
    struct TemporaryOwnerModel: Codable {
        let id: Int
        let name: String
        let phoneNumber: String
        let address: String
    }
    
    struct ProgressSheetsModel: Codable {
        let id: Int
        let reasonReview: String
        let anamnesis: String
        let physicalExam: [PhysicalExamModel]
        let signs: [String]
        let process: String
    }
}
