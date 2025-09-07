//
//  SplashScreen.swift
//  iConverse
//
//  Created by vipin on 05/09/25.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var moveUpDown = false
    
    var body: some View {
        if isActive {
            RootView()
                .transition(.move(edge: .trailing))
        } else {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 0){
                    Image("Gemini1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 400 , height: 300)
                        .offset(y: -50)
                        .overlay(
                    Text("Starting Gemini AI chatbot")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: 30)
                        .offset(y: moveUpDown ? -10 : 10) // move up and down
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(autoreverses: true),
                            value: moveUpDown
                        )
                        .onAppear {
                            moveUpDown = true
                        }
                    )
                }
                .background(.black)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                           self.isActive = true
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    SplashScreen()
        .environmentObject(AuthViewModel())
}
