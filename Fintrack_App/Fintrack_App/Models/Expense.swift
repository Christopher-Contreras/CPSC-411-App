//
//  Expense.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct Expense: Codable, Identifiable, Hashable {
    @DocumentID var id: String? = nil
    
    var groupID:String
    var description: String
    var amount: Double
    var paidBy: String
    var splitBetween: [String]
    var splitAmounts: [String: Double]
    
    var createdAt: Timestamp? = nil
}
