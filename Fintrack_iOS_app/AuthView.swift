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
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLogin = true
    @State private var email = ""
    @State private var password = ""
    @State private var userName = ""
    

    var body: some View {
        NavigationStack {
            VStack {
                Text(isLogin ? "Login" : "Sign Up")
                    .font(.largeTitle)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                if !isLogin {
                    TextField("User Name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                Button(action: {
                    Task {
                        do {
                            if isLogin {
                                try await AuthService.logIn(email: email, password: password)
                            } else {
                                try await AuthService.signUp(email: email, password: password, userName: userName)
                                try await AuthService.logIn(email: email, password: password)
                            }
                            authViewModel.isAuthenticated = true
                        } catch {
                            print("Auth error: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text(isLogin ? "Login" : "Sign Up")
                }

                Button(action: {
                    isLogin.toggle()
                }) {
                    Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login")
                }

                NavigationLink(destination: DashboardView(), isActive: $authViewModel.isAuthenticated) { EmptyView() }
            }
            .padding()
        }
    }
}


//#Preview{
//    AuthView()
//}
//
