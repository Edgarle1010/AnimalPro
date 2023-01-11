//
//  View.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/01/23.
//

import SwiftUI

extension View {
    func hAling(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAling(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func banner() -> some View {
        return self.modifier(BannerModifier())
    }
    
    func spinner(_ isLoading: Binding<Bool>) -> some View {
        return self.modifier(SpinnerModifierBinding(isLoading: isLoading))
    }
}
