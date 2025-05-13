//
//  AuthView.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 3/27/25.
//

import SwiftUI
import FirebaseAuth

// Login/Signup UI
struct AuthView: View {
    @State var isLoggedIn: Bool = true
    @State var loginPage: Bool = true
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack{
            if (!authViewModel.isAuthenticated) {
                if (loginPage){
                    LoginView(loginPage: $loginPage)
                }
                else {
                    SignupView(loginPage: $loginPage)
                }
            }
        }
        // TODO: delete
        .onAppear {
            Task {
                try await authViewModel.logout()
            }
        }
        .padding()
        .environmentObject(authViewModel)
    }
}

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @Binding var loginPage: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                Task{
                    do{
                        try await authViewModel.login(email: email, password: password)
                        loginPage = false
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
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
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                Task{
                    do{
                        try await authViewModel.signup(email: email, password: password, userName: userName)
                        print("sign up successed")
                        loginPage = true
                    }
                    catch
                    {
                        print(error.localizedDescription)
                    }
                }
                
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

//#Preview{
//    AuthView()
//}
//
