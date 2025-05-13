//  AuthViewModel.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/1/25.
//



import Foundation
import FirebaseAuth
import FirebaseFirestore

// Login/Signup UI logic
@MainActor
class AuthViewModel: ObservableObject {
    //@Published var isAuthenticated = false
    @Published var isAuthenticated: Bool = Auth.auth().currentUser != nil
    
    init() {
        // If user is already logged in (session persists)
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    func login(email: String, password: String) async throws{
        
        // Skipped calling firebase in preview
        guard !ProcessInfo().isPreview else {
            print("Login skipped in preview.")
            return
        }
        
        // log in
        do{
            try await AuthService.logIn(email: email, password: password)
            isAuthenticated=true
        }
        catch {
            throw error
        }
        
    }
    
    func signup(email: String, password: String, userName: String) async throws {
        
        // skip preview
        guard !ProcessInfo().isPreview else {
            print("Signup skipped in preview.")
            return
        }
        
        // sign up for new user
        do{
            try await
            AuthService.signUp(email: email, password: password, userName: userName)
            
            
            // add to user collection
//            let newUser = User(
//                email: email, userName: userName, group: []
//            )
//
//            try UserService.addUser(user: newUser)
            
            
        }
        catch{
            throw error
        }
    }
    
    
    

       func logout() async throws {
           try await AuthService.logOut()
           DispatchQueue.main.async {
               self.isAuthenticated = false
           }
       }
}

extension ProcessInfo {
    var isPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
