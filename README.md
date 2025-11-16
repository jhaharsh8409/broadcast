# Broadcast - News Streaming App

A modern Flutter mobile app for streaming news channels with beautiful animations and glassmorphism UI.

## Features

- ✨ Animated welcome screen with auto-navigation
- 🎨 Modern glassmorphism channel cards
- 📺 YouTube live stream playback via WebView
- 🔄 Pull-to-refresh functionality
- 🌙 Dark theme UI

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development
- Node.js and npm for backend

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   npm start
   ```

   The server will run on `http://localhost:3000`

### Flutter App Setup

1. Navigate to the Flutter app directory:
   ```bash
   cd flutter_app
   ```

2. Generate platform-specific files (if not already present):
   ```bash
   flutter create .
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. For Android: Add internet permission in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <manifest ...>
     <uses-permission android:name="android.permission.INTERNET"/>
     ...
   </manifest>
   ```

5. Update API URL in `lib/services/api_service.dart`:
   - For Android Emulator: `http://10.0.2.2:3000` (default)
   - For iOS Simulator: `http://localhost:3000`
   - For Physical Device: Use your computer's IP address (e.g., `http://192.168.1.100:3000`)

6. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   └── channel.dart          # Channel data model
│   ├── services/
│   │   └── api_service.dart      # API service for fetching channels
│   ├── screens/
│   │   ├── welcome_screen.dart   # Welcome screen with animations
│   │   ├── home_screen.dart      # Channel listing screen
│   │   └── player_screen.dart    # YouTube player screen
│   └── widgets/
│       └── channel_card.dart     # Animated channel card widget
└── pubspec.yaml                  # Dependencies
```

## API Endpoints

### GET /api/channels
Returns all available news channels.

**Response:**
```json
[
  {
    "channel_name": "ABP News",
    "channel_logo": "https://...",
    "live_youtube_link": "https://youtube.com/live/..."
  }
]
```

### POST /api/channels/update
Updates the channels list.

**Request Body:**
```json
[
  {
    "channel_name": "Channel Name",
    "channel_logo": "https://...",
    "live_youtube_link": "https://youtube.com/live/..."
  }
]
```

## Dependencies

- `http` - HTTP requests
- `webview_flutter` - YouTube WebView player
- `flutter_animate` - Screen animations
- `cached_network_image` - Image caching

## Notes

- Make sure the backend server is running before launching the app
- For physical devices, ensure your device and computer are on the same network
- YouTube live streams require an active internet connection

