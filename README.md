# CosTrack 

A lightweight personal expense tracker built with Flutter. CosTrack lets you log, categorize, and review your daily spending — all in a clean, minimal, easy-to-use mobile interface.

**This project is a midterm project for "Web/Mobile Application Development" subject of Computer Engineering Department, KOSEN-KMITL.**

---

## Features

- **Add expenses** — Record a new cost with a title, amount, currency, category, and date
- **Expense list** — Browse all recorded expenses in a scrollable list with category icons
- **Filter & sort** — Filter by category or currency, and toggle sort order by amount
- **Dynamic totals** — See a live sum of all expenses matching the current filter
- **Edit expenses** — Tap the edit icon on any entry to update its details
- **Multi-currency support** — Supports THB, USD, EUR, JPY, and more

## Screens

| Screen | Description |
|--------|-------------|
| Dashboard | Welcome screen with navigation to Add and List views |
| New Cost | Form to record a new expense (title, amount, currency, date, category) |
| Cost List | Filterable, sortable list of all expenses with a total summary banner |
| Edit Cost | Pre-filled form to update an existing expense entry |

## Tech Stack

- **Framework:** Flutter (Dart)
- **SDK:** Dart `^3.12.2`
- **Key packages:**
  - `intl` — Date and number formatting
  - `cupertino_icons` — iOS-style icon support
- **Design:** Material 3 with a teal color scheme

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
- A connected device or emulator (Android or iOS)

### Run locally

```bash
# Clone the repository
git clone <your-repo-url>
cd costrack

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for release

```bash
# Android
flutter build apk

# iOS (requires macOS + Xcode)
flutter build ios
```

## Project Structure

```
costrack/
├── lib/
│   └── main.dart          # App entry point
├── test/
│   ├── placeholder.dart   # Full UI implementation (screens & models)
│   └── widget_test.dart   # Widget tests
├── android/               # Android platform files
├── ios/                   # iOS platform files
└── pubspec.yaml           # Dependencies and project config
```

## Categories

Expenses can be tagged with one of the following categories:

- 🍔 Food & Drinks
- 🚗 Transport
- 🛍️ Shopping
- 🎬 Entertainment
- 💳 Others

## Contributing
Contributions are welcome. Please open issues for bugs or feature requests and submit pull requests for improvements.

## Contributors
- NessShadow — Repository Owner / Maintainer
- fahatlegend1 — Contributor

Thanks to everyone who helps improve this project. See the GitHub contributors list for the full history.

## License

This project is private and not published to pub.dev.
