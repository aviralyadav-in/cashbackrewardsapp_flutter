import 'package:flutter/material.dart';
import 'login_screen.dart';

/// SignupScreen now wraps LoginScreen to maintain a single combined Login/Signup authentication screen.
class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen();
  }
}
