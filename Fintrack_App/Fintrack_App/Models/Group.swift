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
    var groupMembers: [String:String] // [userID : userName]
    var balance: [String: Double] // ["A to B" : amount]
    
    var createdAt: Timestamp? = nil
    // contains subcollection expenses
}
