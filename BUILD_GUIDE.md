# Life Simulator — Build Guide

> **Build via GitHub Actions is the recommended approach.**  
> This guide covers both local builds (for development) and CI/CD builds (for releases).

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Project Structure](#2-project-structure)
3. [Local Development Builds](#3-local-development-builds)
4. [GitHub Actions CI/CD](#4-github-actions-cicd)
5. [Keystore Management](#5-keystore-management)
6. [Release Process](#6-release-process)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | ≥ 3.22.x stable | Build & compile |
| Dart SDK | ≥ 3.x (bundled with Flutter) | Language runtime |
| Android SDK | 34 (compileSdk) | Android build tools |
| JDK | 17 | Gradle & compilation |
| Git | ≥ 2.x | Version control |

### Quick Install (Linux / macOS)

```bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor

# Accept Android licenses (if needed)
flutter doctor --android-licenses
```

### Quick Install (Windows)

Download from [flutter.dev](https://flutter.dev/docs/get-started/install) and follow the installer.

### First-Time Setup

Since the repository contains only Dart source code (no generated Android/iOS platform directories), you must create them before building:

```bash
# Generate Android platform directory
flutter create --platforms=android --project-name life_simulator .

# This creates android/ without overwriting your Dart code
# Run this once after cloning
```

The CI workflows run this step automatically, so you only need to do this for local builds.

---

## 2. Project Structure

```
life_simulator/
├── .github/workflows/
│   ├── build.yaml         # Main build pipeline
│   ├── pr_checks.yaml     # PR validation
│   └── cleanup.yaml       # Artifact cleanup
├── lib/                   # Dart source code
│   ├── main.dart          # Entry point
│   ├── app.dart           # App widget + routing
│   ├── config/            # Theme, constants, routes
│   ├── models/            # Data models
│   ├── database/          # SQLite database
│   ├── services/          # Core game services
│   ├── providers/         # State management
│   ├── screens/           # UI screens
│   ├── widgets/           # Reusable widgets
│   └── utils/             # Helpers & extensions
├── test/                  # Unit tests
├── pubspec.yaml           # Project configuration
├── analysis_options.yaml  # Lint rules
└── BUILD_GUIDE.md         # This file
```

---

## 3. Local Development Builds

### 3.1 Debug APK (Fast, for testing)

```bash
# Get dependencies
flutter pub get

# Analyze code for errors
flutter analyze

# Run unit tests
flutter test

# Build debug APK
flutter build apk --debug

# Output: build/app/outputs/flutter-apk/app-debug.apk
```

### 3.2 Release APK (Signed, for distribution)

**Step 1 — Create a keystore:**

```bash
# Generate a keystore (one-time)
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

**Step 2 — Configure signing:**

```bash
# Create key.properties
cat > android/key.properties <<EOF
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks
EOF
```

**Step 3 — Build:**

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk

# Or build app bundle (for Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

> **Security:** Never commit `upload-keystore.jks` or `key.properties` to Git.  
> The `.gitignore` already excludes them. Use CI secrets instead.

### 3.3 Build Flavors (Optional)

The project can be extended with build flavors for dev/staging/production:

```bash
flutter build apk --debug --flavor dev
flutter build apk --release --flavor prod
```

---

## 4. GitHub Actions CI/CD

### 4.1 Workflows Overview

| Workflow | Trigger | What it does |
|----------|---------|-------------|
| `pr_checks.yaml` | Every PR to `main`/`develop` | `flutter analyze` + `flutter test` |
| `build.yaml` | Push to `main`, tags `v*`, manual dispatch | Builds debug APK or release AAB |
| `cleanup.yaml` | Daily at 3 AM UTC | Deletes artifacts older than 7 days |

### 4.2 Debug Builds (Push / Manual)

Every push to `main` triggers a debug APK build:

1. Workflow runs `flutter pub get`
2. Runs `flutter analyze` to catch errors
3. Runs `flutter test` with coverage
4. Builds `flutter build apk --debug`
5. Uploads the APK as a workflow artifact

**Download the APK:**

1. Go to your repository on GitHub
2. Click **Actions** → select the completed workflow run
3. Scroll to **Artifacts** → click `life-simulator-debug`
4. Install the APK on your Android device (enable "Unknown sources")

### 4.3 Release Builds (Tags)

Push a version tag to trigger a signed release build:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This produces a signed AAB and creates a **draft GitHub Release**.

### 4.4 Manual Build Dispatch

Trigger any build type from the GitHub UI:

1. Go to **Actions** → **Build Android APK**
2. Click **Run workflow** → select branch → choose `debug` or `release`
3. Click **Run**

### 4.5 Setting Up CI Secrets

For release builds, configure these secrets in your repository:

| Secret | Description | Required for |
|--------|-------------|-------------|
| `ANDROID_KEYSTORE_BASE64` | base64-encoded `.jks` keystore | Release build |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore password | Release build |
| `ANDROID_KEY_ALIAS` | Key alias (e.g., `upload`) | Release build |
| `ANDROID_KEY_PASSWORD` | Key password | Release build |

**How to set secrets:**

```bash
# 1. Generate keystore (if you haven't already)
keytool -genkey -v -keystore upload-keystore.jks \
  -alias upload -keyalg RSA -keysize 2048 -validity 10000

# 2. Encode keystore to base64
base64 -w0 upload-keystore.jks | pbcopy  # macOS
# OR
base64 -w0 upload-keystore.jks > keystore.txt  # Linux

# 3. Add to GitHub:
#    Settings → Secrets and variables → Actions → New repository secret
#    Name: ANDROID_KEYSTORE_BASE64
#    Value: (paste the base64 output)
```

---

## 5. Keystore Management

### 5.1 Default Debug Keystore

Flutter's Android toolchain includes a default debug keystore at:
- **Linux/macOS:** `~/.android/debug.keystore`
- **Windows:** `%USERPROFILE%\.android\debug.keystore`

Debug APKs are **unsigned** (or signed with the debug key).  
They can be installed directly on test devices.

### 5.2 Release Keystore (Production)

Create a dedicated release keystore:

```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -storepass YourStrongPassword \
  -keypass YourStrongPassword
```

**Store passwords in a password manager.** If you lose the keystore, you cannot update your app on the Play Store.

### 5.3 Files excluded from Git

These files are in `.gitignore` and must never be committed:

```
android/key.properties
android/app/upload-keystore.jks
android/app/*.jks
*.jks
*.keystore
```

---

## 6. Release Process

### 6.1 Standard Release Flow

```bash
# 1. Update version in pubspec.yaml
#    version: 1.0.0+1

# 2. Commit and tag
git add pubspec.yaml
git commit -m "chore: bump version to 1.0.0"
git tag v1.0.0

# 3. Push (triggers CI build)
git push origin main --tags
```

### 6.2 What CI does on a tag push

1. Runs `flutter analyze` and `flutter test`
2. Decodes the keystore from `ANDROID_KEYSTORE_BASE64` secret
3. Creates `android/key.properties` from secrets
4. Builds `flutter build appbundle --release`
5. Creates a **draft GitHub Release** with the AAB attached
6. You can then:
   - Download the AAB from the release
   - Upload to Google Play Console
   - Edit the release notes before publishing

### 6.3 Publishing to Google Play

1. Go to [Google Play Console](https://play.google.com/console/)
2. Create a new app or select existing
3. Go to **Production** → **Create new release**
4. Upload the AAB from the GitHub Release
5. Fill in release notes
6. Review and roll out

---

## 7. Troubleshooting

### `flutter: command not found`

```bash
# Add Flutter to your PATH
export PATH="$PATH:$HOME/flutter/bin"
# Add this line to ~/.bashrc or ~/.zshrc for persistence
```

### `Android license status unknown`

```bash
flutter doctor --android-licenses
```

### `Gradle build fails with OutOfMemoryError`

```bash
# In android/gradle.properties, add:
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=1g
```

### `Build failed with "Keystore was tampered with, or password was incorrect"`

1. Double-check the secrets in GitHub Settings
2. Regenerate the base64 encoding:
   ```bash
   base64 -w0 android/app/upload-keystore.jks
   ```
3. Update the `ANDROID_KEYSTORE_BASE64` secret

### `Debug APK installs but crashes on launch`

```bash
# Check for common issues:
flutter analyze                  # Lint errors
flutter test                     # Failing tests
adb logcat | grep flutter        # Android runtime logs
```

### `"lib/main.dart" not found`

Make sure the Flutter project structure is complete:
```bash
# Recreate from scratch if needed:
flutter create --project-name life_simulator .
```

---

## Quick Reference

```bash
# === Debug build ===
flutter pub get && flutter build apk --debug

# === Release build (local) ===
flutter pub get && flutter build appbundle --release

# === Analyze ===
flutter analyze

# === Run tests ===
flutter test
flutter test --coverage

# === Tag & release ===
git tag v1.0.0 && git push origin v1.0.0

# === Manual CI trigger ===
# GitHub → Actions → Build Android APK → Run workflow
```
