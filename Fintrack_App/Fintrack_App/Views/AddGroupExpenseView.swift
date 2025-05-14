//
//  AddGroupExpenseView.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//
import SwiftUI
import Firebase
import FirebaseAuth

struct AddGroupExpenseView: View {
    var group: Group
    @State private var description = ""
    @State private var amount = ""
    @State private var showSuccessAlert = false
    var onExpenseAdded: (() -> Void)? = nil
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isSplitEqually: Bool = true
    @State private var selectedMembers = Set<String>()
    @State private var paidBy: String? = nil
    
    var body: some View {
        VStack {
            Text("Adding expense to: \(group.groupName)")
                .font(.headline)
            
            TextField("Description", text: $description)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            VStack(alignment: .leading) {
                Text("Paid By:")
                    .font(.subheadline)
                    .padding(.bottom, 4)

                ForEach(group.groupMembers.sorted(by: { $0.value < $1.value }), id: \.key) { userID, userName in
                    HStack {
                        Text(userName)
                        Spacer()
                        Button(action: {
                            paidBy = userID
                        }) {
                            Image(systemName: paidBy == userID ? "largecircle.fill.circle" : "circle")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
            
            VStack(alignment: .leading) {
                Text("Split With:")
                    .font(.subheadline)
                    .padding(.bottom, 4)

                ForEach(group.groupMembers.sorted(by: { $0.value < $1.value }), id: \.key) { userID, userName in
                    HStack {
                        Text(userName)
                            .foregroundColor(isSplitEqually ? .gray : .primary)
                        Spacer()
                        Button(action: {
                            if !isSplitEqually {
                                if selectedMembers.contains(userID) {
                                    selectedMembers.remove(userID)
                                } else {
                                    selectedMembers.insert(userID)
                                }
                            }
                        }) {
                            Image(systemName: selectedMembers.contains(userID) ? "checkmark.square" : "square")
                                .foregroundColor(isSplitEqually ? .gray : .blue)
                        }
                        .disabled(isSplitEqually)
                    }
                    .padding(.horizontal)
                }

                HStack {
                    Button(action: {
                        isSplitEqually.toggle()
                        if isSplitEqually {
                            selectedMembers = Set(group.groupMembers.keys)
                        }
                    }) {
                        HStack {
                            Image(systemName: isSplitEqually ? "checkmark.square" : "square")
                            Text("Split Equally")
                        }
                    }
                    .padding(.top)
                    Spacer()
                }
            }
            .padding(.vertical)
            
            Button(action: {
                Task {
                    await addGroupExpense()
                }
            }) {
                Text("Add Group Expense")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .onAppear {
            selectedMembers = Set(group.groupMembers.keys) // default: all selected
        }
        .padding()
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Expense Added"),
                message: Text("The expense was successfully split equally among all members."),
                primaryButton: .default(Text("Back to Group")) {
                    presentationMode.wrappedValue.dismiss()
                    onExpenseAdded?()
                },
                secondaryButton: .default(Text("Go to Dashboard")) {
                    // Navigation logic here
                }
            )
        }
    }
    
    private func addGroupExpense() async {
        guard let paidByID = paidBy,
//              let paidByName = group.groupMembers[paidByID],
              let total = Double(amount),
              !description.isEmpty else {
            print("Invalid input: missing description, amount, or payer")
            return
        }
        
        let membersToSplit: [String: String]
        if isSplitEqually {
            membersToSplit = group.groupMembers
        } else {
            membersToSplit = group.groupMembers.filter { selectedMembers.contains($0.key) }
        }
        
        guard !membersToSplit.isEmpty else {
            print("No members selected to split with.")
            return
        }
        
        do {
            // Calculate equal split
            let splitAmount = total / Double(membersToSplit.count)
            var splitBetween = [String: Double]()
            
            for (userId, _) in membersToSplit {
                splitBetween[userId] = splitAmount
            }
            
            let expense = GroupExpense(
                description: description,
                amount: total,
                paidBy: paidByID,
                splitBetween: splitBetween
            )
            
            try GroupService.addGroupExpense(groupID: group.id ?? "", expense: expense)
            try await GroupService.updateGroupBalance(groupID: group.id ?? "")
            
            // Reset fields
            description = ""
            amount = ""
            showSuccessAlert = true
        } catch {
            print("Failed to add group expense: \(error.localizedDescription)")
        }
    }
}

//#Preview {
//    AddGroupExpenseView(group: Group(
//        id: "mockGroupId",
//        groupName: "Test Group",
//        groupMembers: ["uid1": "Alice", "uid2": "Bob"],
//        balance: [:]
//    ))
//}
