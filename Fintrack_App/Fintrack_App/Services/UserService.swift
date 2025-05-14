import FirebaseFirestore
import FirebaseAuth

// handle firebase call to add a user collection or edit fields in user collection
// it first store data locally and then sync to firebase
struct UserService {
    
    // add a new user document to "users" collection
    // call after sign up for a new user
    static func addUser(user: User) throws {
        guard let uid = Auth.auth().currentUser?.uid else {
                throw URLError(.userAuthenticationRequired)
            }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        try docRef.setData(from: user)
    }
    
    // add a user expense document to "userExpenses" subcollection
    static func addUserExpense(userID: String, expense: UserExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID).collection("userExpenses").document()
        try docRef.setData(from: expense)
    }
    
    // delete a user expense document in "userExpenses" subcolletion
    static func deleteUserExpense(userID: String, expenseID: String) async throws {
        let db = Firestore.firestore()
        try await db.collection("users")
            .document(userID)
            .collection("userExpenses")
            .document(expenseID)
            .delete()
    }
    
    // return a list with all userExpense document for a specific user
    static func getUserAllExpense(userID: String) async throws -> [UserExpense] {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users").document(userID).collection("userExpenses")
        let snapshot = try await collectionRef.getDocuments()
        let expenses = try snapshot.documents.compactMap { document in
            try document.data(as: UserExpense.self)
        }
        return expenses
    }
    
    // update a user expense document in "userExpenses" subcolletion
    static func updateUserExpense(userID: String, expenseID: String, expense: UserExpense) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID).collection("userExpenses").document(expenseID)
        try docRef.setData(from: expense)
    }
    
    static func addGroupID(groupID: String, userID: String) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        docRef.updateData([
                "groups": FieldValue.arrayUnion([groupID])
            ])
    }
    
    static func removeGroupID(groupID: String, userID: String) throws {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        docRef.updateData([
            "groups": FieldValue.arrayRemove([groupID])
        ])
    }
}

