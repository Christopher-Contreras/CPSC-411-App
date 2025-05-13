

//
//  AddPersonalExpenseView.swift
//  Fintrack_App
//
//  Created by Snehal Chavan on 5/11/25.
//

import SwiftUI
import FirebaseAuth
import Firebase


struct AddPersonalExpenseView: View {
    @State private var description = ""
    @State private var amount = ""
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            TextField("Description", text: $description)
                .textFieldStyle(.roundedBorder)
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            Button("Add Expense") {
                guard let uid = Auth.auth().currentUser?.uid,
                      let amountDouble = Double(amount) else { return }
                let expense = UserExpense(amount: amountDouble, description: description)
                Task {
                    do {
                        try await UserService.addUserExpense(userID: uid, expense: expense)
                        showAlert = true
                    } catch {
                        print("Failed to add expense: \(error)")
                    }
                }
            }
            .alert("Expense added successfully!", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    dismiss()
                }
            }

            Button("Back to Dashboard") {
                dismiss()
            }
        }
        .padding()
        .navigationTitle("Add Personal Expense")
    }
}

#Preview {
    AddPersonalExpenseView()
}
//
