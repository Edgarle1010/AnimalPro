//
//  PreviewProvider.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import Foundation

import SwiftUI
import CoreData

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() { }
    
    let authVM = AuthViewModel()
}
