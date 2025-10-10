import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_desk_assistant_new/screens/app_scaffold.dart';
import 'package:smart_desk_assistant_new/services/nodemcu_service.dart';
import 'package:smart_desk_assistant_new/services/settings_service.dart';
import 'package:smart_desk_assistant_new/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  try {
    await NotificationService().init();
  } catch (e, stackTrace) {
    debugPrint('Error during notification init: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProxyProvider<SettingsProvider, NodeMCUProvider>(
          create: (context) => NodeMCUProvider(
            Provider.of<SettingsProvider>(context, listen: false),
          ),
          update: (context, settings, nodemcu) {
            nodemcu!.updateSettings(settings);
            return nodemcu;
          },
        ),
        // Optional: You can also provide NodeMCUProvider standalone if needed
        // ChangeNotifierProvider(create: (_) => NodeMCUProvider()),
      ],
      child: const SmartDeskApp(),
    ),
  );
}

class SmartDeskApp extends StatelessWidget {
  const SmartDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Desk Assistant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
          background: const Color(0xFF1a222f),
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AppScaffold(),
    );
  }
}
