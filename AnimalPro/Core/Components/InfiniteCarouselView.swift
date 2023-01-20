//
//  InfiniteCarouselView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 18/01/23.
//

import SwiftUI
import URLImage

struct InfiniteCarouselView: View {
    // MARK: - PROPERTIES
    
    @Binding var banners: [BannerModel]
    @Binding var currentIndex: Int
    @State private var fakeIndex: Int = 0
    @State private var offset: CGFloat = 0
    @State private var genericBanners: [BannerModel] = []
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    // MARK: - BODY
    
    var body: some View {
        TabView(selection: $fakeIndex) {
            ForEach(genericBanners, id: \.id) { banner in
                bannerImage(imageUrl: banner.urlImage)
                    .overlay {
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX)
                        }
                    }
                    .onPreferenceChange(OffsetKey.self) { offset in
                        self.offset = offset
                        
                        if fakeIndex == 0 && (offset > -2 && offset < 2) {
                            fakeIndex = genericBanners.count - 2
                        }
                        if fakeIndex == genericBanners.count - 1 && (offset > -2 && offset < 2) {
                            fakeIndex = 1
                        }
                        print(offset)
                    }
                    .tag(getIndex(banner: banner))
            }
        }
        .highPriorityGesture(
            DragGesture()
                .onChanged({ _ in
                    timer.upstream.connect().cancel()
                })
        )
        .overlay {
            HStack(spacing: 5) {
                ForEach(banners.indices, id: \.self) { index in
                    Capsule()
                        .fill(Color.white.opacity(currentIndex == index ? 1 : 0.55))
                        .frame(width: currentIndex == index ? 18 : 4, height: 4)
                }
            }
            .vAling(.bottom)
            .padding(.bottom, 20)
        }
        .edgesIgnoringSafeArea(.top)
        .frame(width: UIScreen.main.bounds.width, height: 230)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: currentIndex)
        .onAppear {
            genericBanners = banners
            
            guard var first = genericBanners.first else {
                return
            }
            
            guard var last = genericBanners.last else {
                return
            }
            
            first.id = UUID().uuidString
            last.id = UUID().uuidString
            
            genericBanners.append(first)
            genericBanners.insert(last, at: 0)
            
            fakeIndex = 1
        }
        .onChange(of: banners) { newValue in
            genericBanners = banners
            
            guard var first = genericBanners.first else {
                return
            }
            
            guard var last = genericBanners.last else {
                return
            }
            
            first.id = UUID().uuidString
            last.id = UUID().uuidString
            
            genericBanners.append(first)
            genericBanners.insert(last, at: 0)
            
            fakeIndex = 1
        }
        .onChange(of: fakeIndex) { newValue in
            currentIndex = fakeIndex - 1
            timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer) { _ in
            withAnimation {
                fakeIndex += 1
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func getIndex(banner: BannerModel) -> Int {
        let index = genericBanners.firstIndex { currentBanner in
            return currentBanner.id == banner.id
        } ?? 0
        
        return index
    }
}

// MARK: - EXTENSION

extension InfiniteCarouselView {
    @ViewBuilder
    private func bannerImage(imageUrl: URL) -> some View {
        URLImage(imageUrl) { progress in
            LoadingImageView()
        } failure: { error, retry in
            VStack {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 60))
                
                Text("Error")
                    .font(.caption2.bold())
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .foregroundColor(.theme.red)
        } content: { image, info in
            image
                .resizable()
                .ignoresSafeArea()
        }
    }
}

// MARK: - PREVIEW

struct InfiniteCarouselView_Preview: PreviewProvider {
    static var previews: some View {
        PetsView(petsVM: dev.petsVM)
    }
}

// MARK: - OFFSET KET

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
