// lib/screens/otp_verification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/screens/customer/customer_home.dart';
import 'package:food_delivery/screens/delivery_partener/delivery_dashboard_screen.dart';
import 'package:food_delivery/screens/restaurant_owner/restaurant_dashboard_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String role;
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.role,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  int _timerSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer() {
    if (_timerSeconds > 0) {
      setState(() {
        _timerSeconds--;
      });
      Future.delayed(const Duration(seconds: 1), _updateTimer);
    } else {
      setState(() {
        _canResend = true;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Verification Code',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'We have sent a verification code to ${widget.phoneNumber}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildOtpField(index)),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String otp = _otpControllers.map((c) => c.text).join();
                  if (otp.length == 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Verification successful!')),
                    );
                    _navigateToHome();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter complete OTP'),
                      ),
                    );
                  }
                },
                child: const Text('Verify'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _canResend
                      ? "Didn't receive code? "
                      : "Resend code in ${_timerSeconds}s",
                ),
                if (_canResend)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _timerSeconds = 60;
                        _canResend = false;
                        _startTimer();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('OTP resent successfully!'),
                        ),
                      );
                    },
                    child: const Text('Resend'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  void _navigateToHome() {
    switch (widget.role) {
      case 'customer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
        break;
      case 'restaurant':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RestaurantDashboardScreen()),
        );
        break;
      case 'delivery':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DeliveryDashboardScreen()),
        );
        break;
    }
  }
}
