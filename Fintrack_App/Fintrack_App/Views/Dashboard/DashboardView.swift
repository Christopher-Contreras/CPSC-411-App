//  DashboardView.swift
//  Fintrack_App
//
//  Created by Snehal Chavan on 5/11/25.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = DashboardViewModel()


    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                NavigationLink("Add Personal Expense", destination: AddPersonalExpenseView())
                NavigationLink("Create Group", destination: CreateGroupView())

                Text("Your Groups")
                    .font(.headline)

                List(viewModel.userGroups) { group in
                    NavigationLink(destination: GroupDetailView(group: group)) {
                        Text(group.groupName)
                    }
                }

                Text("Your Expenses")
                    .font(.headline)

                List(viewModel.userExpenses, id: \.id) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.description)
                        Text("$\(expense.amount, specifier: "%.2f")")
                            .font(.caption)
                    }
                }

                Button("Logout") {
                    Task {
                        do {
                            try await authViewModel.logout()
                        } catch {
                            print("Logout failed: \(error)")
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .padding()
            .onAppear {
                Task {
                    await viewModel.loadUserExpenses()
                    await viewModel.loadUserGroups()
                }
            }
        }
    }
}

#Preview {
    DashboardView()
}
