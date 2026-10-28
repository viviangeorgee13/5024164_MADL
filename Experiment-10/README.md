
# Experiment 10: Testing and Deploying a Flutter App on Android

## Aim
To test and deploy a production-ready Flutter application on the Android platform.

## Project
QuickRide - Ride Booking Application

## Features
- Home screen with a welcome message
- Destination input field
- Multiple ride options with estimated fares
- Ride selection dialog
- Rides and Notifications sections
- User Profile section
- Bottom navigation bar

## Technology Used
- Flutter
- Dart
- Material Design

## Testing
Run the following commands in the Flutter project directory:

1. Download dependencies:
   flutter pub get

2. Analyze the code:
   flutter analyze

3. Run available tests:
   flutter test

## Android Deployment
Generate a release APK using:

flutter build apk --release

The APK is normally generated at:

build/app/outputs/flutter-apk/app-release.apk

**Note:** These commands describe the testing and deployment procedure. They must be executed to confirm that the application builds and runs successfully.
