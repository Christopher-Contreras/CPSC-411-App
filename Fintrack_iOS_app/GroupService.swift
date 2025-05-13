//
//  GroupService.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//

import Foundation
import FirebaseFirestore


// handle firebase call to add a group or edit fields in a group to firebase
// it first store data locally and then sync to firebase
struct GroupService {
    
    // Adds a new group document to the "groups" collection in Firestore
    static func addGroup(group: Group) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document()
        var groupWithID = group
        groupWithID.id = docRef.documentID
        try await docRef.setData(from: groupWithID)

        // Also add groupID to each user's document
        for userID in group.groupMembers.keys {
            try await db.collection("users").document(userID).updateData([
                "groups": FieldValue.arrayUnion([docRef.documentID])
            ])
        }
    }

    // Adds a new group expense document under the "groupExpenses" subcollection
    static func addGroupExpense(groupID: String, expense: GroupExpense) async throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document(groupID).collection("groupExpenses").document()
        try await docRef.setData(from: expense)
    }
    
    // delete a group expense document under the "groupExpenses" subcollection
    static func deleteGroupExpense(groupID: String, expenseID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("groups")
            .document(groupID)
            .collection("groupExpenses")
            .document(expenseID)
            .delete()
    }
    
    // return a list with all expense document in a specific group
    static func getGroupAllExpense(groupID: String) async throws -> [GroupExpense] {
        let db = Firestore.firestore()
        let collectionRef = db.collection("groups").document(groupID).collection("groupExpenses")
        let snapshot = try await collectionRef.getDocuments()
        let expenses = try snapshot.documents.compactMap { document in
            try document.data(as: GroupExpense.self)
        }
        return expenses
    }
    
    // update a group expense document for a specific group by entirely overwrite the old one with all fields
    static func updateGroupExpense(groupID: String, expenseID: String, newExpense: GroupExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
            .document(groupID)
            .collection("groupExpenses")
            .document(expenseID)
        try docRef.setData(from: newExpense)
    }
    
    // add a new group member's id and name to the groupMember field
    static func addGroupMember(groupID: String, memberUID: String, memberName: String) async throws {
        let db = Firestore.firestore()
        
        // Add member to group
        try await db.collection("groups").document(groupID).updateData([
            "groupMembers.\(memberUID)": memberName
        ])
        
        // Add group ID to user's groups
        try await db.collection("users").document(memberUID).updateData([
            "groups": FieldValue.arrayUnion([groupID])
        ])
    }
    
    // update the groupName field in a group
    static func changeGroupName(groupID: String, newName: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("groups").document(groupID).updateData([
            "groupName": newName
        ])
    }
    
    // update total balance field [stirng: Double]: ['A to B': amount]
    // call when add, delete, or update a group expense
    static func updateGroupBalance(groupID: String) async throws {
        let expenses = try await getGroupAllExpense(groupID: groupID)
        
        var total: [String: Double] = [:]
        
        // calculate net balance for everyone
        for expense in expenses {
            let paidBy = expense.createdBy  // Use 'createdBy' as the person who paid
            let amount = expense.amount
            
            // Assuming 'splitBetween' is a dictionary containing how the amount is split
            // If not available, we can assume the expense is split evenly among group members
            let splitBetween = expense.splitBetween // This should be populated in the data
            
            total[paidBy, default: 0] += amount
            
            for (user, share) in splitBetween {
                total[user, default: 0] -= share
            }
        }
        
        print(total)
        
        // Further processing for debtors and creditors
        let tuple: [(Double, String)] = total.map { (name, balance) in (balance, name) }
        
        var debtors = tuple.filter { $0.0 < 0 }.sorted(by: <) // ascending
        var creditors = tuple.filter { $0.0 > 0 }.sorted(by: >) // descending
        
        // Simple process of who owes who how much
        var balance: [String: [String: Double]] = [:]
        
        while !debtors.isEmpty {
            let debtorName = debtors[0].1
            let creditorName = creditors[0].1
            
            let debtorsOwnAmount = debtors[0].0
            let creditorReceivable = creditors[0].0
            
            if creditorReceivable < (-debtorsOwnAmount) {
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = creditorReceivable
                
                debtors[0].0 += creditorReceivable
                creditors.remove(at: 0)
            } else if creditorReceivable == (-debtorsOwnAmount) {
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = creditorReceivable
                
                debtors.remove(at: 0)
                creditors.remove(at: 0)
            } else if creditorReceivable > (-debtorsOwnAmount) {
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = -debtorsOwnAmount
                creditors[0].0 += debtorsOwnAmount
                debtors.remove(at: 0)
            }
        }
        
        // Update balance field in group collection
        var flatBalance: [String: Double] = [:]
        
        for (debtor, creditors) in balance {
            for (creditor, amount) in creditors {
                let key = "\(debtor)_to_\(creditor)"
                flatBalance[key] = amount
            }
        }
        
        print(balance)
        print(flatBalance)
        
        if flatBalance.isEmpty {
            print("flatBalance is empty — no balance will be written.")
        } else {
            let db = Firestore.firestore()
            try await db.collection("groups").document(groupID).updateData([
                "balance": flatBalance
            ])
        }
    }
    
}
