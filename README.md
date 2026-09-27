# 🌊 AquaSense

**Smart Water Quality Monitoring Dashboard**

A Flutter-based real-time water quality monitoring system that connects to IoT sensors via Firebase Realtime Database. AquaSense provides instant visibility into critical water parameters, device connectivity status, and historical trend analysis to help you maintain optimal water quality.

---

## 📋 Table of Contents

- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
  - [Firebase Setup](#firebase-setup)
  - [Environment Setup](#environment-setup)
  - [Run the App](#run-the-app)
- [Data Structure](#data-structure)
  - [Live Sensor Data](#live-sensor-data)
  - [Interval History](#interval-history)
- [App Structure](#app-structure)
- [Features Guide](#features-guide)
  - [Dashboard](#dashboard)
  - [Device Connectivity](#device-connectivity)
  - [Reports & Analytics](#reports--analytics)
- [Database Schema](#database-schema)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### Real-Time Monitoring
- **Live Sensor Readings**: pH, TDS (Total Dissolved Solids), Turbidity, Temperature
- **Water Quality Index (WQI)**: Composite score indicating overall water quality
- **Battery Status**: Real-time device battery level tracking
- **Device Status**: Online/Offline connectivity indicators

### Device Management
- **Connectivity Monitoring**: WiFi and sensor connection status
- **Battery Analytics**: Visual usage tracking and remaining capacity
- **Last Seen Timestamp**: Know when your device last reported data

### Reports & Analytics
- **Daily Trends**: Hourly granular data visualization for any metrics
- **Monthly Trends**: Aggregated daily data across full month
- **Multi-Metric View**: Compare all parameters simultaneously
- **Date Selection**: Pick specific dates/months for detailed analysis

### User Interface
- **Beautiful Material Design**: Modern, responsive card-based layout
- **Interactive Charts**: Smooth line charts with data point highlighting
- **Color-Coded Status**: Visual indicators for water quality (Good/Needs Attention)
- **Bottom Navigation**: Easy switching between Dashboard, Connectivity, and Reports

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter App (AquaSense)                 │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐                 │
│  │  DashboardScreen │  │ ConnectivityScreen│                │
│  │                  │  │                    │  ┌──────────┐  │
│  │  • Live Data     │  │  • WiFi Status   │  │ Reports  │  │
│  │  • WQI Score     │  │  • Sensor Status │  │ Screen   │  │
│  │  • Status        │  │  • Battery Level │  │          │  │
│  └──────────────────┘  └──────────────────┘  └──────────┘  │
│           │                     │                   │       │
└───────────┼─────────────────────┼───────────────────┼───────┘
            │                     │                   │
            └─────────────────────┼───────────────────┘
                                  │
                    ┌─────────────────────────┐
                    │   FirebaseService       │
                    │  (Data Management)      │
                    └─────────────────────────┘
                                  │
                    ┌─────────────────────────────────┐
                    │  Firebase Realtime Database     │
                    │                                 │
                    │  ├─ /sensor_data (live)         │
                    │  ├─ /sensorHistory (timestamped)│
                    │  └─ /calibration_data           │
                    └───────────────────────────────���─┘
                                  │
                    ┌─────────────────────────┐
                    │   ESP32 / IoT Sensor    │
                    │   (Water Quality Probe) │
                    └─────────────────────────┘
```

### Data Flow

```
ESP32 Sensor
    │
    ├─→ [WiFi] ──→ Firebase Realtime Database
    │                      │
    │                      ├─→ Live Feed (/sensor_data)
    │                      │      └─→ Dashboard (Real-time Stream)
    │                      │
    │                      └─→ History (/sensorHistory)
    │                             └─→ Reports (Filtered by Date)
    │
    └─→ [Periodic Intervals] → Cloud Function / ESP32 Logic
                                   │
                                   └─→ Saves timestamped records
```

---

## 🛠️ Technology Stack

### Frontend
- **Framework**: Flutter 3.12+
- **Language**: Dart
- **UI Framework**: Material Design 3
- **State Management**: StreamBuilder (Firebase Streams)

### Backend & Database
- **Real-time Database**: Firebase Realtime Database
- **Authentication**: Firebase (optional)
- **Cloud Functions**: For interval-based history logging (optional)

### Dependencies
- `firebase_core: ^4.2.1` - Firebase initialization
- `firebase_database: ^12.0.1` - Realtime database access
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `flutter_lints: ^6.0.0` - Code quality

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.12.0 or higher
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- Active Firebase project with Realtime Database enabled

### Firebase Setup

#### Step 1: Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a new project" or select existing project
3. Name it (e.g., "AquaSense")
4. Enable Google Analytics (optional)

#### Step 2: Enable Realtime Database
1. In Firebase Console, navigate to **Realtime Database**
2. Click **Create Database**
3. Select **Start in test mode** (for development)
   - ⚠️ **Note**: Configure proper security rules before production
4. Choose a database location
5. Click **Enable**

#### Step 3: Configure Flutter App
```bash
# From the project root directory
flutterfire configure

# Select platforms: Android and iOS
# This generates firebase_options.dart automatically
```

#### Step 4: Initialize Firebase Data
Add this structure to your Firebase Realtime Database at `/`:

```json
{
  "sensor_data": {
    "pH": 7.2,
    "tds": 450,
    "turbidity": 12,
    "temperature": 28.5,
    "battery": 85,
    "online": true
  },
  "calibration_data": {
    "last_seen": 1735689600000
  },
  "sensorHistory": {
    "1735689600000": {
      "timestamp": 1735689600000,
      "pH": 7.2,
      "tds": 450,
      "turbidity": 12,
      "temperature": 28.5
    },
    "1735693200000": {
      "timestamp": 1735693200000,
      "pH": 7.25,
      "tds": 455,
      "turbidity": 11,
      "temperature": 28.8
    }
  }
}
```

#### Security Rules (Development)
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

⚠️ **IMPORTANT**: Before production, implement proper security rules:

```json
{
  "rules": {
    "sensor_data": {
      ".read": "auth != null",
      ".write": "auth != null && auth.uid == root.child('admin_uid').val()"
    },
    "sensorHistory": {
      ".read": "auth != null",
      ".write": "auth != null && auth.uid == root.child('admin_uid').val()"
    }
  }
}
```

### Environment Setup

```bash
# Clone the repository
git clone https://github.com/Binupa-21/AquaSense.git
cd AquaSense

# Get dependencies
flutter pub get

# (If not already done) Configure Firebase
flutterfire configure
```

### Run the App

```bash
# Development mode
flutter run

# Release build
flutter run --release

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release
```

---

## 📊 Data Structure

### Live Sensor Data

**Location**: `/sensor_data`

Real-time sensor readings pushed by your ESP32 or IoT device:

```json
{
  "pH": 7.2,
  "tds": 450,
  "turbidity": 12,
  "temperature": 28.5,
  "battery": 85,
  "online": true
}
```

| Field | Type | Unit | Range | Description |
|-------|------|------|-------|-------------|
| `pH` | Double | pH | 0-14 | Acidity/alkalinity level |
| `tds` | Double | ppm | 0-2000 | Total dissolved solids |
| `turbidity` | Double | NTU | 0-100 | Water clarity/cloudiness |
| `temperature` | Double | °C | -10-60 | Water temperature |
| `battery` | Double | % | 0-100 | Device battery remaining |
| `online` | Boolean | - | true/false | Device connectivity status |

**Update Frequency**: Can be updated in real-time as sensor reads new values

### Interval History

**Location**: `/sensorHistory`

Timestamped historical records for trend analysis. Save one record per reading interval:

```json
{
  "sensorHistory": {
    "1735689600000": {
      "timestamp": 1735689600000,
      "pH": 7.2,
      "tds": 450,
      "turbidity": 12,
      "temperature": 28.5
    },
    "1735693200000": {
      "timestamp": 1735693200000,
      "pH": 7.25,
      "tds": 455,
      "turbidity": 11,
      "temperature": 28.8
    }
  }
}
```

| Field | Type | Description |
|-------|------|-------------|
| **Key** (timestamp) | String | Millisecond timestamp (same as `timestamp` field) |
| `timestamp` | Long | Millisecond timestamp (Unix epoch × 1000) |
| `pH` | Double | pH reading at that moment |
| `tds` | Double | TDS reading at that moment |
| `turbidity` | Double | Turbidity reading at that moment |
| `temperature` | Double | Temperature reading at that moment |

#### How to Create History Records

**Option 1: ESP32 (Recommended)**
```cpp
// Pseudo-code for ESP32
void saveHistory() {
  unsigned long now = millis() / 1000; // Convert to seconds
  String key = String(now * 1000); // Convert to milliseconds for key
  
  FirebaseJson json;
  json.set("timestamp", now * 1000);
  json.set("pH", phSensor.read());
  json.set("tds", tdsSensor.read());
  json.set("turbidity", turbiditySensor.read());
  json.set("temperature", tempSensor.read());
  
  Firebase.RTDB.set(&fbdo, "/sensorHistory/" + key, &json);
}

// Call saveHistory() every interval (e.g., every hour)
```

**Option 2: Cloud Function (Firebase)**
Deploy a function that saves readings from `/sensor_data` to `/sensorHistory` on a schedule:

```javascript
// Firebase Cloud Function (Node.js)
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.saveSensorHistory = functions.pubsub
  .schedule("0 * * * *") // Every hour
  .onRun(async (context) => {
    const db = admin.database();
    const snapshot = await db.ref("/sensor_data").get();
    
    if (snapshot.exists()) {
      const now = Date.now();
      await db.ref(`/sensorHistory/${now}`).set({
        timestamp: now,
        ...snapshot.val()
      });
    }
  });
```

**Data Flow**: The Flutter app only *reads* history; the ESP32/Cloud Function creates it.

---

## 📁 App Structure

```
lib/
├── main.dart                    # App initialization & splash screen
├── dashboard.dart               # Main dashboard, connectivity & reports screens
├── firebase_service.dart        # Firebase data service & models
├── firebase_options.dart        # Firebase configuration (auto-generated)
└── sensor_card.dart            # Reusable sensor display card component

Key Classes:
├── AquaSenseApp                 # Material app theme & navigation
├── SplashScreen                 # Animated intro splash with waves
├── AppHomeScreen                # Bottom nav container
├── DashboardScreen              # Live sensor grid + WQI
├── DeviceConnectivityScreen     # WiFi/sensor/battery status
├── ReportsScreen                # Charts & historical data
├── FirebaseService              # Firebase initialization & streams
├── WaterReading                 # Live sensor data model
├── CircuitStatus                # Device connectivity model
└── HistoryReading               # Historical data model
```

### Key Components

**DashboardScreen**
- Grid of 4 sensor cards (pH, TDS, Turbidity, Temperature)
- Water Quality Index with status indicator
- Device status bar (Online/Offline, Battery %)
- Tappable cards to navigate to detailed reports

**DeviceConnectivityScreen**
- Sensor connection status
- WiFi connectivity status
- Battery usage visualization (pie chart)
- Last seen timestamp

**ReportsScreen**
- Multi-metric chart display
- Toggle between Daily/Monthly views
- Date/month selection
- Interactive line charts with legends

---

## 🎯 Features Guide

### Dashboard
The home screen displays **live data** from your sensors:

1. **Sensor Cards** (Grid)
   - Shows current readings for pH, TDS, Turbidity, Temperature
   - Tap any card to see daily/monthly trends in Reports

2. **Water Quality Index (WQI)**
   - Composite score: (pH_score + TDS_score + Turbidity_score + Temp_score) / 4
   - Color-coded: Green (≥70 = Good), Orange (<70 = Needs Attention)
   - Tap to see WQI trends

3. **Device Status**
   - "Device Online/Offline"
   - Battery percentage remaining

### Device Connectivity
Monitor your sensor device health:

1. **Sensor Status**: Is the probe connected and reporting?
2. **WiFi Connectivity**: Is the device connected to the internet?
3. **Battery Pack**: Real-time battery percentage with usage breakdown
4. **Last Seen**: When the device last sent data (if within 2 minutes = Fresh)

### Reports & Analytics

Navigate from Dashboard by tapping any metric or use the **Reports** tab:

**Daily View** (Default)
- Hourly granularity: 6am → 6pm
- Select specific date with date picker
- All 5 metrics available

**Monthly View**
- Daily granularity across full month
- Select month from dropdown
- Compare patterns across dates

**Features**
- Smooth line charts with gradient fill
- Interactive data point circles
- Legend with metric colors
- Adjustable Y-axis scale per metric

---

## 🔐 Security Considerations

### Before Production

1. **Enable Authentication**
   - Use Firebase Email/Password or Google Sign-In
   - Update `FirebaseService.initialize()` if needed

2. **Implement Security Rules**
   ```json
   {
     "rules": {
       "sensor_data": {
         ".read": "auth != null",
         ".write": "auth.uid == 'ADMIN_UID'"
       },
       "sensorHistory": {
         ".read": "auth != null",
         ".write": "auth.uid == 'ADMIN_UID'"
       }
    }
   }
   ```

3. **Enable HTTPS Only**
   - Firebase enforces HTTPS for all connections

4. **Monitor Database Access**
   - Enable Firebase Logs in Console
   - Set up alerts for suspicious activity

---

## 🐛 Troubleshooting

### "Firebase is not configured"
- Run `flutterfire configure` and select Android/iOS platforms
- Ensure `firebase_options.dart` is generated and imported in `main.dart`

### No data appearing on Dashboard
- Check Firebase Realtime Database has data at `/sensor_data`
- Verify key names match (case-sensitive): `pH`, `tds`, `turbidity`, `temperature`, `battery`, `online`
- Check Firebase Security Rules allow read access

### History not showing in Reports
- Ensure `/sensorHistory` exists with timestamped records
- Each record must have keys: `timestamp`, `pH`, `tds`, `turbidity`, `temperature`
- Timestamps must be in milliseconds

### Battery always shows 0%
- Check Firebase data has `Battery` (capital B) or `battery` field in `/sensor_data`

### Device shows "Not detected" in Connectivity
- Verify `/calibration_data/last_seen` is being updated regularly
- The app considers data "fresh" if last_seen is within 2 minutes of now

---

## 📝 License

This project is open-source. Refer to the LICENSE file for details.

---

## 👤 Author

**Binupa Ariyarathna**
**Vinuji Perera**
**Lithasha Abayarathna**

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📚 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Realtime Database Docs](https://firebase.google.com/docs/database)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Material Design 3](https://m3.material.io/)

---

**Last Updated**: December 2024
**Status**: ✅ Production Ready (with proper Firebase setup & security rules)
