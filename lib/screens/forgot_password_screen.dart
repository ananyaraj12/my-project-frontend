import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDAB9A3),
        title: const Text('Forgot Password', style: TextStyle(color: Color(0xFF4A3C31))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text("Enter your email to reset password",
                style: TextStyle(fontSize: 18, color: Color(0xFF4A3C31))),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Email", filled: true, fillColor: Color(0xFFF3E7E0)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await auth.forgotPassword(emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Password reset link sent successfully")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDAB9A3)),
              child: const Text("Send Link", style: TextStyle(color: Color(0xFF4A3C31))),
            ),
          ],
        ),
      ),
    );
  }
}
