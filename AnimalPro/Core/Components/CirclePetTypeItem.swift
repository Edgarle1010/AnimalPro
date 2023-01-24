//
//  CirclePetTypeItem.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 21/01/23.
//

import SwiftUI

struct CirclePetTypeItem: View {
    // MARK: - PROPERTIES
    
    let type: PetType
    @Binding var localSelection: PetType
    @Namespace private var namespace
    
    // MARK: - BODY
    
    var body: some View {
        VStack(spacing: 10) {
            Image(type.image)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: 100)
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
                .font(.title3.bold())
                .foregroundColor(localSelection == type ? .theme.red : .black)
        }
    }
}

// MARK: - PREVIEW

struct CirclePetTypeItem_Previews: PreviewProvider {
    static var previews: some View {
        CirclePetTypeItem(type: .dog, localSelection: .constant(.dog))
        CirclePetTypeItem(type: .dog, localSelection: .constant(.cat))
    }
}
