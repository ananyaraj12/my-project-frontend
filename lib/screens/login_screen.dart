import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Welcome to Epic Nomads",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3C31))),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email", filled: true, fillColor: Color(0xFFF3E7E0)),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Password", filled: true, fillColor: Color(0xFFF3E7E0)),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    await auth.login(emailController.text, passwordController.text);
                    if (auth.isLoggedIn) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAB9A3)),
                  child: const Text("Login", style: TextStyle(color: Color(0xFF4A3C31))),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen())),
                  child: const Text("Forgot Password?",
                      style: TextStyle(color: Color(0xFF6B5B50))),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen())),
                  child: const Text("Don't have an account? Sign Up",
                      style: TextStyle(color: Color(0xFF6B5B50))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
