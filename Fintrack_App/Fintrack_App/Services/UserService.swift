import FirebaseFirestore
import FirebaseAuth

struct UserService {
    
    static func addUser(user: User) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
                throw URLError(.userAuthenticationRequired)
            }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        try docRef.setData(from: user)
    }
    
    static func addUserExpense(userID: String, expense: UserExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID).collection("expenses").document()
        try docRef.setData(from: expense)
    }
    
    static func deleteUserExpense(userID: String, expenseID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("users")
            .document(userID)
            .collection("expenses")
            .document(expenseID)
            .delete()
    }
    
    static func getUserAllExpense(userID: String) async throws -> [UserExpense] {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userID).collection("expenses")
        let snapshot = try await collectionRef.getDocuments()
        let expenses = try snapshot.documents.compactMap { document in
            try document.data(as: UserExpense.self)
        }
        return expenses
    }
    
    static func updateUserExpense(userID: String, expenseID: String, expense: UserExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID).collection("expenses").document(expenseID)
        try docRef.setData(from: expense)
    }
}

