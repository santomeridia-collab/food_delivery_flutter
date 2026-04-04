// lib/screens/app_intro_screen.dart
import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/app_basic/language_selection.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({super.key});

  @override
  State<AppIntroScreen> createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroData> _introData = [
    IntroData(
      title: 'Order Food Online',
      description:
          'Browse thousands of restaurants and order your favorite meals with just a few taps',
      icon: Icons.restaurant_menu,
      color: Color(0xFFFF6B35),
    ),
    IntroData(
      title: 'Fast Delivery',
      description:
          'Get your food delivered hot and fresh right to your doorstep',
      icon: Icons.delivery_dining,
      color: Color(0xFF4CAF50),
    ),
    IntroData(
      title: 'Easy Payments',
      description: 'Multiple payment options for your convenience and security',
      icon: Icons.payment,
      color: Color(0xFF2196F3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _introData.length,
                itemBuilder: (context, index) {
                  return _buildIntroPage(_introData[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _introData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_currentPage == _introData.length - 1)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSelectionScreen(),
                            ),
                          );
                        },
                        child: const Text('Get Started'),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const LanguageSelectionScreen(),
                                ),
                              );
                            },
                            child: const Text('Skip'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroPage(IntroData data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 100, color: data.color),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color:
            _currentPage == index
                ? AppTheme.primaryColor
                : Colors.grey.shade300,
      ),
    );
  }
}

class IntroData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  IntroData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
