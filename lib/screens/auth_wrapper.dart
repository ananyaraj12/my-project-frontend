import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();

    if (auth.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9EFEA),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF4A3C31)),
        ),
      );
    }

    if (auth.isLoggedIn) {
      return const HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
