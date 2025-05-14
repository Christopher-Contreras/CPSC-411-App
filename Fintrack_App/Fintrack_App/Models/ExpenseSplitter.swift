//
//  ExpenseSplitter.swift
//  Fintrack_App
//
//  Created by Chritopher Contreras on 5/13/25.
//

import Foundation

struct ExpenseSplitter {
    
    static func splitEqually(amount: Double, among groupMembers: [String: String]) -> [String: Double] {
        guard !groupMembers.isEmpty else { return [:] }
        let equalShare = amount / Double(groupMembers.count)
        return groupMembers.reduce(into: [String: Double]()) { result, member in
            result[member.value] = equalShare
        }
    }
    
    static func createGroupExpenseWithEqualSplit(
        description: String,
        amount: Double,
        paidBy: String,
        groupMembers: [String: String]
    ) -> GroupExpense {
        let splitBetween = splitEqually(amount: amount, among: groupMembers)
        return GroupExpense(
            description: description,
            amount: amount,
            paidBy: paidBy,
            splitBetween: splitBetween,
            createdAt: nil
        )
    }
}
