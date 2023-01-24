//
//  CustomCarousel.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 21/01/23.
//

import SwiftUI

struct CustomCarousel<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
    // MARK: - PROPERTIES
    
    var content: (Item.Element, CGSize) -> Content
    var id: KeyPath<Item.Element, ID>
    
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    @GestureState private var translation: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @State private var currentIndex: Int = 0
    @State private var rotation: Double = 0
    
    init(index: Binding<Int>, items: Item, spacing: CGFloat = 30, cardPadding: CGFloat = 80, id: KeyPath<Item.Element, ID>, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
        self.content = content
        self.id = id
        self._index = index
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
    }
    
    // MARK: - BODY
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cardWith = size.width - (cardPadding - spacing)
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { item in
                    let index = indexOf(item: item)
                    content(item, CGSize(width: size.width - cardPadding, height: size.height))
                        .rotationEffect(.init(degrees: Double(index) * 5), anchor: .bottom)
                        .rotationEffect(.init(degrees: rotation), anchor: .bottom)
                        .offset(y: offsetY(index: index, cardWidth: cardWith))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: limitScroll())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged { onChanged(value: $0, cardWidth: cardWith) }
                    .onEnded { onEnd(value: $0, cardWidth: cardWith) }
            )
        }
        .padding(.top, 60)
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    // MARK: - FUNCTIONS
    
    private func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)
        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let In_Between = (index - 1) == self.index ? previous : next
        
        return index == self.index ? -60 - yOffset : In_Between
    }
    
    private func indexOf(item: Item.Element) -> Int {
        let array = Array(items)
        if let index = array.firstIndex(of: item) {
            return index
        }
        return 0
    }
    
    private func limitScroll() -> CGFloat {
        let extraSpace = (cardPadding / 2) - spacing
        if index == 0 && offset > extraSpace {
            return extraSpace + (offset / 4)
        } else if index == items.count - 1 && translation < 0 {
            return offset - (translation / 2)
        } else {
            return offset
        }
    }
    
    private func onChanged(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStoredOffset
        
        let progress = offset / cardWidth
        rotation = progress * 5
    }
    
    private func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        index = -currentIndex
        withAnimation(.easeInOut(duration: 0.25)) {
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace
            
            let progress = offset / cardWidth
            rotation = (progress * 5).rounded() - 1
        }
        lastStoredOffset = offset
    }
}

// MARK: - PREVIEW

struct CustomCarousel_Previews: PreviewProvider {
    static var previews: some View {
        PetsView(petsVM: dev.petsVM)
            .environment(\.urlImageService, dev.urlImageService)
    }
}
