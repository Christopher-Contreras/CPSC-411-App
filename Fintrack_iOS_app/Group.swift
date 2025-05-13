
//
//  Group.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// collection model of groups


struct Group: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var groupName: String
    var groupMembers: [String: String] // [userID: userName]
    var balance: [String: Double] // ["A to B": amount]
    var createdAt: Timestamp?
}
