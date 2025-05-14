//
//  AddMemberView.swift
//  Fintrack_iOS_app
//
//  Created by Snehal Chavan on 5/12/25.
//

import SwiftUI
import Firebase

struct AddMemberView: View {
    var group: Group
    @State private var email = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    var onMemberAdded: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Member by Email")
                .font(.headline)

            TextField("Enter member's email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: {
                Task {
                    await addMemberByEmail()
                }
            }) {
                Text("Add Member")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button("Back to Group") {
                dismiss()
            }
            .padding(.top, 10)
        }
        .padding()
    }

    private func addMemberByEmail() async {
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty."
            return
        }

        let db = Firestore.firestore()
        do {
            // Query the 'users' collection for a user with the provided email
            let querySnapshot = try await db.collection("users").whereField("email", isEqualTo: email).getDocuments()

            guard let userDoc = querySnapshot.documents.first else {
                errorMessage = "No user found with this email."
                return
            }

            let uid = userDoc.documentID
            let userName = userDoc.get("userName") as? String ?? "Unknown"

            // Update the group's 'groupMembers' field
            let groupRef = db.collection("groups").document(group.id ?? "")
            try await groupRef.updateData([
                "groupMembers.\(uid)": userName
            ])

            // Optionally, update the user's 'groups' field
            let userRef = db.collection("users").document(uid)
            try await userRef.updateData([
                "groups": FieldValue.arrayUnion([group.id ?? ""])
            ])

            // Clear the input and error message
            email = ""
            errorMessage = ""

            // Dismiss the view
            onMemberAdded?()
            dismiss()
        } catch {
            errorMessage = "Error adding member: \(error.localizedDescription)"
        }
    }
}

#Preview {
    AddMemberView(group: Group(id: "mockGroupId", groupName: "Test Group", groupMembers: ["uid1": "Alice", "uid2": "Bob"], balance: [:]))
    
}
