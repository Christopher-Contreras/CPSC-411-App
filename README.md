Fintrack - Group & Personal Expense Tracker 💸

Fintrack is a modern iOS app that helps users track shared and personal expenses effortlessly — perfect for roommates, friends, or anyone managing group finances.

📚 This app was developed as a final project for **CPSC 411 - iOS Development** at California State University, Fullerton.

🌟 Features

🔐 Authentication
- Secure sign up and login using Firebase Authentication
- Persists login session between app launches

👥 Group Management
- Create groups and give them custom names
- Invite members by email (users must exist in the system)
- Each group shows:
  - A list of members
  - A running balance of who owes whom
  - A history of group expenses

💰 Group Expenses
- Add shared expenses with:
  - Description, amount, paid by, and members involved
  - Option to split equally or select specific members
- Edit or delete any group expense
- Balances automatically update using net settlement logic
- Long press on an expense to open edit/delete sheet

🧍 Personal Expenses
- Track your own personal expenses
- View all expenses in a simple list
- Edit or delete personal expenses directly from the dashboard

📊 Balance Summary
- For each group, see a summary like:
  Total Balance: Alice → Bob: $20.00, Charlie → Alice: $15.50

⚙️ Additional Features
- Edit group name from the dashboard
- Leave group by removing the group ID from your account
- Logout securely

📱 Technologies Used
- SwiftUI (modern declarative UI)
- Firebase Authentication
- Firestore Database
- SF Symbols for UI icons

🚧 Planned Improvements
- Push notifications
- Expense categories & filtering
- User avatars or profile pictures

🛠 Setup
- Clone the repo
- Add your GoogleService-Info.plist from Firebase
- Run in Xcode on simulator or real device