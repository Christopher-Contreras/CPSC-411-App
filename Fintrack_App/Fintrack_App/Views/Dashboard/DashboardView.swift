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
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Your Groups")
                    }
                    .font(.headline)
                    
                    NavigationLink(destination: CreateGroupView()) {
                        Label("Create Group", systemImage: "person.badge.plus")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.userGroups) { group in
                                NavigationLink(destination: GroupDetailView(group: group)) {
                                    HStack {
                                        Text(group.groupName)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 10)
                                }
                                Divider()
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                }
                
                
                VStack(alignment: .leading, spacing: 12){
                    
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                        Text("Your Expenses")
                    }
                    .font(.headline)
                    
                    
                    
                    NavigationLink(destination: AddPersonalExpenseView()) {
                        Label("Add Personal Expense", systemImage: "plus.circle")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(viewModel.userExpenses, id: \.id) { expense in
                                HStack {
                                    Text(expense.description)
                                    Spacer()
                                    Text("$\(expense.amount, specifier: "%.2f")")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                Divider()
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                    Spacer()
                    
                    Button("Logout") {
                        Task {
                            do {
                                try await authViewModel.logout()
                            } catch {
                                print("Logout failed: \(error)")
                            }
                        }
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
            }
        }
        .padding()
        .onAppear {
            Task {
                await viewModel.loadUserExpenses()
                await viewModel.loadUserGroups()
            }
        }
    }
}

#Preview {
    DashboardView()
}
