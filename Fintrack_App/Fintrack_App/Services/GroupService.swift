//
//  GroupService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//


import Foundation
import FirebaseFirestore

// TODO: test all of them it should be good though
struct GroupService {

    static func addGroup(_ group: Group) async throws{
        let db = Firestore.firestore()
        let docRef = db.collection("group").document()

        var newGroup = group
        newGroup.id = docRef.documentID

        let encoded = try Firestore.Encoder().encode(newGroup)
        
        try await docRef.setData(encoded)
    }


    static func addGroupExpense(groupID: String, expense: GroupExpense) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("group").document(groupID).collection("expenses").document()

        let encoded = try Firestore.Encoder().encode(expense)
        
        try await docRef.setData(encoded)
    }


    static func addGroupMember(groupID: String, memberID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("group").document(groupID).updateData([
            "groupMembers": FieldValue.arrayUnion([memberID])
        ])
    }

    // calculate and update total balance
    static func updateGroupBalance(groupID: String)  {
        // TODO: Fetch all expenses and recalculate balances
     
    }

    // upate group name
    static func changeGroupName(groupID: String, newName: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("group").document(groupID).updateData([
            "groupName": newName
        ])
    }
}
