import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                const Text("Create Your Account",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3C31))),
                const SizedBox(height: 40),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      hintText: "Full Name", filled: true, fillColor: Color(0xFFF3E7E0)),
                ),
                const SizedBox(height: 20),
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
                    await auth.signup(nameController.text, emailController.text,
                        passwordController.text);
                    if (auth.isLoggedIn) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAB9A3)),
                  child: const Text("Sign Up", style: TextStyle(color: Color(0xFF4A3C31))),
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginScreen())),
                  child: const Text("Already have an account? Login",
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
