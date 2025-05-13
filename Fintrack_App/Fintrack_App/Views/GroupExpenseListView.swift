
//  GroupExpenseListView.swift
//  Fintrack_App
//
//  Created by Snehal Chavan on 5/11/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct GroupExpenseListView: View {
    var groupID: String

    @State private var groupName: String = ""
    @State private var memberUsernames: [String] = []
    @State private var expenses: [GroupExpense] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Group: \(groupName)")
                .font(.title2)
                .bold()

            Text("Members:")
                .font(.headline)
            ForEach(memberUsernames, id: \.self) { username in
                Text("- \(username)")
            }

            Divider()

            Text("Expenses:")
                .font(.headline)
            List(expenses, id: \.id) { expense in
                VStack(alignment: .leading) {
                    Text(expense.description)
                    Text("$\(expense.amount, specifier: "%.2f")")
                        .font(.caption)
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                await fetchGroupDetails()
            }
        }
    }

    private func fetchGroupDetails() async {
        let db = Firestore.firestore()
        do {
            let groupDoc = try await db.collection("groups").document(groupID).getDocument()
            guard let groupData = groupDoc.data() else { return }

            self.groupName = groupData["groupName"] as? String ?? ""
            let memberIDs = groupData["groupMembers"] as? [String] ?? []

            // Fetch member usernames
            var usernames: [String] = []
            for uid in memberIDs {
                let userDoc = try await db.collection("users").document(uid).getDocument()
                if let userName = userDoc.get("userName") as? String {
                    usernames.append(userName)
                }
            }
            self.memberUsernames = usernames

            // Fetch expenses
            let expenseSnapshot = try await db.collection("groups").document(groupID).collection("expenses").getDocuments()
            self.expenses = expenseSnapshot.documents.compactMap { doc in
                try? doc.data(as: GroupExpense.self)
            }

        } catch {
            print("Error fetching group details: \(error.localizedDescription)")
        }
    }
}
#Preview {
    GroupExpenseListView(groupID: "sampleGroupID")
}
