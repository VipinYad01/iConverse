//
//  iConverseApp.swift
//  iConverse
//
//  Created by vipin on 04/09/25.
//

import SwiftUI
import Firebase

@main
struct iConverseApp: App {
    @StateObject var auth = AuthViewModel()
    
    init() {
        FirebaseApp.configure() // setup Firebase
    }
    var body: some Scene {
        WindowGroup {
              SplashScreen()
                .environmentObject(auth)
        }
    }
}
 
