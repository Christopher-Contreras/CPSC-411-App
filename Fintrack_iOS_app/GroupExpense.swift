//
//  GroupExpense.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/16/25.
//

import Foundation
import FirebaseFirestore

// subcollection of group
struct GroupExpense: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var description: String
    var amount: Double
    var createdBy: String
    var splitBetween: [String: Double]  // Add this property to store how the expense is split
}
