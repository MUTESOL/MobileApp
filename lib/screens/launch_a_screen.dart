import 'package:flutter/material.dart';
import 'package:stacksave/constants/colors.dart';

class LaunchAScreen extends StatelessWidget {
  const LaunchAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Icon
            Image.asset(
              'design/logo-stacksave.png',
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 24),
            // App Name
            const Text(
              'StackSave',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
