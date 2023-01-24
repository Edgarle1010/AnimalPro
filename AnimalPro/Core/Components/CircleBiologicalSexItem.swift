//
//  CircleBiologicalSexItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 22/01/23.
//

import SwiftUI

struct CircleBiologicalSexItem: View {
    // MARK: - PROPERTIES
    
    let type: BiologicalSex
    @Binding var localSelection: BiologicalSex
    @Namespace private var namespace
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            Image(type.image)
                .resizable()
                .scaledToFit()
                .padding(20)
                .frame(width: 80)
                .background(
                    ZStack {
                        if localSelection == type {
                            Circle()
                                .fill(Color.theme.primary.opacity(0.8))
                                .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                        }
                    }
                )
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(localSelection == type ? Color.theme.red : Color.white, lineWidth: 4)
                        .shadow(radius: 5)
                )
            
            Text(type.title)
                .font(.body.bold())
                .foregroundColor(localSelection == type ? .theme.red : .black)
        }
    }
}

// MARK: - PREVIEW

struct CircleBiologicalSexItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleBiologicalSexItem(type: .male, localSelection: .constant(.male))
            CircleBiologicalSexItem(type: .female, localSelection: .constant(.male))
        }
    }
}
