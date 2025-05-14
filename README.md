
# 📱 Fintrack - Group & Personal Expense Tracker

Fintrack is a modern iOS app designed to help users track shared and personal expenses — ideal for roommates, friends, or any group managing shared finances.

---

## 🎓 Course Information

This app was developed as a final project for **CPSC 411 - iOS Development**  
California State University, Fullerton

---

## 🔐 Authentication Features

- Secure sign up and login using **Firebase Authentication**
- Session is persisted across app launches

---

## 👥 Group Management

- Create custom-named groups
- Invite members by email (users must already be registered)
- View group details:
  - Member list
  - Group expense history
  - Running balance of who owes whom

---

## 💰 Group Expenses

- Add expenses with:
  - Description
  - Amount
  - Paid by
  - Split with selected members or split equally
- Edit or delete existing group expenses
- Balances auto-update using net settlement logic
- Long-press on an expense to open edit/delete sheet

---

## 🧍 Personal Expenses

- Add, view, and manage your own personal expenses
- Edit or delete directly from the dashboard

---

## 📊 Balance Summary

- Compact, readable summary per group:
  > Total Balance: Alice → Bob: $20.00, Charlie → Alice: $15.50

---

## ⚙️ Additional Features

- Edit group name from dashboard
- Leave group by removing group ID from user
- Logout functionality

---

## 🧰 Tech Stack

- **SwiftUI** – for modern declarative UI
- **Firebase Authentication** – for secure login
- **Firestore** – for real-time data sync
- **SF Symbols** – for native iconography

---

## 🚧 Planned Improvements

- Push notifications
- Expense categories & filtering
- Profile pictures or avatars

---

## 🛠 Setup Instructions

1. Clone this repository
2. Add your `GoogleService-Info.plist` file from Firebase Console
3. Open in Xcode
4. Run on simulator or physical device

---

