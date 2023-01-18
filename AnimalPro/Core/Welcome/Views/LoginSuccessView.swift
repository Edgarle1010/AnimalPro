//
//  LoginSuccessView.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 12/01/23.
//

import SwiftUI

struct LoginSuccessView: View {
    @AppStorage(SessionAppValue.loggedSuccess.rawValue) private var loggedSuccess = false
    @State private var initView: Bool = false
    
    var body: some View {
        VStack(spacing: 50) {
            Image("dog-footprint-fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .background {
                    Circle()
                        .fill(.green)
                        .frame(width: 130, height: 130)
                }
                .padding(.top, 130)
                .scaleEffect(initView ? 1 : 100)
                .offset(y: initView ? 0 : -500)
                .animation(.easeInOut(duration: 1.5), value: initView)
            
            Text("Bienvenido")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .foregroundColor(.theme.tertiary)
                .opacity(initView ? 1 : 0)
                .animation(.easeInOut(duration: 3.0), value: initView)
        }
        .navigationBarHidden(true)
        .hAling(.center)
        .vAling(.top)
        .background {
            Color.theme.accent
                .opacity(0.1)
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation {
                initView.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    loggedSuccess = false
                }
            }
        }
    }
}

struct LoginSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSuccessView()
    }
}
