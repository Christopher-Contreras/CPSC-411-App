import XCTest
import Firebase
import FirebaseFirestore
@testable import Fintrack_App

final class GroupServiceTests: XCTestCase {

    override class func setUp() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    func testGroupService_AddExpensesAndCalculateBalance() async throws {
        let db = Firestore.firestore()

        // Step 1: Create 4 test users
        let userIDs = (1...4).map { _ in UUID().uuidString }
        let userNames = ["Alice", "Bob", "Charlie", "Diana"]

        for (uid, name) in zip(userIDs, userNames) {
            try await db.collection("users").document(uid).setData([
                "email": "\(name.lowercased())@test.com",
                "userName": name,
                "group": []
            ])
        }

        // Step 2: Create a group using GroupService
        let group = Group(
            groupName: "Service Test Group",
            groupMembers: Dictionary(uniqueKeysWithValues: zip(userIDs, userNames)),
            balance: [:]
        )
        try GroupService.addGroup(group: group)

        // Step 3: Retrieve groupID from Firestore
        let snapshot = try await db.collection("groups")
            .whereField("groupName", isEqualTo: "Service Test Group")
            .getDocuments()

        guard let groupDoc = snapshot.documents.first else {
            return XCTFail("Group not created.")
        }
        let groupID = groupDoc.documentID

        // Step 4: Add 4 expenses to the group
        let amounts: [Double] = [100, 80, 120, 60]
        for i in 0..<4 {
            let payer = userIDs[i]
            let share = amounts[i] / 4.0
            let split = Dictionary(uniqueKeysWithValues: userIDs.map { ($0, share) })

            let expense = GroupExpense(
                description: "Expense \(i + 1)",
                amount: amounts[i],
                paidBy: payer,
                splitBetween: split
            )
            try GroupService.addGroupExpense(groupID: groupID, expense: expense)
        }

        // Step 5: Delay briefly to let Firestore finish writing
        try await Task.sleep(nanoseconds: 500_000_000)

        // Step 6: Call updateGroupBalance
        try await GroupService.updateGroupBalance(groupID: groupID)

        // Step 7: Verify that the balance field exists and is not empty
        let updatedGroup = try await db.collection("groups").document(groupID).getDocument()
        guard let balanceMap = updatedGroup.data()?["balance"] as? [String: Double] else {
            return XCTFail("Balance field not found.")
        }

        print("Final Balance:", balanceMap)
        XCTAssertFalse(balanceMap.isEmpty, "Balance should not be empty.")
    }
}
