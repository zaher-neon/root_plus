# Root Plus - Run Root Commands Easily

![Package Version](https://img.shields.io/pub/v/root_plus)
![Flutter Version](https://img.shields.io/badge/flutter-3.32.6-blue)
![Package License](https://img.shields.io/badge/license-MIT-purple.svg)



A Flutter plugin to request root access and execute privileged commands on rooted Android devices.

## Features

- Request root access
- Execute single or multiple root commands
- Get command output and error streams
- Simple, clean API

## Installation

Change NDK Version to 27.0.12077973 or Newer:
```
android {
    ndkVersion = "27.0.12077973"
    ...
}
```
Install Plugin:
```bash
flutter pub add root_plus
```

## Usage Guide

### 1. Import the package

```dart
import 'package:root_plus/root_plus.dart';
```

### 2. Request Root Access

Check if root access is available:

```dart
bool hasRoot = await RootPlus.requestRootAccess();

if (hasRoot) {
  print('Root access granted!');
  
} else {
  print('Root access denied or device not rooted');
}
```

### 3. Execute Commands

#### Single Command:

```dart
try {
  String result = await RootPlus.executeRootCommand('pm list packages');
  print('Installed packages: $result');
  
} on RootCommandException catch (e) {
  print('Command failed: ${e.message}');
}
```

#### Multiple Commands (using ```\n```):

```dart
try {
  String result = await RootPlus.executeRootCommand("echo Hello\necho World\npm list packages");
  print('Commands output: $result');
  
} on RootCommandException catch (e) {
  print('Error executing commands: ${e.message}');
}
```

### Exceptions

All methods may throw `RootCommandException` with these properties:
- `code`: Error type (e.g., "COMMAND_FAILED")
- `message`: Human-readable error message
- `details`: Additional error details (often the command output)

## Requirements

- Rooted Android Phone
- Tested on Android 15, I didn't tested on other android versions.

## Warning

⚠️ **Use with caution!** Root access gives complete control over the device.
Incorrect commands can brick your device.

## Author

Developed by [Zaher](https://github.com/zaher-neon)
