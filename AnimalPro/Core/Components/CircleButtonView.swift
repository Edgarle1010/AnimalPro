//
//  CircleButtonView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 09/01/23.
//

import SwiftUI

import SwiftUI

struct CircleButtonView: View {
    // MARK: - PROPERTIES
    
    let iconName: String
    
    // MARK: - BODY
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.black)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .foregroundColor(Color(UIColor.systemGray5))
            )
            .shadow(
                color: Color.theme.tertiary.opacity(0.25),
                radius: 10, x: 0, y: 0)
            .padding()
    }
}

// MARK: - PREVIEW

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
