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
    ChangeNotifierProvider(
      create: (_) => authService,
      child: const EpicNomadsApp(),
    ),
  );
}

class EpicNomadsApp extends StatelessWidget {
  const EpicNomadsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Epic Nomads',
      home: auth.isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
