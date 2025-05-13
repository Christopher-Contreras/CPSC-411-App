
//  CreateGroupView.swift
//  Fintrack_App
//
//  Created by Snehal Chavan on 5/11/25.
//

import SwiftUI
import Firebase
import FirebaseAuth



struct CreateGroupView: View {
    @State private var groupName = ""
    @State private var memberEmails: String = "" // comma-separated
    @State private var statusMessage: String = ""

    var body: some View {
        VStack {
            TextField("Group Name", text: $groupName)
            TextField("Member Emails (comma separated)", text: $memberEmails)

            Button("Create Group") {
                Task {
                    do {
                        guard let currentUser = Auth.auth().currentUser else { return }
                        let currentUserID = currentUser.uid
                        let currentUserName = currentUser.displayName ?? "Unnamed User"
                        
                        // create group
                        let group = Group(groupName: groupName, groupMembers: [currentUserID:currentUserName], balance: [:])
                        let groupID =  try GroupService.addGroup(group: group)

                        // add groups id to current user's field
                        try UserService.addGroupID(groupID: groupID, userID: currentUserID)

                        // Start with current user
                        var members: [String: String] = [currentUserID: currentUserName]

                        // Process emails
                        let emails = memberEmails
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                        for email in emails {
                            let querySnapshot = try await Firestore.firestore()
                                .collection("users")
                                .whereField("email", isEqualTo: email)
                                .getDocuments()

                            if let doc = querySnapshot.documents.first {
                                let data = doc.data()
                                let uid = data["uid"] as? String ?? doc.documentID
                                let name = data["userName"] as? String ?? email
                                members[uid] = name
                                
                                try await GroupService.addGroupMember(groupID: groupID, memberID: uid, memberName: name)
                                try UserService.addGroupID(groupID: groupID, userID: uid)
                            } else {
                                print("No user found with email: \(email)")
                            }
                        }
                       
                        
                        statusMessage = "Group created successfully!"
                        groupName = ""
                        memberEmails = ""
                    } catch {
                        statusMessage = "Error creating group: \(error.localizedDescription)"
                    }
                }
            }

            Text(statusMessage)
                .foregroundColor(.gray)

            NavigationLink("Back to Dashboard", destination: DashboardView())
        }
        .padding()
    }
}
