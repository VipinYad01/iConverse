//
//  Login View.swift
//  Firebase Authentication
//
//  Created by vipin on 13/07/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @EnvironmentObject var auth: AuthViewModel
    
    var body: some View {
        NavigationView{
                VStack(spacing: 16 ){
                    
                    // logo
                    logo
                    
                    // title
                    titleView
                    
                    Spacer()
                        .frame(height: 12)
                    
                    // textfields
                    InputView(
                        placeholder: "Email or Phone number",
                        text: $email
                    )
                    InputView(
                        placeholder: "Password",
                        isSecureField : true,
                        text: $password
                    )
                    
                    // forgot button
                    forgotButton
                    
                    
                    // login button
                    loginButton
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // bottom view
                    BottomView
                    
                }
                .ignoresSafeArea()
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom,8)

        }
    }
    
    var logo : some View {
        Image("group")
            .resizable()
            .scaledToFit()
    }
   
    var titleView : some View {
        Text("Use your own AI chatbot")
            .font(.title2)
            .fontWeight(.bold)
     }
    
    var forgotButton : some View {
        HStack {
            Spacer()
            Button {
            }
            label: {
                Text("Forgot Password?")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
      }
    
    var loginButton : some View {
        VStack {
            
            if auth.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button {
                    auth.login(email: email, password: password , showAlert : $showAlert, alertMessage: $alertMessage)
                }
                label: {
                    Text ("Login")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color.purple))
                }
            }

        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Login Failed"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    var BottomView : some View {
        VStack(spacing: 16) {
            orView
            appleView
            googleView
            footerView
        }
    }
    
    var orView : some View {
        HStack(spacing: 8){
            VStack{
                Divider()
            }
            Text("or")
            VStack{
                Divider()
            }
        }
        .foregroundColor(.gray)
    }
    
    var appleView : some View {
        Button {
        }
        label: {
            HStack{
                Image(systemName: "apple.logo")
                    .foregroundColor(.white)
                Text ("Sign up with Apple")
                    .foregroundStyle(.white)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Capsule().fill(Color.black))
            
        }
    }
    
    var googleView : some View {
        Button {
        }
        label: {
            HStack{
                Image("google")
                    .resizable()
                    .frame(width: 18 , height: 18)
                Text ("Sign up with Google")
                    .foregroundColor(.black)
                
            }
            .padding()
            .frame(maxWidth: .infinity)
            .overlay {
                Capsule()
                    .stroke(.gray , lineWidth: 1)
            }
        }

    }
    
    var footerView : some View {
        NavigationLink{
            CreateAccountView()
        } label: {
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.black)
                Text("Sign up")
                    .foregroundColor(.blue)
            }
            .fontWeight(.medium)
        }
    }
    
        

}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}
