//
//  Group.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

struct Group: Codable, Identifiable {
    @DocumentID var id: String? = nil

    var groupName: String
    var groupMembers: [String] // userIDs
    var balance: [String: [String: Double]] // who owes who
    
    var createdAt: Timestamp? = nil
    // contains subcollection expenses
}
