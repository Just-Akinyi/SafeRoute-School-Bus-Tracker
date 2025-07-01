![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-In_Development-orange)

# 🚌 SafeRoute – School Bus Tracker App

**SafeRoute** is a school bus tracking solution that gives real-time visibility into school transport operations. Designed for parents, drivers, and school administrators, SafeRoute enhances safety and communication by allowing users to track buses, receive notifications, and manage routes and trips.

---

## 📱 Features

### 👨‍👩‍👧 Parents
- Live GPS tracking of the school bus
- Pickup & drop-off notifications
- Driver and bus details
- SOS alerts from driver or school

### 🚐 Drivers
- Route navigation via Google Maps
- Student pick-up/drop-off actions
- Trip start/stop control
- Emergency SOS button

### 🏫 School Admin
- Dashboard to manage drivers, buses, and routes
- Real-time tracking of all buses
- Attendance logging and trip reports

---

## 🛠️ Tech Stack

- **Frontend**: Flutter (cross-platform)
- **Backend**: Firebase
  - Firestore (real-time database)
  - Firebase Auth (login system)
  - Firebase Cloud Messaging (push alerts)
- **Maps**: Google Maps API
- **Admin Panel**: Flutter Web or ReactJS (optional)
- **Plugins**:
  - `firebase_core`
  - `firebase_auth`
  - `cloud_firestore`
  - `firebase_messaging`
  - `google_maps_flutter`
  - `geolocator`
  - `flutter_background_geolocation`

---

## 🚀 Setup Instructions

### 1. Clone this Repository
```bash
git clone https://github.com/yourusername/saferoute-schoolbus.git
cd saferoute-schoolbus
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

### 3. Configure Firebase
- Set up a new Firebase project at https://console.firebase.google.com

- Download google-services.json (Android) and GoogleService-Info.plist (iOS)

- Add to appropriate directories (android/app/, ios/Runner/)

### 4. Set Up Maps
- Get a Google Maps API key

- Add to AndroidManifest.xml and AppDelegate.swift

### 5. Run the App
```bash
flutter run
```

## 📂 Folder Structure
```bash
lib/
├── main.dart
├── screens/
│   ├── login/
│   ├── parent/
│   ├── driver/
│   └── admin/
├── services/
│   ├── location_service.dart
│   ├── firestore_service.dart
│   └── notification_service.dart
└── widgets/

```
## 🔐 Environment Configuration
- Create a .env or use flutter_dotenv to manage:

- Firebase config

- Google Maps API key

- Admin credentials

## 📌 Coming Soon
- Geofencing alerts for school zones

- Offline trip logging and sync

- Student attendance reports

- Multi-language support

## 📄 License
MIT License © 2025 [Justin Akinyi / SafeRoute]

## 🤝 Contributions
> PRs, issues, and suggestions are welcome! Fork the repo and help make SafeRoute better.
