//
//  ButtonPrimaryStyle.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 07/01/23.
//

import SwiftUI

struct ButtonPrimaryStyle: ButtonStyle {
    // MARK: - PROPERTIES
    
    var cornerRadius: CGFloat = 20
    var hPadding: CGFloat = 50
    var color: Color
    
    // MARK: - BODY
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(!configuration.isPressed ? color: color.opacity(0.8))
            .cornerRadius(cornerRadius)
            .font(Font.body.bold())
            .padding(.horizontal, hPadding)
    }
}

// MARK: - PREVIEW

struct ButtonPrimaryStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button("btn", action: { })
            .buttonStyle(ButtonPrimaryStyle(color: Color.theme.red))

    }
}
