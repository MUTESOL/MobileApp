import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stacksave/constants/colors.dart';
import 'package:stacksave/screens/launch_a_screen.dart';
import 'package:stacksave/screens/launch_b_screen.dart';
import 'package:stacksave/services/wallet_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StackSave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        useMaterial3: true,
      ),
      home: const SplashNavigator(),
    );
  }
}

class SplashNavigator extends StatefulWidget {
  const SplashNavigator({super.key});

  @override
  State<SplashNavigator> createState() => _SplashNavigatorState();
}

class _SplashNavigatorState extends State<SplashNavigator> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simple delay, no WalletConnect init here
    // WalletConnect will be initialized when user clicks "Connect Wallet"
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LaunchBScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const LaunchAScreen();
  }
}
