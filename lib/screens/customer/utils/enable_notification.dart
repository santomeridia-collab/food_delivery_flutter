// lib/screens/enable_notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/customer_home.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:permission_handler/permission_handler.dart';

class EnableNotificationsScreen extends StatefulWidget {
  const EnableNotificationsScreen({super.key});

  @override
  State<EnableNotificationsScreen> createState() =>
      _EnableNotificationsScreenState();
}

class _EnableNotificationsScreenState extends State<EnableNotificationsScreen> {
  bool _isLoading = false;

  Future<void> _requestNotificationPermission() async {
    setState(() {
      _isLoading = true;
    });

    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      _navigateToHome();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can enable notifications later from settings'),
        ),
      );
      _navigateToHome();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Enable Notifications',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Get real-time updates on your orders, exclusive offers, and delivery status',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _requestNotificationPermission,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Allow Notifications'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _navigateToHome,
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
