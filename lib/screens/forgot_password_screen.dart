import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  Future<void> sendReset() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email")),
      );
      return;
    }

    final auth = context.read<AuthService>();
    setState(() => loading = true);
    final err = await auth.forgotPassword(email);
    setState(() => loading = false);

    if (!mounted) return;

    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reset link sent to your email")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4A3C31);
    const secondary = Color(0xFF6B5B50);

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFDAB9A3),
        title: const Text(
          "Password Recovery",
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: primary),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAB9A3),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 34,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Forgot your password?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "We’ll send a reset link to your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondary,
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email address",
                    prefixIcon: const Icon(Icons.mail_outline),
                    filled: true,
                    fillColor: const Color(0xFFF3E7E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDAB9A3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: loading ? null : sendReset,
                    child: loading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Send Reset Link",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
