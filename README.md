# 💰 Money Tracker App

A simple and clean mobile app built with Flutter to help users track their personal income and expenses. All data is stored locally using SQLite for fast and offline access.

---

## 📱 Features

- ➕ Add income or expense transactions
- 📋 View transaction history in a scrollable list
- 📅 Select custom transaction date
- 📊 Weekly or monthly financial overview (optional)
- 💾 Offline local storage using `sqflite`

---

## 🛠️ Built With

- **Flutter** – Cross-platform mobile development
- **Dart** – Programming language
- **sqflite** – Local SQLite database for persistence
- **intl** – For date and currency formatting

---

## 📂 Folder Structure

📂lib/
├── main.dart
├── 📂models/
│ └── trancs.dart
├── 📂helpers/
│ └── db_helper.dart
├── 📂screens/
│ ├── add_tranc.dart
│ ├── trancs_screen.dart
│ ├── report.dart
│ └── expence_home_screen.dart


## 🚀 Getting Started

### Prerequisites

- Flutter SDK installed → [Flutter install docs](https://docs.flutter.dev/get-started/install)
- A connected device or emulator

### Run the app
```bash
flutter pub get
flutter run

📄 License
This project is open source and available under the MIT License.

🙌 Author
Made by Marshell Fitriawan

