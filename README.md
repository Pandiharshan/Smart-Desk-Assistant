# Smart Desk Assistant

A Flutter mobile application that monitors desk lighting conditions through a NodeMCU ESP8266 device and helps manage work/break cycles for improved productivity.

## Overview

Smart Desk Assistant connects to a NodeMCU device to monitor ambient light levels at your desk and provides alerts when lighting conditions are suboptimal. It also includes a Pomodoro-style timer for managing work and break sessions.

## Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **HTTP Client**: http package
- **Notifications**: flutter_local_notifications
- **Hardware**: NodeMCU ESP8266
- **Communication**: HTTP REST API

## Features

### Light Monitoring
- Real-time light level monitoring (lux values)
- Configurable low and high light thresholds
- Visual and audio alerts when light levels are outside optimal range
- Connection status indicators

### Work/Break Timer
- Customizable work session duration (5-90 minutes)
- Customizable break duration (1-30 minutes)
- Play/pause/reset timer controls
- Automatic mode switching between work and break sessions
- Visual timer display with progress indication

### Settings & Configuration
- Adjustable light level thresholds (0-2000 lux)
- Timer duration preferences
- Notification toggle
- Real-time settings synchronization

### User Interface
- Dark theme with cyan accent colors
- Bottom navigation with three main screens:
  - Monitor: Light level dashboard
  - Timer: Work/break session management
  - Settings: App configuration
- Connection status indicators
- Error handling and retry mechanisms

## Project Structure

```
lib/
├── main.dart                    # App entry point and provider setup
├── screens/
│   ├── app_scaffold.dart       # Main navigation scaffold
│   ├── connection_screen.dart  # Light monitoring dashboard
│   ├── timer_screen.dart       # Work/break timer interface
│   └── settings_screen.dart    # Configuration screen
├── services/
│   ├── nodemcu_service.dart    # NodeMCU communication service
│   ├── settings_service.dart   # Settings management
│   └── notification_service.dart # Local notifications
└── widgets/
    └── status_widgets.dart     # Reusable UI components
```

## Setup & Installation

### Prerequisites
- Flutter SDK (3.2.3 or higher)
- Android Studio or VS Code with Flutter extensions
- NodeMCU ESP8266 device
- Light sensor (for hardware setup)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smart_desk_assistant_new
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure NodeMCU IP address**
   - Update the `baseUrl` in `lib/services/nodemcu_service.dart`
   - Current default: `http://10.85.232.187`

4. **Run the application**
   ```bash
   flutter run
   ```

## Hardware Setup

The app expects a NodeMCU device with the following REST API endpoints:

- `GET /status` - Returns current light level and thresholds
  ```json
  {
    "lux": 150.5,
    "low": 50,
    "high": 200
  }
  ```

- `GET /update_thresholds?low=X&high=Y` - Updates light thresholds

## How to Use

1. **Connect to NodeMCU**: Ensure your NodeMCU is on the same network and update the IP address in the code
2. **Monitor Light Levels**: Use the Monitor tab to view real-time light readings
3. **Set Thresholds**: Configure optimal light ranges in Settings
4. **Use Timer**: Start work/break sessions in the Timer tab
5. **Receive Alerts**: Get notifications when light levels need adjustment

## Current Limitations

- Hardcoded NodeMCU IP address (requires manual configuration)
- No persistent settings storage (settings reset on app restart)
- Limited to HTTP communication (no HTTPS support)
- No user authentication or multi-device support
- NodeMCU firmware not included in repository
- No offline mode functionality

## Dependencies

```yaml
dependencies:
  flutter: sdk
  provider: ^6.1.2          # State management
  http: ^1.2.1              # HTTP requests
  flutter_local_notifications: ^17.1.2  # Local notifications
  cupertino_icons: ^1.0.2   # iOS-style icons
```

## Future Improvements

- Persistent settings storage using SharedPreferences
- Dynamic NodeMCU device discovery
- Historical data tracking and analytics
- Multiple device support
- HTTPS communication
- NodeMCU firmware code inclusion
- Offline mode with cached data
- Export/import settings functionality

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is available under the MIT License.