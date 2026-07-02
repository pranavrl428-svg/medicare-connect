import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.loginUser(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.patientDashboard,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed: $e"),
          backgroundColor: AppColors.error,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 70,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),

                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Login to continue",
                  style: TextStyle(
                    color: AppColors.textLight,
                  ),
                ),

                const SizedBox(height: 30),

                CustomTextField(
                  controller: _emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: "Login",
                        onPressed: _login,
                      ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.register,
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
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