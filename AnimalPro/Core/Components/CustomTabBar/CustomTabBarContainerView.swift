//
//  CustomTabBarContainerView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    // MARK: - PROPERTIES
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    // MARK: - BODY
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        } //:ZSTACK
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

// MARK: - PREVIEW

struct CustomTabBarContainer_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
        .home, .vet, .profile
    ]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
