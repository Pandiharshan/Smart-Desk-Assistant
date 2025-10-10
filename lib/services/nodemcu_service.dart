import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'settings_service.dart';

enum ConnectionStatus { disconnected, connecting, connected, failed }

class NodeMCUProvider with ChangeNotifier {
  final String baseUrl = 'http://10.85.232.187'; // NodeMCU IP
  SettingsProvider? _settingsProvider;
  
  ConnectionStatus _status = ConnectionStatus.disconnected;
  double _lux = 0;
  double _low = 50;
  double _high = 200;
  Timer? _timer;
  String _errorMessage = '';
  
  // Constructor that optionally takes a SettingsProvider
  NodeMCUProvider([SettingsProvider? settings]) : _settingsProvider = settings {
    // Initialize with settings if provided
    if (_settingsProvider != null) {
      _updateFromSettings();
    }
  }
  
  // Update settings when they change in SettingsProvider
  void updateSettings(SettingsProvider settings) {
    _settingsProvider = settings;
    _updateFromSettings();
    notifyListeners();
  }
  
  // Helper method to update NodeMCUProvider from SettingsProvider
  void _updateFromSettings() {
    if (_settingsProvider != null) {
      // Update any settings from the SettingsProvider here
      // Example: _low = _settingsProvider!.lowThreshold;
      // Example: _high = _settingsProvider!.highThreshold;
    }
  }

  // Getters
  ConnectionStatus get status => _status;
  double get lux => _lux;
  double get low => _low;
  double get high => _high;
  String get errorMessage => _errorMessage;
  bool get isAlertActive => _lux < _low || _lux > _high;
  bool get isNormalLight => !isAlertActive;
  bool get isConnected => _status == ConnectionStatus.connected;

  // Connect to NodeMCU
  Future<void> connect() async {
    if (_status == ConnectionStatus.connected) return;
    
    _status = ConnectionStatus.connecting;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('$baseUrl/status'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _updateFromResponse(response.body);
        _status = ConnectionStatus.connected;
        _startPolling();
      } else {
        _status = ConnectionStatus.failed;
        _errorMessage = 'Failed to connect: ${response.statusCode}';
      }
    } catch (e) {
      _status = ConnectionStatus.failed;
      _errorMessage = 'Connection error: ${e.toString()}';
    }
    notifyListeners();
  }

  // Parse response from NodeMCU
  void _updateFromResponse(String responseBody) {
    try {
      final data = json.decode(responseBody);
      _lux = (data['lux'] ?? 0).toDouble();
      _low = (data['low'] ?? _low).toDouble();
      _high = (data['high'] ?? _high).toDouble();
    } catch (e) {
      _errorMessage = 'Failed to parse response: ${e.toString()}';
    }
  }

  // Periodically poll NodeMCU for live lux + thresholds
  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (_status != ConnectionStatus.connected) return;
      
      try {
        final response = await http
            .get(Uri.parse('$baseUrl/status'))
            .timeout(const Duration(seconds: 3));
            
        if (response.statusCode == 200) {
          _updateFromResponse(response.body);
          notifyListeners();
        } else if (response.statusCode >= 400) {
          _status = ConnectionStatus.failed;
          _errorMessage = 'Device error: ${response.statusCode}';
          notifyListeners();
        }
      } catch (e) {
        _status = ConnectionStatus.failed;
        _errorMessage = 'Polling error: ${e.toString()}';
        notifyListeners();
      }
    });
  }

  // Update light thresholds dynamically
  Future<void> updateThresholds(double low, double high) async {
    if (low >= high) {
      throw Exception('Low threshold must be less than high threshold');
    }

    try {
      final uri = Uri.parse('$baseUrl/update_thresholds?low=$low&high=$high');
      final response = await http.get(uri).timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        _low = low;
        _high = high;
        _errorMessage = '';
        notifyListeners();
      } else {
        throw Exception('Failed to update thresholds: ${response.statusCode}');
      }
    } catch (e) {
      _errorMessage = 'Update error: ${e.toString()}';
      notifyListeners();
      rethrow;
    }
  }

  // Disconnect safely
  void disconnect() {
    _timer?.cancel();
    _status = ConnectionStatus.disconnected;
    _errorMessage = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
