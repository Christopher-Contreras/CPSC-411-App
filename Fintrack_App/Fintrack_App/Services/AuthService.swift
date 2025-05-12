//
//  AuthService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthService {
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
    
    
    static func logIn(email: String, password: String) async throws -> Void {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    static func logOut() async throws -> Void {
        try Auth.auth().signOut()
    }
}

// update password / email
// verify email
