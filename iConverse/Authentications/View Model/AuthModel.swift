//
//  AuthModel.swift
//  Firebase Authentication
//
//  Created by vipin on 22/08/25.
//

import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var authError: String? = nil
    @Published var isLoading = false
    @Published var userName : String = ""
    @Published var userEmail : String = ""
    
    init() {
    //     Listen for login/logout automatically
        Auth.auth().addStateDidChangeListener { _ , user in
            self.user = user
        }
    }
    
    func login(email: String, password: String , showAlert: Binding<Bool> , alertMessage: Binding<String> ) {
        guard !email.isEmpty else {
            alertMessage.wrappedValue = "Please enter your email"
            showAlert.wrappedValue = true
            return
        }
        guard !password.isEmpty else {
            alertMessage.wrappedValue = "Please enter your password"
            showAlert.wrappedValue = true
            return
        }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false // hide loader safely

                if let errorrr = error as NSError? {
                    switch AuthErrorCode(rawValue: errorrr.code) {
                    case .wrongPassword: alertMessage.wrappedValue = "Incorrect password"
                    case .invalidEmail: alertMessage.wrappedValue = "Invalid email"
                    case .userNotFound: alertMessage.wrappedValue = "User does not exist"
                    default: alertMessage.wrappedValue = errorrr.localizedDescription
                    }
                   
                    showAlert.wrappedValue = true
                    print("Error aa gaya bhai : \(errorrr.localizedDescription)")
                } else {
                    self.authError = nil
                    print("Account is created succcessfully ✅")
                    if let user = Auth.auth().currentUser {
                                 print("User email: \(user.email ?? "No email")")
                                 print("User UID: \(user.uid)") // unique ID in Firebase
                             }
                }
            }
        }
        


    }
    
    func signup(email : String , password : String , confirmPassword : String , fullName : String , alertMessage: Binding<String>,showAlert: Binding<Bool>,isLoading: Binding<Bool>) {
        
        guard !email.isEmpty else {
            alertMessage.wrappedValue = "Please enter your email"
            showAlert.wrappedValue = true
            return
        }
        guard !fullName.isEmpty else {
            alertMessage.wrappedValue = "Please enter your name"
            showAlert.wrappedValue = true
            return
        }
        guard !password.isEmpty else {
            alertMessage.wrappedValue = "Please enter your password"
            showAlert.wrappedValue = true
            return
        }
        guard !confirmPassword.isEmpty else {
            alertMessage.wrappedValue = "Please confirm your password"
            showAlert.wrappedValue = true
            return
        }
        guard confirmPassword == password else {
            alertMessage.wrappedValue = "Confirm password does not match"
            showAlert.wrappedValue = true
            return
        }

        // Start loader
        isLoading.wrappedValue = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            // Switch back to main thread
            DispatchQueue.main.async {
                // Stop loader
                isLoading.wrappedValue = false
                
                if let error = error {
                    // Show alert on error
                    alertMessage.wrappedValue = error.localizedDescription
                    showAlert.wrappedValue = true
                }
                else if let user = result?.user {
                                // Only update if user is successfully created
                                self.userName = fullName
                                self.userEmail = email
                                print("Account created ✅")
                                print("User email: \(user.email ?? "No email")")
                                print("User UID: \(user.uid)")
                            }
            }
    
        }
    }
    
    func logout() {
        try? Auth.auth().signOut()
        self.user = nil
    }
}
