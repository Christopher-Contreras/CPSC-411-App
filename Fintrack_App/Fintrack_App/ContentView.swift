//
//  ContentView.swift
//  Fintrack_App
//
//  Created by csuftitan on 3/25/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AuthView()
            
//            Button("Test Group") {
//                Task {
//                    do {
//                        let testGroup = Group(
//                            id: nil,
//                            groupName: "testGroup",
//                            groupMembers: ["user1", "user2"],
//                            balance: ["user1":["user2":2.56]],
//                            createdAt: nil // will be set by serverTimestamp()
//                        )
//                        
//                        try await
//                        GroupService.addGroup(group: testGroup)
//                        print("✅ Group added")
//                    } catch {
//                        print("❌ Error: \(error.localizedDescription)")
//                    }
//                }
//            }
//            
//            Button("Test User") {
//                Task {
//                    do {
//                        let testUser = User(
//                            id: nil,
//                            email: "abc@gmail.com",
//                            group: ["group1", "group2"],
//                            userName: "testUser",
//                            createdAt: nil // will be set by serverTimestamp()
//                        )
//                        
//                        try await
//                        UserService.addUser(user: testUser)
//                        print("✅ User added")
//                    } catch {
//                        print("❌ Error: \(error.localizedDescription)")
//                    }
//                }
//            }

            
            
        }
        .padding()
    }
}



//#Preview {
//    ContentView()
//}
