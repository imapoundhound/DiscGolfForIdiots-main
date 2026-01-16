# DiscGolfForIdiots

A fun disc golf scoring application for iOS and Android.

## Project Setup

This is a cross-platform application with iOS (Swift) and Android (Kotlin) frontends, both with Firebase integration for real-time data synchronization and analytics.

### Prerequisites

**For iOS:**
- Xcode 15.0 or later
- iOS 14.0 or later target
- CocoaPods (for dependency management)

**For Android:**
- Android Studio or Android SDK
- Android API 21 (Android 5.0) or later target
- Java 11 or later
- Gradle 8.5+

### iOS Setup

1. **Install CocoaPods Dependencies**
   ```bash
   pod install
   ```

2. **Open the Workspace**
   ```bash
   open DiscGolfForIdiots.xcworkspace
   ```

3. **Build & Run**
   - Select a simulator or device
   - Press Cmd+R to build and run

### Android Setup

1. **Navigate to Android Directory**
   ```bash
   cd android
   ```

2. **Build the Project**
   ```bash
   ./gradlew build
   ```

3. **Build APK**
   - Debug: `./gradlew assembleDebug`
   - Release: `./gradlew assembleRelease`

4. **Run Tests**
   ```bash
   ./gradlew test
   ```

5. **Open in Android Studio**
   - File → Open → Select `android` folder
   - Or use: `android/gradlew :app:tasks`

### Firebase Configuration

- **iOS**: The `GoogleService-Info.plist` file is included for iOS Firebase configuration
- **Android**: The `google-services.json` file is included for Android Firebase configuration

Both files should be properly integrated into their respective projects.

### Project Structure

```
DiscGolfForIdiots-main/
├── .github/
│   └── workflows/              # GitHub Actions CI/CD
├── .vscode/
│   ├── tasks.json              # VS Code build tasks (iOS & Android)
│   ├── settings.json           # Editor settings
│   └── launch.json             # Debug configuration
├── android/                    # Android project (Kotlin + Compose)
│   ├── app/
│   ├── gradle/wrapper/
│   ├── build.gradle            # Project-level Gradle config
│   ├── settings.gradle         # Gradle settings
│   ├── gradle.properties       # Gradle properties
│   └── gradlew                 # Gradle wrapper
├── GoogleService-Info.plist    # Firebase iOS configuration
├── google-services.json        # Firebase Android configuration
├── Podfile                     # iOS CocoaPods configuration
├── .gitignore
└── README.md
```

### Features

- Score tracking for disc golf rounds
- Firebase backend integration
- Real-time synchronization across platforms
- Location-based course discovery
- User authentication

### Development

Available VS Code tasks:

**iOS Tasks:**
- Install CocoaPods Dependencies
- Update CocoaPods
- Build iOS Project
- Build for Testing
- Run Tests
- Clean Build Folder

**Android Tasks:**
- Build Android Project
- Build Android APK (Debug)
- Build Android APK (Release)
- Run Android Tests
- Clean Android Build

Run any task with: `Ctrl+Shift+B` (Quick Build) or `Ctrl+Shift+P` → "Tasks: Run Task"

### Building for Production

**iOS:**
```bash
xcodebuild -workspace DiscGolfForIdiots.xcworkspace -scheme DiscGolfForIdiots -configuration Release
```

**Android:**
```bash
cd android
./gradlew assembleRelease
```
