//
//  AuthViewModel.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/1/25.
//


import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    init() {
        // If user is already logged in (session persists)
        self.isAuthenticated = Auth.auth().currentUser != nil
    }

    func login(email: String, password: String) {
        
        // Skipped calling firebase in preview
        guard !ProcessInfo().isPreview else {
            print("Login skipped in preview.")
            return
        }

        errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isAuthenticated = true
                }
            }
        }
    }

    func signup(email: String, password: String, userName: String) {
        guard !ProcessInfo().isPreview else {
            print("Signup skipped in preview.")
            return
        }

        errorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isAuthenticated = true
                }
            }
            
            guard let user = result?.user else {
                            self?.errorMessage = "Unexpected error: No user returned."
                            return
                        }

                        // add user name
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = userName
                        changeRequest.commitChanges { error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    self?.errorMessage = "Signup succeeded but setting username failed: \(error.localizedDescription)"
                                } else {
                                    self?.isAuthenticated = true
                                }
                            }
                        }
        }
        
        
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

extension ProcessInfo {
    var isPreview: Bool {
        environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
