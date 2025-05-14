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

            Button(action: {
                Task {
                    await addGroupExpense()
                }
            }) {
                Text("Add Group Expense (Split Equally)")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
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
        guard let paidBy = Auth.auth().currentUser?.displayName,
              let total = Double(amount),
              !description.isEmpty else {
            print("Invalid input")
            return
        }

        do {
            // Calculate equal split
            let splitAmount = total / Double(group.groupMembers.count)
            var splitBetween = [String: Double]()
            
            for (userId, userName) in group.groupMembers {
                splitBetween[userId] = splitAmount
            }

            let expense = GroupExpense(
                description: description,
                amount: total,
                paidBy: paidBy,
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

#Preview {
    AddGroupExpenseView(group: Group(
        id: "mockGroupId",
        groupName: "Test Group",
        groupMembers: ["uid1": "Alice", "uid2": "Bob"],
        balance: [:]
    ))
}
