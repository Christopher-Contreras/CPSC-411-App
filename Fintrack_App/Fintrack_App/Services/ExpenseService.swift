//
//  AddExpense.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct ExpenseService {
    static func addExpense(expense: Expense) async throws {
        let db=Firestore.firestore()
        
        let data:[String:Any]=[
            "description":expense.description,
            "groupID":expense.groupID,
            "amount":expense.amount,
            "paidBy":expense.paidBy,
            "splitBetween":expense.splitBetween,
            "splitAmounts":expense.splitAmounts,
            "createdAt":FieldValue.serverTimestamp()
        ]
        
        try await db.collection("expense").addDocument(data: data)
    }
    
    
    
    
}
