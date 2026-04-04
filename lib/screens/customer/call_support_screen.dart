import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/app_theme.dart';

class CallSupportScreen extends StatelessWidget {
  const CallSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Support'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Support Numbers
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Customer Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.h),
                _buildContactOption(
                  '📞 Customer Care',
                  '+1 234 567 8900',
                  '24/7 Support',
                  () => _makeCall('+12345678900'),
                ),
                const Divider(),
                _buildContactOption(
                  '🏢 Corporate Office',
                  '+1 234 567 8901',
                  'Mon-Fri, 9AM-6PM',
                  () => _makeCall('+12345678901'),
                ),
                const Divider(),
                _buildContactOption(
                  '🚚 Delivery Support',
                  '+1 234 567 8902',
                  'For delivery related issues',
                  () => _makeCall('+12345678902'),
                ),
              ],
            ),
          ),

          // Emergency Support
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.emergency, color: Colors.red, size: 30),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Emergency Support',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        'For urgent issues related to your order',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _makeCall('+12345678903'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Call Now'),
                ),
              ],
            ),
          ),

          // WhatsApp Support
          Container(
            margin: EdgeInsets.all(16.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_outlined, color: Colors.green, size: 30),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WhatsApp Support',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        'Chat with us on WhatsApp',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _openWhatsApp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('Chat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    String title,
    String number,
    String timing,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(timing, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
      trailing: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.call),
        label: const Text('Call'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  void _makeCall(String number) {
    // Implement phone call using url_launcher
  }

  void _openWhatsApp() {
    // Implement WhatsApp chat using url_launcher
  }
}
