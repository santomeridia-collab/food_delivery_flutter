// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/screens/app_basic/login_screen.dart';
import 'package:food_delivery/utils/log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery/screens/app_basic/app_intro.dart';
import 'package:food_delivery/screens/customer/customer_home.dart';
import 'package:food_delivery/screens/delivery_partener/delivery_dashboard_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/restaurant_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for splash screen animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      final prefs = SharedPreferencesAsync();
      final accessToken = await prefs.getString('accessToken');
      final refreshToken = await prefs.getString('refreshToken');
      final role = await prefs.getString('role') ?? '';

      // Check if tokens exist
      if (accessToken != null &&
          refreshToken != null &&
          accessToken.isNotEmpty &&
          refreshToken.isNotEmpty) {
        // TODO: validate access token from API

        // Token exists - navigate to appropriate dashboard based on role
        _navigateToDashboard(role);
      } else {
        // No token - navigate to intro screen
        _navigateToIntro();
      }
    } catch (e) {
      logger.error("Error checking login status: $e");
      // On error, navigate to intro screen
      _navigateToIntro();
    }
  }

  void _navigateToDashboard(String role) {
    if (!mounted) return;

    Widget destinationScreen;
    switch (role.toLowerCase()) {
      case 'customer':
        destinationScreen = const CustomerHomeScreen();
        break;
      case 'restaurant':
        destinationScreen = const RestaurantDashboardScreen();
        break;
      case 'delivery':
        destinationScreen = const DeliveryDashboardScreen();
        break;
      default:
        // If role is invalid, go to login options
        destinationScreen = const LoginOptionsScreen(role: 'customer');
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destinationScreen),
    );
  }

  void _navigateToIntro() {
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AppIntroScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF6B35), Color(0xFFFF8F65)],
            ),
          ),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 60,
                        color: Color(0xFFFF6B35),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'FoodieDash',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Delivering Happiness',
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 30),
                    // Loading indicator
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
