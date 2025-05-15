import SwiftUI
import FirebaseAuth
import Firebase

struct DashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var colorSchemeManager: ColorSchemeManager  // ✅ NEW

    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedGroup: Group? = nil
    @State private var selectedExpense: UserExpense? = nil
    @State private var showGroupEditSheet = false
    @State private var showExpenseEditSheet = false

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Spacer()

                    VStack(spacing: 4) {
                        Text("Dark Mode")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Toggle("", isOn: $colorSchemeManager.isDarkMode)
                            .labelsHidden()
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .scaleEffect(0.75)
                    }
                }



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
                                HStack {
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

                                    Button(action: {
                                        selectedGroup = group
                                    }) {
                                        Image(systemName: "ellipsis.circle")
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    }
                                    .padding(.trailing, 10)
                                }
                                Divider()
                            }
                        }
                    }
                    .frame(height: geometry.size.height * 0.3)
                }

                VStack(alignment: .leading, spacing: 12) {
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
                                    VStack(alignment: .leading) {
                                        Text(expense.description)
                                        Text("$\(expense.amount, specifier: "%.2f")")
                                            .foregroundColor(.secondary)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Button(action: {
                                        selectedExpense = expense
                                    }) {
                                        Image(systemName: "ellipsis.circle")
                                            .foregroundColor(.gray)
                                            .imageScale(.large)
                                    }
                                    .padding(.trailing, 10)
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
        .onChange(of: selectedExpense) { newValue in
            if newValue != nil {
                showExpenseEditSheet = true
            }
        }
        .onChange(of: selectedGroup) { newValue in
            if newValue != nil {
                showGroupEditSheet = true
            }
        }
        .sheet(isPresented: $showGroupEditSheet) {
            if let group = selectedGroup {
                EditGroupSheet(group: group) {
                    Task {
                        await viewModel.loadUserGroups()
                        showGroupEditSheet = false
                    }
                }
            }
        }
        .sheet(isPresented: $showExpenseEditSheet) {
            if let expense = selectedExpense, let userID = Auth.auth().currentUser?.uid {
                EditPersonalExpenseSheet(expense: expense, userID: userID) {
                    Task {
                        await viewModel.loadUserExpenses()
                        showExpenseEditSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
        .environmentObject(ColorSchemeManager())  // ✅ Added for preview support
}
