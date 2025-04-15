//
//  GroupService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//


import Foundation
import FirebaseFirestore

struct GroupService {
    static func addGroup(group:Group) async throws{
        
        let data:[String:Any]=[
            "groupName":group.groupName,
            "groupMembers":group.groupMembers,
            "balance":group.balance,
            "createdAt":FieldValue.serverTimestamp()
        ]
        
        let db=Firestore.firestore()
        try await db.collection("group").addDocument(data: data)
    }
    
}
