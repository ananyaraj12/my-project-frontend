import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.checkLoginStatus();
  runApp(
    ChangeNotifierProvider.value(
      value: authService,
      child: const EpicNomadsApp(),
    ),
  );
}

class EpicNomadsApp extends StatelessWidget {
  const EpicNomadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final primaryBg = const Color(0xFFF9EFEA);
    final accent = const Color(0xFFDAB9A3);
    final textPrimary = const Color(0xFF4A3C31);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Epic Nomads',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          primary: accent,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF4A3C31)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: accent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: textPrimary),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3E7E0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color(0xFF6B5B50)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: textPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: auth.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
