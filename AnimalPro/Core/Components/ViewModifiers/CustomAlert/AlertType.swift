//
//  AlertType.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 13/01/23.
//

import SwiftUI

enum AlertType {
    case success
    case error(title: String, message: String = "")
    
    /// Left button action text for the alert view
    var leftActionText: String {
        switch self {
        case .success:
            return "Sí, seguro."
        case .error(_, _):
            return "Go"
        }
    }
    
    /// Right button action text for the alert view
    var rightActionText: String {
        switch self {
        case .success:
            return "No, regresar."
        case .error(_, _):
            return "Cancel"
        }
    }
    
    func height(isShowVerticalButtons: Bool = false) -> CGFloat {
        switch self {
        case .success:
            return isShowVerticalButtons ? 300 : 220
        case .error(_, _):
            return isShowVerticalButtons ? 300 : 220
        }
    }
}
