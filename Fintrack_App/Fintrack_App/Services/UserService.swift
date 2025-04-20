//
//  UserService.swift
//  Fintrack_App
//
//  Created by Alisa Gao on 4/14/25.
//

import FirebaseFirestore

struct UserService {
    
    static func addUser(user: User, completion: @escaping (Error?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document()
        
        var newUser = user
        newUser.id = docRef.documentID
        
        do {
            let encoded = try Firestore.Encoder().encode(newUser)
            docRef.setData(encoded) { error in
                completion(error) // notify caller of success or failure
            }
        } catch {
            completion(error) // encoding failed
        }
    }
    
    static func addUserExpense(userId: String, expense: UserExpense, completion: @escaping (Error?) -> Void) {
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId).collection("expenses").document()
        
        do {
            let encoded = try Firestore.Encoder().encode(expense)
            docRef.setData(encoded) { error in
                completion(error) // notify caller of success or failure
            }
        } catch {
            completion(error) // encoding failed
        }
    }
}
