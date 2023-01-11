//
//  SpinnerModifierBinding.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/01/23.
//

import SwiftUI
import ActivityIndicatorView

struct SpinnerModifierBinding: ViewModifier {
    @Binding var isLoading: Bool
    let kPreviewBackground = Color.theme.tertiary.opacity(0.1)
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
                .blur(radius: isLoading ? 1 : 0)
            
            if isLoading {
                ZStack {
                    ActivityIndicatorView(isVisible: $isLoading, type: .arcs(count: 5))
                        .frame(width: 100.0, height: 100.0)
                        .foregroundColor(.theme.red)
                        .transition(.scale)
                } //:ZSTACK
                .animation(.easeInOut(duration: 1.2), value: isLoading)
            }
        }
    }
}

// MARK: - PREVIEW

struct SpinnerModifierBinding_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberView()
            .environmentObject(dev.authVM)
            .modifier(SpinnerModifierBinding(isLoading: .constant(true)))
    }
}
