//
//  EditPersonalExpenseSheet.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 5/14/25.
//

import SwiftUI
import FirebaseAuth

struct EditPersonalExpenseSheet: View {
    @State var expense: UserExpense
    let userID: String
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Description")) {
                    TextField("Description", text: $expense.description)
                }

                Section(header: Text("Amount")) {
                    TextField("Amount", value: $expense.amount, format: .number)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Save Changes") {
                        do {
                            try UserService.updateUserExpense(userID: userID, expenseID: expense.id ?? "", expense: expense)
                            onComplete()
                            dismiss()
                        } catch {
                            print("Failed to update expense: \(error.localizedDescription)")
                        }
                    }

                    Button("Delete Expense", role: .destructive) {
                        Task {
                            do {
                                try await UserService.deleteUserExpense(userID: userID, expenseID: expense.id ?? "")
                                onComplete()
                                dismiss()
                            } catch {
                                print("Failed to delete expense: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
