//
//  BannerModifier.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/01/23.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    // MARK: - PROPERTIES
    
    @EnvironmentObject var observer: NotificationService
    @State private var draggOffSet: CGSize = CGSize.zero
    @State private var task: DispatchWorkItem?
    
    // MARK: - BODY
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .transition(.slide)
                .zIndex(0)
            
            if observer.showBanner {
                roundedBanner()
                    .padding()
                    .padding(.horizontal, 5)
                    .vAling(.top)
                    .offset(y: self.draggOffSet.height)
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onChanged({ (value) in
                                if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                                    self.draggOffSet = value.translation
                                }
                            })
                            .onEnded({ value in
                                withAnimation(.easeInOut) {
                                    observer.showBanner = false
                                    self.draggOffSet = .zero
                                }
                            }))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            observer.showBanner = false
                        }
                    }
                    .onAppear {
                        self.task = DispatchWorkItem {
                            withAnimation(.easeOut(duration: 10)) {
                                observer.showBanner = false
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: self.task!)
                    }
                    .onDisappear {
                        self.task?.cancel()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
    }
}

// MARK: - EXTENSION

extension BannerModifier {
    @ViewBuilder
    private func roundedBanner() -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                if let bannerType = observer.bannerType, bannerType != .normal {
                    Image(systemName: bannerType.icon)
                        .imageScale(.large)
                        .foregroundColor(bannerType.colorIcon)
                }
                
                Text("\(observer.bannerTitle)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color.white)
                    .padding(8)
            }
        }
        .hAling(.center)
        .padding(12)
        .background(Color.black)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

// MARK: - PREVIEW

struct BannerModifier_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .banner()
            .environmentObject(dev.notifierVM)
            .environmentObject(dev.authVM)
    }
}
