//
//  UserService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//

import FirebaseFirestore

struct UserService {
    
    
    static func addUser(user: User) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document()
        
        var newUser = user
        newUser.id = docRef.documentID
        
        let encoded = try Firestore.Encoder().encode(newUser)
        try await docRef.setData(encoded)
    }
    
    
    static func addUserExpense(userId: String, expense: UserExpense) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId).collection("expenses").document()
        
        let encoded = try Firestore.Encoder().encode(expense)
        try await docRef.setData(encoded)
    }
}
