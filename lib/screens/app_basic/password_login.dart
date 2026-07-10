// lib/screens/app_basic/password_login.dart
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/customer_home.dart';
import 'package:food_delivery/screens/delivery_partener/delivery_dashboard_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/restaurant_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery/screens/app_basic/controller/login_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class PasswordLoginScreen extends StatefulWidget {
  final String role;
  const PasswordLoginScreen({super.key, required this.role});

  @override
  State<PasswordLoginScreen> createState() => _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginController = Provider.of<LoginController>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Login with Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in as ${widget.role}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),

              /// Phone/Email
              TextFormField(
                controller: _identifierController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'Enter phone number or email',
                  labelText: 'Phone / Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number or email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              /// Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Enter password',
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),

              /// Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      loginController.isLoading
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await loginController.login(
                                identifier: _identifierController.text.trim(),
                                password: _passwordController.text.trim(),
                                role: widget.role,
                              );

                              if (success) {
                                // Show success message
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  behavior: SnackBarBehavior.floating,
                                  content: AwesomeSnackbarContent(
                                    title: 'Success',
                                    message: 'Login successful!',
                                    contentType: ContentType.success,
                                  ),
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);

                                // Navigate to appropriate dashboard using push
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (widget.role == 'customer') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const CustomerHomeScreen(),
                                      ),
                                    );
                                  } else if (widget.role == 'restaurant') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const RestaurantDashboardScreen(),
                                      ),
                                    );
                                  } else if (widget.role == 'delivery') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const DeliveryDashboardScreen(),
                                      ),
                                    );
                                  } else {
                                    // Fallback - show error or go to login options
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid role!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                });
                              } else {
                                // Show error
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  behavior: SnackBarBehavior.floating,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error',
                                    message:
                                        loginController.errorMessage ??
                                        'Login failed. Please try again.',
                                    contentType: ContentType.failure,
                                  ),
                                );
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(snackBar);
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange,
                  ),
                  child:
                      loginController.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
