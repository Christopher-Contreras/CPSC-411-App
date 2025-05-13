//
//  User.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

// collection model of users
struct User: Codable, Identifiable {
    @DocumentID var id: String? = nil

    var email: String
    var userName: String
    var groups: [String] = [] // groupIDs
    @ServerTimestamp var createdAt: Timestamp?
    
    // contains subcollection UserExpense
}
