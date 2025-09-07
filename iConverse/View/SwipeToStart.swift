//
//  SwipeToStart.swift
//  iConverse
//
//  Created by vipin on 05/09/25.
//

import SwiftUI

struct OnBoarding {
    var image : String
    var text : String
    var info : String
}

let onBoardingList: [OnBoarding] = [
    OnBoarding(
        image: "a",
        text: "Welcome to Gemini AI",
        info: "Your intelligent AI companion that helps you chat, create, and explore ideas effortlessly."
    ),
    OnBoarding(
        image: "b",
        text: "Ask Anything",
        info: "From coding help to creative writing, Gemini AI is ready to answer your questions instantly."
    ),
    OnBoarding(
        image: "c",
        text: "Generate Content",
        info: "Create text, summaries, or ideas for your projects, essays, or conversations in seconds."
    ),
    OnBoarding(
        image: "d",
        text: "Your Smart Assistant",
        info: "Stay productive, learn new things, or just have fun talking with Gemini AI anytime."
    )
]

    

struct OnboardingScreen: View {
    @State private var showHome = false
    var body: some View {
        if showHome {
            Chatbot()
                .transition(.move(edge: .trailing))
        } else {
            SwipeToStart(showHome: $showHome)
        }
    }
}
    

#Preview {
    OnboardingScreen()
}
    
    
struct SwipeToStart : View {
    @Binding var showHome: Bool
    @State var current : Int = 0
    var body : some View {
        VStack{
            
            HStack{
                Spacer()
                Button {
                    withAnimation {
                        showHome = true
                    }
                } label: {
                    Text("Skip")
                        .foregroundColor(.gray)
                }
                
            }
            
            
            TabView(selection: $current){
                ForEach(0..<4){ item in
                    VStack{
                        Image(onBoardingList[item].image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 250)
                            .clipped()
                        Text(onBoardingList[item].text)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                            .padding(.bottom)
                        Text(onBoardingList[item].info)
                            .fontDesign(.monospaced)
                            .multilineTextAlignment(.center)
                    }
                    .tag(item)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            
            HStack{
                ForEach(0..<4){ item in
                    if(item == current){
                        Rectangle()
                            .frame(width: 20,height: 10)
                            .cornerRadius(10)
                            .foregroundColor(.purple)
                    }
                    else{
                        Circle()
                            .frame(width: 20,height: 10)
                            .foregroundColor(.gray)
                    }
                }
                
            }
            .padding(.bottom,25)
            
            
            
            Button {
                withAnimation {
                    if(current<3){
                        current = current+1
                    }
                    else{
                        showHome = true
                        
                    }
                }
            } label: {
                Text(current < 3 ? "Next" : "Get Started")
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            
        }
        .padding(20)
        
    }
}



