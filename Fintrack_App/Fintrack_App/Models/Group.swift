//
//  Group.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/10/25.
//

import Foundation
import FirebaseFirestore

// collection model of groups
struct Group: Codable, Identifiable, Equatable {
    @DocumentID var id: String? = nil

    var groupName: String
    var groupMembers: [String:String] // [userID : userName]
    var balance: [String: Double] // ["A to B" : amount]
    
    @ServerTimestamp var createdAt: Timestamp?
    
    // contains subcollection GroupExpense
}
