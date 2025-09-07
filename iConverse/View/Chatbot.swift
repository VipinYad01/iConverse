//
//  Chatbot.swift
//  iConverse
//
//  Created by vipin on 04/09/25.
//

import SwiftUI
import PhotosUI
import GoogleGenerativeAI



struct Chatbot: View {
    
   @StateObject var model = GenerativeAIManager()
    @State private var userPromptText: String = ""
    @State private var showMenu = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        ZStack {
            
            Image("background")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                
            
            VStack {
                // Header
                HStack {
                    Button {
                        withAnimation {
                            showMenu = true
                        }
                    } label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Welcome to Gemini AI")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.white)
                    
                    Spacer()
                    Spacer() // keep text centered
                }
                .padding(.top, 25)
                .padding(.horizontal)

                

                // Chat ScrollView
                ChatView(model: model)


                // Input field + send button
                InputVieww(userPromptText: $userPromptText, model: model)
 
            }
            .padding(.horizontal)
            
            
            if showMenu{
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                    }
                }
            }
            
            if showMenu{
                withAnimation{
                    SideBarView(selectedImage: $selectedImage, model: model)
                        .transition(.move(edge: .leading))
                }
             
            }
        }
    }
       
}

 


#Preview {
      Chatbot()
        .environmentObject(AuthViewModel())
}


struct ChatView: View {
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var count: Int = 0
    @ObservedObject var model: GenerativeAIManager
    
    var body : some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 10) {
                        ForEach(model.messages) { msg in
                            HStack {
                                if msg.isUser { Spacer() }
                                
                                if !msg.isUser , msg.text.isEmpty {
                                    HStack(spacing: 5) {
                                        Circle()
                                            .offset(y: count == 1 ? -25 : 0)
                                        Circle()
                                            .offset(y: count == 2 ? -25 : 0)
                                        Circle()
                                            .offset(y: count == 3 ? -25 : 0)
                                        Circle()
                                            .offset(y: count == 4 ? -25 : 0)
                                    }
                                    .frame(width: 50)
                                    .foregroundColor(.purple)
                                    .onReceive(timer) { _ in
                                        withAnimation {
                                            if count == 4 {
                                                count = 0
                                            }
                                            else {
                                                count = count + 1
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                else{
                                    VStack(alignment: msg.isUser ? .trailing : .leading, spacing: 4) {
                                        Text("\(msg.isUser ? "You" : "Gemini AI")")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        Text(msg.text)
                                            .padding()
                                            .background(msg.isUser ? Color.blue.opacity(0.5) : Color.gray.opacity(0.5))
                                            .foregroundColor(.white)
                                            .cornerRadius(16)
                                        Text(msg.timestamp, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                if !msg.isUser { Spacer() }
                            }
                        }
                }
                
                .onChange(of: model.messages.count) { _ , _ in
                    // Auto-scroll to bottom on new message
                    if let lastId = model.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                
            }
            
        }
        
    }
}


struct InputVieww: View {
    
    @Binding var userPromptText: String
    @ObservedObject var model: GenerativeAIManager
    
    var body: some View {
        HStack {
            TextField("Ask something…", text: $userPromptText, axis: .vertical)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .lineLimit(4)
                .disableAutocorrection(true)
                .onSubmit {
                    model.sendMessage(userPromptText: $userPromptText)
                }
            
            Button {
                model.sendMessage(userPromptText: $userPromptText)
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.green)
                    .font(.system(size: 24))
            }
        }
        
    }
}


struct SideBarView: View {
    
    @EnvironmentObject var auth : AuthViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @Binding var selectedImage: UIImage?
    @State private var imageData: Data?
    @ObservedObject var model : GenerativeAIManager
    @State var showLogoutAlert : Bool = false
    @State var showClearchatsAlert : Bool = false
    
    var body: some View {
            // Side menu
            HStack {
                VStack(spacing: 20) {
                    
                    Spacer()
                        .frame(height: 60)
                    
                    Text("\(auth.userName)")
                        .font(.title2)
                        .bold()
                    Text("\(auth.userEmail)")
                        .font(.title2)
                        .bold()
                    
                    // MARK: - Photos Picker
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 5)
                        } else {
                            // Placeholder
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 180, height: 180)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .overlay(
                                    Text("Tap to select")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 5)

                        }
                        
                        
                    }
                    .onChange(of: selectedItem) { _ , newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               
                                let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                            
                        }
                    }
                    
                    if selectedImage == nil{
                        Text("Select your profile photo")
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                    }
                    
                    
                    // MARK: - Clear whole chats
                    Button {
                        withAnimation{
                            model.messages.removeAll()
                            showClearchatsAlert = true
                        }
                       
                    } label: {
                        Text("Clear Chats")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(7)
                          
                    }

                    // MARK: - Logout button
                    Button {
                        showLogoutAlert = true
                    } label: {
                        Text("Log out")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.white)
                            .padding()
                            .background(.black)
                            .cornerRadius(7)
                          
                    }
 
                    
                    Spacer()
                    
                }
                .frame(width: 300)
                .background(.gray)
                Spacer()
            }
            .alert("Are you sure you want to logout?", isPresented: $showLogoutAlert) {
                Button("Yes", role: .destructive) {
                    auth.logout()
                }
            }
            .alert("Chats cleared successfully ✅", isPresented: $showClearchatsAlert) {
                Button("OK", role: .cancel) {
                    
                }
            }
        

        }
        
    }
    

