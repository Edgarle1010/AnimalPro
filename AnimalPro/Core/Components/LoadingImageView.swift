//
//  LoadingImageView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import SwiftUI
import ActivityIndicatorView

struct LoadingImageView: View {
    // MARK: - PROPERTIES
    
    var size: CGFloat = 100
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            ActivityIndicatorView(isVisible: .constant(true), type: .scalingDots())
                .foregroundColor(.theme.red)
                .frame(width: 50, height: 50)
        }
        .frame(width: size, height: size)
        .background {
            Color.theme.accent.opacity(0.1)
                .clipShape(Circle())
        }
    }
}

// MARK: - PREVIEW

struct LoadingImageView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingImageView()
    }
}
