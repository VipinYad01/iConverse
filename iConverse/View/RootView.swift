//
//  RootView.swift
//  Firebase Authentication
//
//  Created by vipin on 22/08/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        if let _ = auth.user {
            OnboardingScreen()
                .transition(.move(edge: .trailing))// logged-in screen
        } else {
            LoginView()    // login screen
        }
    }
}

#Preview {
    RootView().environmentObject(AuthViewModel())
}
