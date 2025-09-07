//
//  APIModel.swift
//  iConverse
//
//  Created by vipin on 04/09/25.
//

import Foundation

enum APIKey {
    // Fetch the API key from 'GenerativeAI-Info.plist'
    static var `default`: String {
        // Get the path of the plist file
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        
        // Load the plist into NSDictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        
        // Fetch the API_KEY value
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        
        // Check if the value is a placeholder
        if value.starts(with: "_") {
            fatalError("Follow the instructions at https://ai.google.dev/tutorials/setup to get a proper API key.")
        }
         
        return value

    }
}





struct Message: Identifiable ,Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let timestamp: Date
}






