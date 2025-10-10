import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_desk_assistant_new/services/settings_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to get access to the SettingsProvider and rebuild on change.
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Settings"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.background,
                  const Color(0xFF1c2a3f),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // --- Lux Threshold Settings ---
                _buildSectionHeader(context, "Light Level Thresholds"),
                _buildSliderTile(
                  context: context,
                  label: "Low Light Threshold",
                  value: settings.lowLuxThreshold.toDouble(),
                  min: 0,
                  max: 500,
                  divisions: 50,
                  unit: "lx",
                  onChanged: (value) =>
                      settings.setLowLuxThreshold(value.toInt()),
                ),
                _buildSliderTile(
                  context: context,
                  label: "High Light Threshold",
                  value: settings.highLuxThreshold.toDouble(),
                  min: 200,
                  max: 2000,
                  divisions: 36,
                  unit: "lx",
                  onChanged: (value) =>
                      settings.setHighLuxThreshold(value.toInt()),
                ),
                const Divider(height: 40),

                // --- Timer Settings ---
                _buildSectionHeader(context, "Work/Break Timer Durations"),
                _buildSliderTile(
                  context: context,
                  label: "Work Duration",
                  value: settings.workDuration.toDouble(),
                  min: 5,
                  max: 90,
                  divisions: 17,
                  unit: "min",
                  onChanged: (value) => settings.setWorkDuration(value.toInt()),
                ),
                _buildSliderTile(
                  context: context,
                  label: "Break Duration",
                  value: settings.breakDuration.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  unit: "min",
                  onChanged: (value) =>
                      settings.setBreakDuration(value.toInt()),
                ),
                const Divider(height: 40),

                // --- Notification Settings ---
                _buildSectionHeader(context, "Preferences"),
                _buildSwitchTile(
                  context: context,
                  label: "Enable Light Level Notifications",
                  value: settings.notificationsEnabled,
                  onChanged: (value) =>
                      settings.setNotificationsEnabled(value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Helper Widgets for Building UI ---

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSliderTile({
    required BuildContext context,
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 16)),
                Text(
                  "${value.toInt()} $unit",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.round().toString(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontSize: 16)),
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
