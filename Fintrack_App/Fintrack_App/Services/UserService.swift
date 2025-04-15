//
//  UserService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//

import FirebaseFirestore
import Foundation

struct UserService {
    static func addUser(user:User) async throws {
        let data:[String:Any]=[
            "email":user.email,
            "group":user.group,
            "userName":user.userName,
            "createdAt":FieldValue.serverTimestamp()
        ]
        
        
        let db=Firestore.firestore()
        try await db.collection("user").addDocument(data: data)
        
    }
}
