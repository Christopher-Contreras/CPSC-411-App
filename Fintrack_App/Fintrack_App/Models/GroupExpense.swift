//
//  GroupExpense.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/16/25.
//

import Foundation
import FirebaseFirestore

struct GroupExpense: Codable, Hashable {
    var description: String
    var amount: Double
    var paidBy: String // userID
    var splitBetween: [String] // userIDs
    var splitAmounts: [String: Double]

}
