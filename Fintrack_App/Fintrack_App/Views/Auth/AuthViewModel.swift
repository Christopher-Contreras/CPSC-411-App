//
//  AuthViewModel.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/1/25.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String? = nil
    
    init() {
        // If user is already logged in (session persists)
        self.isAuthenticated = Auth.auth().currentUser != nil
    }
    
    
    
    func login(email: String, password: String) async {
        
        // Skipped calling firebase in preview
        guard !ProcessInfo().isPreview else {
            print("Login skipped in preview.")
            return
        }
        
        // log in
        do{
            try await AuthService.logIn(email: email, password: password)
        }
        catch{
            errorMessage = error.localizedDescription
        }
        
    }
    
    
    
    func signup(email: String, password: String, userName: String) async {
        // skip preview
        guard !ProcessInfo().isPreview else {
            print("Signup skipped in preview.")
            return
        }
        
        // sign up for new user
        do{
            try await AuthService.signUp(email: email, password: password, userName: userName)
            isAuthenticated=true
        }
        catch{
            errorMessage=error.localizedDescription
            return
        }
        
        
        // add to user collection
        do{
            let newUser = User(
                email: email, group: [], userName: userName
            )
            
            try await UserService.addUser(user: newUser)
        }
        catch{
            print("❌ Error: \(error.localizedDescription)")
        }
    }
    
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
    
}


extension ProcessInfo {
    var isPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
