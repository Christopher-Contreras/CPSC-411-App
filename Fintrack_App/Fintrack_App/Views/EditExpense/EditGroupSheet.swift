//
//  EditGroupSheet.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 5/14/25.
//

import SwiftUI
import FirebaseAuth

struct EditGroupSheet: View {
    @State var group: Group
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Name")) {
                    TextField("Group Name", text: $group.groupName)
                }

                Section(header: Text("Actions")) {
                    Button("Save Changes") {
                        Task {
                            do {
                                try await GroupService.changeGroupName(groupID: group.id ?? "", newName: group.groupName)
                                onComplete()
                                dismiss()
                            } catch {
                                print("Failed to update group name: \(error.localizedDescription)")
                            }
                        }
                    }

                    Button("Leave Group", role: .destructive) {
                        Task {
                            do {
                                guard let uid = Auth.auth().currentUser?.uid else { return }
                                try UserService.removeGroupID(groupID: group.id ?? "", userID: uid)
                                onComplete()
                                dismiss()
                            } catch {
                                print("Failed to leave group: \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
            }
            .navigationTitle("Edit Group")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
