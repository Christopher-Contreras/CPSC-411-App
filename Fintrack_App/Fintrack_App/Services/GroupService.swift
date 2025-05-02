import Foundation
import FirebaseFirestore

struct GroupService {
    
    static func addGroup(group: Group) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document()
        try docRef.setData(from: group)
    }
    
    static func addGroupExpense(groupID: String, expense: GroupExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups").document(groupID).collection("expenses").document()
        try docRef.setData(from: expense)
    }
    
    static func deleteGroupExpense(groupID: String, expenseID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("groups")
            .document(groupID)
            .collection("expenses")
            .document(expenseID)
            .delete()
    }
    
    static func getGroupAllExpense(groupID: String) async throws -> [GroupExpense] {
        let db = Firestore.firestore()
        let collectionRef = db.collection("groups").document(groupID).collection("expenses")
        let snapshot = try await collectionRef.getDocuments()
        let expenses = try snapshot.documents.compactMap { document in
            try document.data(as: GroupExpense.self)
        }
        return expenses
    }
    
    static func updateGroupExpense(groupID: String, expenseID: String, newExpense: GroupExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
            .document(groupID)
            .collection("expenses")
            .document(expenseID)
        try docRef.setData(from: newExpense)
    }
    
    static func addGroupMember(groupID: String, memberID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("groups").document(groupID).updateData([
            "groupMembers": FieldValue.arrayUnion([memberID])
        ])
    }
    
    static func changeGroupName(groupID: String, newName: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("groups").document(groupID).updateData([
            "groupName": newName
        ])
    }
    
    static func updateGroupBalance(groupID: String) async throws {
        let expenses = try await getGroupAllExpense(groupID:groupID)
        
        var total:[String:Double]=[:]
        
        // calculate net balance for every one
        for expense in expenses {
            let paidBy = expense.paidBy
            let amount = expense.amount
            let splitBetween = expense.splitBetween
            
            total[paidBy,default:0]+=amount
            
            for (user,share) in splitBetween {
                total[user,default: 0]-=share
            }
        }
        
        print(total)
        
        // split into debtors (negative amount) and creditors (positive amount)
        let tuple:[(Double, String)]=total.map{(name, balance) in (balance, name)}
        
        var debtors = tuple.filter { $0.0 < 0 }.sorted(by: <) // ascending
        var creditors = tuple.filter { $0.0 > 0 }.sorted(by: >) // descending
        
        // simply who owns who how much
        var balance: [String: [String: Double]]=[:]
        
        while(!debtors.isEmpty){
            let debtorName = debtors[0].1
            let creditorName = creditors[0].1
            
            let debtorsOwnAmount = debtors[0].0
            let creditorReceivable = creditors[0].0
            
            
            if(creditorReceivable<(-debtorsOwnAmount)){
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = creditorReceivable
                
                debtors[0].0+=creditorReceivable
                creditors.remove(at: 0)
            }
            else if (creditorReceivable==(-debtorsOwnAmount)){
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = creditorReceivable
                
                debtors.remove(at: 0)
                creditors.remove(at: 0)
                
            }
            else if (creditorReceivable>(-debtorsOwnAmount)){
                if balance[debtorName] == nil {
                    balance[debtorName] = [:]
                }
                balance[debtorName]![creditorName] = -debtorsOwnAmount
                creditors[0].0+=debtorsOwnAmount
                debtors.remove(at: 0)
            }
            
        }
        
        // update balace field in group collection
        var flatBalance: [String: Double] = [:]

        for (debtor, creditors) in balance {
            for (creditor, amount) in creditors {
                let key = "\(debtor)_to_\(creditor)"
                flatBalance[key] = amount
            }
        }
        
        print(balance)
        print(flatBalance)
        
        if flatBalance.isEmpty {
                print("flatBalance is empty — no balance will be written.")
            } else {
                let db=Firestore.firestore()
                try await db.collection("groups").document(groupID).updateData([
                    "balance": flatBalance
                ])
            }
        
        
    }
    
}
