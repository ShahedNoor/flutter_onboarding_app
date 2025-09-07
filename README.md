# ⏰ Flutter Onboarding App

A simple Flutter app to set alarms with notifications and location-based features.  
This project was built as part of a developer evaluation task.

---

## 📷 Screenshots

![Onboarding App Screenshot](https://i.ibb.co.com/Z1VTst3b/Onboarding-App-Screenshot.png)

---

## 🎥 Demo Video

You can watch the app running here:  
👉 [Click to watch on Loom](https://www.loom.com/share/5083283538f145369b5dd379dd97ee30?sid=6c569418-9904-485d-917a-465453444f79)

[![Watch the video](https://i.ibb.co.com/1tp5Rzkr/image-with-play-button.png)](https://youtube.com/shorts/3_H4hI-yyIg?si=Xj2ytBPSMAm7Hw42)

---

## 🛠 Tools & Packages Used

The following packages were used in this project:

- **State Management**
  - `provider: ^6.1.5+1` – manage app state

- **Location**
  - `geolocator: ^14.0.2` – get the device location  
  - `geocoding: ^4.0.0` – convert coordinates to readable addresses  

- **Notifications & Timezone**
  - `flutter_local_notifications: ^19.4.1` – show and schedule notifications  
  - `timezone: ^0.10.1` – handle local time zones  
  - `flutter_timezone: ^4.1.1` – get device timezone  

- **UI**
  - `dots_indicator: ^4.0.1` – onboarding page indicators  

- **Permissions & Intents**
  - `permission_handler: ^12.0.1` – request permissions (exact alarms, location, etc.)  
  - `android_intent_plus: ^5.3.1` – open Android settings for permissions  

---

## 🚀 Project Setup Instructions

Follow these steps to set up and run the project locally:

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (latest stable version)
- **Dart SDK** (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or **Physical Android Device**
- **Git**

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/flutter-alarm-app.git
   cd flutter-alarm-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```
   Make sure all checkmarks are green. If there are any issues, follow the suggestions provided.

4. **Set up Android Emulator (if not using physical device)**
   - Open Android Studio
   - Go to Tools → AVD Manager
   - Create a new virtual device or start an existing one
   - Make sure the emulator is running

5. **Connect physical device (alternative to emulator)**
   - Enable Developer Options on your Android device
   - Enable USB Debugging
   - Connect your device via USB
   - Verify connection with: `flutter devices`

6. **Run the app**
   ```bash
   flutter run
   ```
   or
   ```bash
   flutter run --debug
   ```

### For Development

- **Hot Reload**: Press `r` in the terminal while the app is running
- **Hot Restart**: Press `R` in the terminal while the app is running
- **Debug mode**: `flutter run --debug`
- **Release mode**: `flutter run --release`

---

## 📱 Platform Support

- ✅ **Android** (Primary target)
- ⚠️ **iOS** (May require additional setup for notifications and permissions)

---

## 🔧 Configuration

### Android Permissions

The app requires the following permissions which are automatically handled:

- **Location Access** - for location-based features
- **Exact Alarms** - for precise alarm scheduling
- **Notifications** - for alarm notifications
- **Boot Completed** - to restart alarms after device reboot

### Notification Setup

The app is pre-configured to handle local notifications. No additional setup required.

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
├── providers/               # State management (Provider)
├── screens/                 # UI screens
├── widgets/                 # Reusable UI components
├── services/               # Business logic & API calls
└── utils/                  # Utility functions & constants
```

---

## 🧪 Testing

Run tests with:

```bash
flutter test
```

---

## 📦 Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (recommended for Play Store)
```bash
flutter build appbundle --release
```

The built files will be available in `build/app/outputs/`

---

## 🐛 Troubleshooting

### Common Issues

1. **Gradle build fails**
   ```bash
   cd android
   ./gradlew clean
   cd ..
   flutter clean
   flutter pub get
   ```

2. **Permission denied errors**
   - Make sure your device has Developer Options enabled
   - Check USB Debugging is turned on

3. **App crashes on startup**
   - Check if all permissions are properly configured
   - Run `flutter clean && flutter pub get`

4. **Emulator not detected**
   ```bash
   flutter devices
   ```
   If no devices shown, restart your emulator or check USB connection.



## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Your Name**
- GitHub: [@Shahed Noor](https://github.com/shahednoor)
- Email: shahednoor32@gmail.com

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Package maintainers for the excellent plugins
- Community for support and inspiration

---

**⭐ If you found this project helpful, please give it a star!**