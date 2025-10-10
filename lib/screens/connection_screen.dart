import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_desk_assistant_new/services/nodemcu_service.dart';
import 'package:smart_desk_assistant_new/widgets/status_widgets.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  void initState() {
    super.initState();
    // Auto-connect when screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final node = context.read<NodeMCUProvider>();
      if (node.status != ConnectionStatus.connected) {
        node.connect();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Light Monitor'),
        actions: [
          Consumer<NodeMCUProvider>(
            builder: (context, node, _) {
              return IconButton(
                icon: _buildConnectionStatusIcon(node.status),
                onPressed: () {
                  if (node.status != ConnectionStatus.connected) {
                    node.connect();
                  }
                },
                tooltip: _getConnectionStatusTooltip(node.status),
              );
            },
          ),
        ],
      ),
      body: Consumer<NodeMCUProvider>(
        builder: (context, node, _) {
          if (node.status == ConnectionStatus.connecting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (node.status == ConnectionStatus.failed) {
            return _buildErrorState(node);
          }

          if (!node.isConnected) {
            return _buildDisconnectedState(node);
          }

          return _buildConnectedState(node);
        },
      ),
    );
  }

  Widget _buildConnectedState(NodeMCUProvider node) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lux value display
          _buildLuxDisplay(node.lux),
          const SizedBox(height: 32),
          
          // Status indicators
          _buildStatusIndicators(node),
          const SizedBox(height: 32),
          
          // Threshold display
          _buildThresholdDisplay(node),
          
          // Error message if any
          if (node.errorMessage.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildErrorMessage(node.errorMessage),
          ],
        ],
      ),
    );
  }

  Widget _buildLuxDisplay(double lux) {
    return Column(
      children: [
        const Text(
          'Current Light Level',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          '${lux.toStringAsFixed(1)} lux',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(NodeMCUProvider node) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!), 
      ),
      child: Column(
        children: [
          const Text(
            'Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatusIndicator(
                icon: Icons.lightbulb_outline,
                label: 'Light',
                color: node.isAlertActive ? Colors.red : Colors.green,
                isActive: node.isAlertActive,
              ),
              _buildStatusIndicator(
                icon: Icons.volume_up,
                label: 'Buzzer',
                color: node.isAlertActive ? Colors.orange : Colors.grey,
                isActive: node.isAlertActive,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
  }) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black87 : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildThresholdDisplay(NodeMCUProvider node) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Text(
            'Light Thresholds',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildThresholdChip('Low', node.low, Colors.blue),
              _buildThresholdChip('High', node.high, Colors.orange),
            ],
          ),
          if (node.isAlertActive) ...[
            const SizedBox(height: 12),
            Text(
              node.lux < node.low 
                  ? '⚠️ Light level is too low!' 
                  : '⚠️ Light level is too high!',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThresholdChip(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
          Text(
            '${value.toInt()} lux',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisconnectedState(NodeMCUProvider node) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Not Connected',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Connect to your NodeMCU device to monitor light levels',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: node.connect,
            icon: const Icon(Icons.wifi_find),
            label: const Text('Connect to Device'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(NodeMCUProvider node) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Connection Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              node.errorMessage.isNotEmpty 
                  ? node.errorMessage 
                  : 'Failed to connect to the device',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: node.connect,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {
                    // Show settings or help
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return const Icon(Icons.wifi, color: Colors.green);
      case ConnectionStatus.connecting:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case ConnectionStatus.failed:
        return const Icon(Icons.wifi_off, color: Colors.red);
      case ConnectionStatus.disconnected:
        return const Icon(Icons.wifi_off, color: Colors.grey);
    }
  }

  String _getConnectionStatusTooltip(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'Connected to NodeMCU';
      case ConnectionStatus.connecting:
        return 'Connecting...';
      case ConnectionStatus.failed:
        return 'Connection failed. Tap to retry.';
      case ConnectionStatus.disconnected:
        return 'Disconnected. Tap to connect.';
    }
  }
}
