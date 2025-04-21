//
//  GroupService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//


import Foundation
import FirebaseFirestore

struct GroupService {
    
    static func addGroup(_ group: Group, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document()
        
        var newGroup = group
        newGroup.id = docRef.documentID
        
        do {
            let encoded = try Firestore.Encoder().encode(newGroup)
            docRef.setData(encoded) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    static func addGroupExpense(groupID: String, expense: GroupExpense, completion: @escaping (Error?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document(groupID).collection("expenses").document()
        
        do {
            let encoded = try Firestore.Encoder().encode(expense)
            docRef.setData(encoded) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    static func addGroupMember(groupID: String, memberID: String, completion: @escaping (Error?) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("groups").document(groupID).updateData([
            "groupMembers": FieldValue.arrayUnion([memberID])
        ]) { error in
            completion(error)
        }
    }
    
    static func changeGroupName(groupID: String, newName: String, completion: @escaping (Error?) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("groups").document(groupID).updateData([
            "groupName": newName
        ]) { error in
            completion(error)
        }
    }
    
    static func updateGroupBalance(groupID: String) {
        // TODO: Fetch expenses from /group/{groupID}/expenses
        
    }
}
