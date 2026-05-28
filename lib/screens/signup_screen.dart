import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  late AnimationController anim;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(fade);
    anim.forward();
  }

  @override
  void dispose() {
    anim.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> signupUser() async {
    final auth = context.read<AuthService>();
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();

    if (name.isEmpty || !email.contains("@") || pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all details correctly")),
      );
      return;
    }

    setState(() => loading = true);
    final err = await auth.signup(name, email, pass);
    setState(() => loading = false);

    if (!mounted) return;

    if (err == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EFEA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: SlideTransition(
            position: slide,
            child: FadeTransition(
              opacity: fade,
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDAB9A3),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(
                      Icons.explore_rounded,
                      size: 46,
                      color: Color(0xFF4A3C31),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3C31),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Start planning your journeys",
                    style: TextStyle(
                      color: Color(0xFF6B5B50),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1E0D3),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.18),
                          blurRadius: 12,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        field(
                          ctrl: nameCtrl,
                          hint: "Full name",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        field(
                          ctrl: emailCtrl,
                          hint: "Email",
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 16),
                        field(
                          ctrl: passCtrl,
                          hint: "Password",
                          icon: Icons.lock_outline,
                          secure: true,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDAB9A3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: loading ? null : signupUser,
                            child: loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF4A3C31),
                                    ),
                                  )
                                : const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xFF4A3C31),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Color(0xFF6B5B50)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Color(0xFF4A3C31),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget field({
    required TextEditingController ctrl,
    required String hint,
    required IconData icon,
    bool secure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3E7E0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: secure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF6B5B50)),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}
