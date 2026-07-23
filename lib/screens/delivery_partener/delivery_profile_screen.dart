import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:provider/provider.dart';
import 'delivery_earnings_screen.dart';
import 'vehicle_details_screen.dart';
import 'documents_screen.dart';
import 'bank_details_screen.dart';

class DeliveryProfileScreen extends StatefulWidget {
  const DeliveryProfileScreen({super.key});

  @override
  State<DeliveryProfileScreen> createState() => _DeliveryProfileScreenState();
}

class _DeliveryProfileScreenState extends State<DeliveryProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<DeliveryProfileProvider>(context);
    final deliveryPartner = profileProvider.deliveryPartner;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Earnings'),
            Tab(text: 'Vehicle'),
            Tab(text: 'Documents'),
            Tab(text: 'Bank'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          DeliveryEarningsScreen(),
          VehicleDetailsScreen(),
          DocumentsScreen(),
          BankDetailsScreen(),
        ],
      ),
    );
  }
}
