//
//  User.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String? = nil

    var email: String
    var userName: String
    var group: [String] = [] // groupIDs
    var createdAt: Timestamp? = nil
    // contains subcollection UserExpense
}
