//
//  GroupExpense.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/16/25.
//

import Foundation
import FirebaseFirestore

struct GroupExpense: Codable, Hashable {
    @DocumentID var id: String? = nil
    
    var description: String
    var amount: Double
    var paidBy: String // userName
    var splitBetween: [String: Double] // userNames

}
