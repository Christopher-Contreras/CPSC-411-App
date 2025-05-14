//
//  EditExpenseSheet.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 5/14/25.
//
import SwiftUI

struct EditExpenseSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State var expense: GroupExpense
    let group: Group
    let groupID: String
    let onComplete: () -> Void
    
    
    var body: some View{
        
            NavigationView{
                Form {
                    Section(header: Text("Description")) {
                        TextField("Description", text: $expense.description)
                    }
                    Section(header: Text("Amount")){
                        TextField("Amount", value: $expense.amount, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    Section(header: Text("Paid by")){
                        ForEach(group.groupMembers.sorted(by: { $0.value < $1.value }), id: \ .key) { userID, userName in
                            HStack {
                                Text(userName)
                                Spacer()
                                Button(action: {
                                    expense.paidBy = userID
                                }) {
                                    Image(systemName: expense.paidBy == userID ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Split Between")) {
                        ForEach(group.groupMembers.sorted(by: { $0.value < $1.value }), id: \ .key) { userID, userName in
                            HStack {
                                Text(userName)
                                Spacer()
                                Button(action: {
                                    if expense.splitBetween.keys.contains(userID) {
                                        expense.splitBetween.removeValue(forKey: userID)
                                    } else {
                                        expense.splitBetween[userID] = 0
                                    }
                                }) {
                                    Image(systemName: expense.splitBetween.keys.contains(userID) ? "checkmark.square" : "square")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button("Save Changes") {
                            Task {
                                let splitCount = expense.splitBetween.count
                                if splitCount > 0 {
                                    let equalAmount = expense.amount / Double(splitCount)
                                    for key in expense.splitBetween.keys {
                                        expense.splitBetween[key] = equalAmount
                                    }
                                }
                                
                                try GroupService.updateGroupExpense(
                                    groupID: groupID,
                                    expenseID: expense.id ?? "",
                                    newExpense: expense
                                )
                                
                                try await GroupService.updateGroupBalance(groupID: groupID)
                                onComplete()
                                dismiss()
                               
                            }
                        }
                    }
                    
                    Section {
                        Button("Delete Expense", role: .destructive) {
                            Task {
                                try await GroupService.deleteGroupExpense(groupID: groupID, expenseID: expense.id ?? "")
                                try await GroupService.updateGroupBalance(groupID: groupID)
                                onComplete()
                                dismiss()
                            }
                        }
                    }
                }
                .navigationTitle("Edit Expense")
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
    }


//#Preview {
//    EditExpenseSheet(
//        expense: GroupExpense(
//            id: "sample",
//            description: "Lunch",
//            amount: 24.0,
//            paidBy: "uid1",
//            splitBetween: ["uid1": 12, "uid2": 12]
//        ),
//        group: Group(
//            id: "group1",
//            groupName: "Test Group",
//            groupMembers: ["uid1": "Alice", "uid2": "Bob"],
//            balance: [:]
//        ),
//        groupID: "group1"
//    ) {
//        print("Edit complete")
//    }
//}
