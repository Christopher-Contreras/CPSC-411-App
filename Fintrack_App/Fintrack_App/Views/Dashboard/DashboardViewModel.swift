//
//  DashboardViewModel.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var userExpenses: [UserExpense] = []
    @Published var userGroups: [Group] = []

    func loadUserExpenses() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            userExpenses = try await UserService.getUserAllExpense(userID: uid)
        } catch {
            print("Failed to load expenses: \(error)")
        }
    }

    func loadUserGroups() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        do {
            let userDoc = try await db.collection("users").document(uid).getDocument()
            if let groupIDs = userDoc.data()?["groups"] as? [String] {
                var groups: [Group] = []
                for groupID in groupIDs {
                    let groupDoc = try await db.collection("groups").document(groupID).getDocument()
                    if let group = try? groupDoc.data(as: Group.self) {
                        groups.append(group)
                    }
                }
                
                    self.userGroups = groups
                
            }
        } catch {
            print("Failed to load user groups: \(error)")
        }
    }

    func logOut() async throws {
        try Auth.auth().signOut()
    }
}
