# Blink — Flutter / GetX / FCM Professional Assessment

Blink is a professional, lightweight customer application built with Flutter. It demonstrates a clean feature-based architecture, idiomatic use of GetX for state and dependency management, and a robust networking layer.

## 🚀 Tech Stack
- **Flutter**: Latest stable version.
- **GetX**: For state management, high-performance routing, and dependency injection.
- **Dio**: A powerful HTTP client with centralized interceptors for networking.
- **Firebase Cloud Messaging (FCM)**: For real-time push notification integration.
- **Shared Preferences**: For persistent local storage.
- **Shimmer & CachedNetworkImage**: To provide a premium visual experience during data loading.

## 🏗️ Architecture
The project follows a **Feature-First Architecture**, ensuring scalability and maintainability:
- **Core**: Contains shared services, network configurations, global themes, and localization logic.
- **Features**: Isolated functional modules (Auth, Home, Store, Profile, Notifications). Each feature consists of:
    - **Data**: Models and remote/local data sources.
    - **Domain**: Repository interfaces and implementations.
    - **Presentation**: UI screens, reusable widgets, and GetX Controllers.
    - **Bindings**: Dependency injection logic for the specific feature.

## ✨ Key Features
1.  **Authentication System**: Secure login flow using phone number and OTP verification.
2.  **Dynamic Home Screen**: Real-time rendering of banners and featured stores driven by backend sections.
3.  **Store & Products**: Comprehensive store details with paginated product lists (Infinite Scroll).
4.  **User Profile**: Profile management with a seamless language toggle (English ↔ Arabic).
5.  **Notifications**: In-app notification list and foreground FCM push handling.
6.  **Full RTL Support**: Pixel-perfect layout adjustments for Arabic localization.

## 🛠️ Setup & Installation
1.  **Clone the repository.**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Firebase Configuration**:
    - Add your `google-services.json` to `android/app/`.
    - Add your `GoogleService-Info.plist` to `ios/Runner/`.
4.  **Run the application**:
    ```bash
    flutter run
    ```

## 🔔 FCM Implementation Notes
- **Foreground**: Notifications are intercepted and displayed using a custom `Get.snackbar`.
- **Background/Terminated**: Handled via the native system tray; supports deep-linking logic to specific screens.
- **Web Support**: The codebase includes guards (`kIsWeb`) to ensure the app runs smoothly on Chrome without Service Worker conflicts.

---
Developed with focus on code quality, performance, and adherence to industry best practices.
