//
//  GroupDetailsView.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct GroupDetailView: View {
    var group: Group
    @State private var members: [String] = []
    @State private var expenses: [GroupExpense] = []
    @State private var showAddMemberView = false
    @State private var showAddExpenseView = false
    @State private var navigateToAddExpense = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Members:")
                .font(.headline)
            ForEach(members, id: \.self) { member in
                Text(member)
            }

            Button("Add Member") {
                showAddMemberView = true
            }
            .sheet(isPresented: $showAddMemberView) {
                AddMemberView(group: group)
            }

            Text("Expenses:")
                .font(.headline)
            ForEach(expenses, id: \.id) { expense in
                VStack(alignment: .leading) {
                    Text(expense.description)
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .font(.caption)
                }
            }

            Button("Add Group Expense") {
                showAddExpenseView = true
            }
            
            
            .sheet(isPresented: $showAddExpenseView) {
                AddGroupExpenseView(group: group) {
                    loadGroupDetails() // Callback after expense is added
                }
            }
        }
        .padding()
        .navigationTitle(group.groupName)
        .onAppear {
            loadGroupDetails()
        }
    }

    func loadGroupDetails() {
        Task {
            do {
                guard let groupID = group.id else {
                    print("Group ID is nil")
                    return
                }

                let groupRef = Firestore.firestore().collection("groups").document(groupID)
                let groupSnapshot = try await groupRef.getDocument()
                if let groupData = groupSnapshot.data(),
                   let groupMembers = groupData["groupMembers"] as? [String: String] {
                    members = Array(groupMembers.values)
                }

                expenses = try await GroupService.getGroupAllExpense(groupID: groupID)
            } catch {
                print("Error loading group details: \(error)")
            }
        }
    }
}


#Preview {
    GroupDetailView(group: Group(id: "mockGroupId", groupName: "Test Group", groupMembers: ["uid1": "Alice", "uid2": "Bob"], balance: [:]))
}
