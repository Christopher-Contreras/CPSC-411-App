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
            
            Text(group.groupName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
            
            Text("Members: \(members.joined(separator: ", "))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !group.balance.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Balance:")
                        .font(.headline)
                    
                    ScrollView{
                        ForEach(group.balance.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            let parts = key.components(separatedBy: "_to_")
                            let fromName = group.groupMembers[String(parts.first ?? "")] ?? "Unknown"
                            let toName = group.groupMembers[String(parts.last ?? "")] ?? "Unknown"
                            Text("\(fromName) → \(toName): $\(value, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.bottom, 8)
                .frame(maxHeight: 65)
            }
            

            
            HStack(spacing: 16) {
                Button("Add Member") {
                    showAddMemberView = true
                }
                .sheet(isPresented: $showAddMemberView) {
                    AddMemberView(group: group)
                }
                Spacer()
                Button("Add Group Expense") {
                    showAddExpenseView = true
                }
                .sheet(isPresented: $showAddExpenseView) {
                    AddGroupExpenseView(group: group) {
                        loadGroupDetails()
                    }
                }
            }
            
            Text("Expenses:")
                .font(.headline)
            ScrollView{
                ForEach(expenses, id: \.id) { expense in
                    VStack(spacing: 8) {
                        HStack {
                            Text(expense.description)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("$\(expense.amount, specifier: "%.2f")")
                                .font(.headline)
                                .frame(alignment: .trailing)
                        }
                        
                        HStack {
                            let names = expense.splitBetween.keys.compactMap { group.groupMembers[$0] }
                            Text("Split between: \(names.joined(separator: ", "))")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Paid by: \(group.groupMembers[expense.paidBy] ?? "Unknown")")
                                .font(.subheadline)
                                .frame(alignment: .trailing)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.vertical, 4)
                }
            }
            .frame(maxHeight: .infinity)
            
            Spacer()
            
        }
        .padding()
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


//#Preview {
//    GroupDetailView(group: Group(id: "mockGroupId", groupName: "Test Group", groupMembers: ["uid1": "Alice", "uid2": "Bob"], balance: [:]))
//}
