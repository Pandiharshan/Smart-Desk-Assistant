import 'package:flutter/material.dart';

/// A card used to display the connection status (e.g., Connecting, Failed).
class ConnectionStatusCard extends StatelessWidget {
  final Widget icon;
  final String message;
  final Widget? child; // Optional: for a button or other widget

  const ConnectionStatusCard({
    super.key,
    required this.icon,
    required this.message,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Center(child: icon),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
          if (child != null) ...[
            const SizedBox(height: 24),
            child!,
          ],
        ],
      ),
    );
  }
}

/// A small chip displayed at the top of the dashboard showing the connection IP.
class ConnectionInfoChip extends StatelessWidget {
  final String ipAddress;

  const ConnectionInfoChip({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
          const SizedBox(width: 8),
          Text(
            "Connected: $ipAddress",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// A card displayed at the bottom of the dashboard showing the latest status message.
class NotificationMessageCard extends StatelessWidget {
  final String message;

  const NotificationMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
            ),
          ),
        ],
      ),
    );
  }
}
