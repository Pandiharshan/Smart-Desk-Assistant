import 'package:flutter/material.dart';

/// Manages user-configurable settings throughout the application.
///
/// It uses the `ChangeNotifier` pattern to notify listening widgets
/// when a setting value has been updated, allowing the UI to rebuild.
class SettingsProvider with ChangeNotifier {
  // --- Private backing fields for settings ---

  // Default low lux threshold, matching the NodeMCU's initial value.
  int _lowLuxThreshold = 50;

  // Default high lux threshold, matching the NodeMCU's initial value.
  int _highLuxThreshold = 200;

  // Default work session duration in minutes.
  int _workDuration = 25;

  // Default break session duration in minutes.
  int _breakDuration = 5;

  // Controls whether light level notifications are enabled.
  bool _notificationsEnabled = true;

  // --- Public getters to access the settings ---

  int get lowLuxThreshold => _lowLuxThreshold;
  int get highLuxThreshold => _highLuxThreshold;
  int get workDuration => _workDuration;
  int get breakDuration => _breakDuration;
  bool get notificationsEnabled => _notificationsEnabled;

  // --- Public methods to update the settings ---

  /// Updates the low lux threshold and notifies listeners.
  void setLowLuxThreshold(int value) {
    if (_lowLuxThreshold != value) {
      _lowLuxThreshold = value;
      print("SettingsProvider: Low Lux Threshold updated to $_lowLuxThreshold");
      notifyListeners(); // This triggers a rebuild in listening widgets.
    }
  }

  /// Updates the high lux threshold and notifies listeners.
  void setHighLuxThreshold(int value) {
    if (_highLuxThreshold != value) {
      _highLuxThreshold = value;
      print("SettingsProvider: High Lux Threshold updated to $_highLuxThreshold");
      notifyListeners();
    }
  }

  /// Updates the work session duration and notifies listeners.
  void setWorkDuration(int minutes) {
    if (_workDuration != minutes) {
      _workDuration = minutes;
      print("SettingsProvider: Work Duration updated to $_workDuration minutes");
      notifyListeners();
    }
  }

  /// Updates the break session duration and notifies listeners.
  void setBreakDuration(int minutes) {
    if (_breakDuration != minutes) {
      _breakDuration = minutes;
      print("SettingsProvider: Break Duration updated to $_breakDuration minutes");
      notifyListeners();
    }
  }

  /// Toggles notification preferences and notifies listeners.
  void setNotificationsEnabled(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      print("SettingsProvider: Notifications Enabled updated to $_notificationsEnabled");
      notifyListeners();
    }
  }
}
