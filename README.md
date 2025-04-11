# iOS-Style Utility Apps on Android using Flutter

This project is a collection of iOS-style utility applications developed with **Flutter** and optimized for Android devices. Inspired by native iOS apps, the design and user experience closely mimic Apple's UI while fully functioning in the Android ecosystem.

## ✨ Features

### 🕰 Clock Page

- Displays real-time digital and analog clock.
- Automatically updates time every second.
- Includes date and timezone display (e.g., Hanoi, GMT+7).
- Designed with smooth animation and Apple-style UI.

### ⏰ Alarm Page

- Add, toggle, or delete alarms using a beautiful and intuitive interface.
- Alarms saved persistently using `SharedPreferences`.
- Periodic check every 10 seconds to trigger alarms.
- Integrated with `vibration` plugin for alert feedback.

### 🧮 Calculator Page

- iOS-like calculator with elegant button layout and real-time input display.
- Supports operations: `+`, `-`, `×`, `÷`, `%`, decimal points.
- Calculates expressions using `math_expressions` package.
- Responsive UI and interactive feedback for each button.

### ⏱ Stopwatch Page (Bấm giờ)

- iOS-style stopwatch with beautiful Cupertino design.
- Shows time with minute, second, and hundredths of a second precision.
- Functions include:
  - **Start/Stop** stopwatch.
  - **Lap** to record split times.
  - **Reset** the stopwatch when stopped.
- Lap records are displayed in a scrollable list, with fastest lap highlighted in green and slowest in red.
- Built using `Ticker` from Flutter's animation framework for real-time updates.

### ⏳ Timer Page (Hẹn giờ)

- User can set countdown time using Cupertino-style pickers (hours, minutes, seconds).
- Functions include:
  - **Start** countdown timer.
  - **Cancel** during countdown.
  - Displays the **remaining time** in large, readable format.
- Countdown history is saved and displayed below the timer.
- Clean dark theme interface with interactive buttons and Cupertino animations.

## 📱 Screenshots

_Coming soon... (you can include screenshots here if desired)_

## 🚀 Getting Started

### Requirements

- Flutter SDK
- Android Studio or VSCode
- Dart ≥2.17

### Run Locally

1. Clone this repo:
   ```bash
   git clone https://github.com/your-username/flutter-ios-style-apps.git
   cd flutter-ios-style-apps
   ```
