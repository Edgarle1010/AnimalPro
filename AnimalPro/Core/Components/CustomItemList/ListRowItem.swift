//
//  ListRowItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

enum ListRowItem: Hashable {
    case profile, centerHelp, history, payments
    case myPets, addresses, language, notifications
    case termsAndConditions, logOut
    
    var iconName: String {
        switch self {
        case .profile: return "person"
        case .centerHelp: return "person.fill.questionmark"
        case .history: return "list.bullet.rectangle.portrait"
        case .payments: return "creditcard"
        case .myPets: return "pawprint"
        case .addresses: return "mappin.and.ellipse"
        case .language: return "globe.americas"
        case .notifications: return "bell"
        case .termsAndConditions: return "info.circle"
        case .logOut: return "door.left.hand.open"
        }
    }
    
    var title: String {
        switch self {
        case .profile: return "Datos de Perfil"
        case .centerHelp: return "Centro de ayuda"
        case .history: return "Historial de compras"
        case .payments: return "Métodos de pago"
        case .myPets: return "Mis mascotas"
        case .addresses: return "Direcciones"
        case .language: return "Idioma"
        case .notifications: return "Notificaciones"
        case .termsAndConditions: return "Términos y Condiciones"
        case .logOut: return "Cerrar sesión"
        }
    }
    
    var withChevron: Bool {
        if self == .logOut {
            return false
        }
        return true
    }
}
