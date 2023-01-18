//
//  ListItemView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

struct ListItemView: View {
    // MARK: - PROPERTIES
    
    let item: ListRowItem
    
    // MARK: - BODY
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: item.iconName)
                .imageScale(.large)
            Text(item.title)
                .font(.callout)
                .fontWeight(.thin)
            Spacer()
            if item.withChevron {
                Image(systemName: "chevron.right")
                    .font(.callout.bold())
            }
        } //:HSTACK
        .padding(.vertical)
        .padding(.trailing)
    }
}

// MARK: - PREVIEW

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(item: .myPets)
    }
}
