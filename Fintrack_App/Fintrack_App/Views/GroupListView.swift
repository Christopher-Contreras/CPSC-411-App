//
//  GroupListView.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct GroupListView: View {
    @State private var groups: [Group] = []
    
    var body: some View {
        List(groups, id: \.id) { group in
            NavigationLink(destination: GroupExpenseListView(groupID: group.id!)) {
                VStack(alignment: .leading) {
                    Text(group.groupName)
                        .font(.headline)
                    Text("Members: \(group.groupMembers.count)")
                        .font(.subheadline)
                }
            }
        }
        .onAppear {
            Task {
                await fetchUserGroups()
            }
        }
    }
    
    private func fetchUserGroups() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        do {
            let userDoc = try await db.collection("users").document(uid).getDocument()
            let groupIDs = userDoc.get("groups") as? [String] ?? []
            
            print("groups: \(groupIDs)")
            var loadedGroups: [Group] = []
            for groupID in groupIDs {
                let groupDoc = try await db.collection("groups").document(groupID).getDocument()
                if let group = try? groupDoc.data(as: Group.self) {
                    loadedGroups.append(group)
                }
            }

            groups = loadedGroups
        } catch {
            print("Failed to fetch user groups: \(error)")
        }
    }
}

#Preview {
    GroupListView()
}
