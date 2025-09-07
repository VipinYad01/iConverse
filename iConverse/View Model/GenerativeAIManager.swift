//
//  GenerativeAIManager.swift
//  iConverse
//
//  Created by vipin on 04/09/25.
//


import Foundation
import SwiftUI
import GoogleGenerativeAI


@MainActor
class GenerativeAIManager : ObservableObject {
    let model = GenerativeModel(name: "gemini-2.5-flash-lite", apiKey: APIKey.default)
    
    @Published var messages: [Message] = []
    
    func sendMessage(userPromptText: Binding<String>) {
        guard !userPromptText.wrappedValue.isEmpty else { return }
        
        // Add user message
        let userMsg = Message(text: userPromptText.wrappedValue, isUser: true, timestamp: Date())
        messages.append(userMsg)
        
        let prompt = userPromptText.wrappedValue
        userPromptText.wrappedValue = ""
        
        
        
        // Get AI response
        Task {
            do {
                let tillAIResponse = Message(text: "" , isUser: false, timestamp: Date())
                messages.append(tillAIResponse)
                let result = try await model.generateContent(prompt)
                let aiMsg = Message(text: result.text ?? "No response found", isUser: false, timestamp: Date())
                messages.removeAll { $0.id == tillAIResponse.id }
                messages.append(aiMsg)
                
            } catch {
                let errorMsg = Message(text: "Error: \(error.localizedDescription)", isUser: false, timestamp: Date())
                messages.append(errorMsg)            }
        }
    }
    
}











