# hopin

*A cross-platform ride-sharing Flutter application.*

##  Table of Contents

* [Overview](#overview)
* [Features](#features)
* [Project Structure](#project-structure)
* [Technologies Used](#technologies-used)

  * [Flutter](#flutter)
  * [Firebase](#firebase)
  * [State Management](#state-management)
  * [Environment Variables](#environment-variables)
  * [UI Libraries](#ui-libraries)
  * [Platform Integration](#platform-integration)
  * [Other Packages](#other-packages)
* [How to Run](#how-to-run)
* [Build & Deployment](#build--deployment)
* [Assets](#assets)
* [Testing](#testing)
* [Configuration Files](#configuration-files)
* [License](#license)
* [References](#references)

---

## Overview

**hopin** is a cross-platform ride-sharing application built using Flutter. It supports Android, iOS, Web, Windows, Linux, and macOS. Users can publish journeys, search for rides, and manage profiles. The app uses Firebase for backend services and leverages modern Flutter packages for UI, state management, and platform integration.

---

##  Features

*  User registration and authentication
*  Publish and search for rides
*  Profile management (with mini bio)
*  Responsive UI with custom theming
*  Toast notifications
*  Cross-platform support: mobile, web, desktop

---

##  Project Structure

```
lib/
├── main.dart
├── models/
├── data/
├── screens/
├── widgets/
└── routes/
assets/
test/
android/
ios/
linux/
macos/
windows/
web/
pubspec.yaml
.env
README.md
```

---

##  Technologies Used

###  Flutter

* **Framework:** Build natively compiled mobile, web, and desktop apps from one codebase.
* **UI:** `MaterialApp`, custom widgets, theming.

###  Firebase

* **Packages:** `firebase_core`, `firebase_auth`
* **Usage:** Initialization in `main.dart`, user authentication, backend integration.

###  State Management

* **Package:** `provider`
* **Usage:** Models like `PublishRideModel`, `SearchRidesModel`, and `UserInfoProvider` injected at the root.

###  Environment Variables

* **Package:** `flutter_dotenv`
* **Usage:** Load sensitive config from `.env` file during startup.

###  UI Libraries

* **Fonts:** `google_fonts`
* **Notifications:** `toastification` for in-app toasts

###  Platform Integration

* **Desktop Plugins:**

  * `file_selector_linux`, `file_selector_windows`
  * `permission_handler_windows`
* **Build Scripts:**

  * `CMakeLists.txt` for Linux/Windows

###  Other Packages

* **Widgets:** Custom buttons and components in `widgets/`
* **Routing:** Centralized in `routes/app_routes.dart`

---

##  How to Run

```bash
# Clone the repository
git clone https://github.com/jawadAly/Hopin
cd hopin

# Install dependencies
flutter pub get

# Create .env file with your configuration
touch .env

# Run the app
flutter run
```

---

##  Build & Deployment

* **Mobile (Android/iOS):**

  ```bash
  flutter build apk # or ios
  ```

* **Firebase:**

  * Config in `firebase.json`
  * Initialization in `main.dart`

---

##  Assets

* All static assets are in the `assets/` folder.
* Managed in `pubspec.yaml`.

---

##  Testing

* Unit and widget tests in the `test/` directory.
* Run all tests:

  ```bash
  flutter test
  ```

---

##  Configuration Files

* `.env`: API keys, secrets
* `pubspec.yaml`: Dependencies and assets
* `firebase.json`: Firebase config
* `analysis_options.yaml`: Lint rules
* `CMakeLists.txt`: Desktop builds
* `index.html`: Web entry point

---

##  License

This project is licensed under the **MIT License**.

---

##  References

* [Flutter Documentation](https://flutter.dev/)
* [Firebase for Flutter](https://firebase.flutter.dev/)
* [Provider Package](https://pub.dev/packages/provider)
* [Google Fonts for Flutter](https://pub.dev/packages/google_fonts)
* [toastification Package](https://pub.dev/packages/toastification)
