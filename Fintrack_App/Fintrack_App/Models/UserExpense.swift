//
//  UserExpense.swift
//  Fintrack_App
//
//  Created by csuftitan on 4/16/25.
//

import FirebaseFirestore

// subcollection of users
struct UserExpense: Codable, Hashable {
    @DocumentID var id: String? = nil
    var amount: Double
    var description: String
    
    @ServerTimestamp var createdAt: Timestamp?
}
