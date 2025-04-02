//
//  AuthView.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 3/27/25.
//

import SwiftUI
//import FirebaseAuth

struct AuthView: View {
    @State var isLoggedIn: Bool = true
    @State var loginPage: Bool = true
    
    var body: some View {
        VStack{
            if loginPage{ LoginView(loginPage: $loginPage) } else { SignupView(loginPage: $loginPage) }
        }
        .padding()
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var loginPage: Bool
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack{
            
            HStack{
                Text("Log In")
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.green)
                Spacer()
            }
            .padding()
            
                RoundedTextField(placeHolder: "Email", text: $email, isSecure: false)
                RoundedTextField(placeHolder: "Password", text: $password, isSecure: true)
            
            Button {
                authViewModel.login(email: email, password: password)
                
            } label: {
                Text("Log In")
                    .frame(width: 280, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .cornerRadius(10)
            }
            .padding()
            
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    loginPage = false
                }) {
                    Text("Sign Up")
                        .underline()
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                
                
            }
            .font(.footnote)
            .padding()
      
        }
        
    }
}

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var userName: String = ""
    @Binding var loginPage: Bool
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack{
            
            HStack{
                Text("Sign Up")
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.green)
                Spacer()
            }
            .padding()
            
                RoundedTextField(placeHolder: "Email", text: $email, isSecure: false)
                RoundedTextField(placeHolder: "User Name", text: $userName, isSecure: false)
                RoundedTextField(placeHolder: "Password", text: $password, isSecure: true)
            
            Button {
                authViewModel.signup(email: email, password: password, userName: userName)
                
            } label: {
                Text("Sign Up")
                    .frame(width: 280, height: 50)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .cornerRadius(10)
            }
            .padding()
            
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                
                Button(action: {
                    loginPage = true
                }) {
                    Text("Log In")
                        .underline()
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                
                
            }
            .font(.footnote)
            .padding()
      
        }
        
    }
}

#Preview{
    AuthView()
}

