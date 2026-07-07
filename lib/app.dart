import 'package:flutter/material.dart';
import 'package:helpdesk_mobile/core/theme/theme_controller.dart';
import 'package:helpdesk_mobile/features/auth/presentation/pages/splash_page.dart';

class HelpdeskApp extends StatelessWidget {
  const HelpdeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Helpdesk Mobile',

          themeMode: mode,

          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
            scaffoldBackgroundColor: const Color(0xFFF5F7FB),
            cardColor: Colors.white,
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Color(0xFF111827),
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
              bodyMedium: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              titleMedium: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
            ),
          ),

          home: const SplashPage(),
        );
      },
    );
  }
}
