//
//  AuthService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// handle firebase call for authentication
struct AuthService {
    
    // sign up with email, password, and userName
    static func signUp(email: String, password: String, userName: String) async throws -> Void {
        
        do{
            let user = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // add user name
            let changeRequest=user.user.createProfileChangeRequest()
            changeRequest.displayName=userName
            
            try await changeRequest.commitChanges()
        }
        catch {
            throw error
        }
        
    }
    
    // login with email and password
    static func logIn(email: String, password: String) async throws -> Void {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    // log out
    static func logOut() async throws -> Void {
        try Auth.auth().signOut()
    }
}

// future plan
// update password / email
// verify email
