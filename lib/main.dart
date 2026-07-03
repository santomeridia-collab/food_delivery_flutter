import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/app_basic/controller/login_controller.dart';
import 'package:food_delivery/screens/app_basic/controller/register_controller.dart';
import 'package:food_delivery/screens/customer/providers/cart_provider.dart';
import 'package:food_delivery/screens/customer/providers/chat_provider.dart';
import 'package:food_delivery/screens/customer/providers/notification_provider.dart';
import 'package:food_delivery/screens/customer/providers/order_provider.dart';
import 'package:food_delivery/screens/customer/providers/restaurant_provider.dart';
import 'package:food_delivery/screens/customer/providers/tracking_provider.dart';
import 'package:food_delivery/screens/customer/providers/user_provider.dart';
import 'package:food_delivery/screens/customer/providers/wallet_provider.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/menu_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_settings_provider.dart';
import 'package:provider/provider.dart';
import 'screens/customer/providers/address_provider.dart';
import 'screens/customer/providers/search_provider.dart';
import 'screens/app_basic/splash_screen.dart';
import 'screens/customer/utils/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ///// app basic providers /////
            ChangeNotifierProvider(create: (_) => RegisterController()),
            ChangeNotifierProvider(create: (_) => LoginController()),

            //// customer providers////
            ChangeNotifierProvider(create: (_) => AddressProvider()),
            ChangeNotifierProvider(create: (_) => SearchProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => CustomerRestaurantProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
            ChangeNotifierProvider(create: (_) => TrackingProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => WalletProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),

            ////reataurant providers////
            ChangeNotifierProvider(create: (_) => RestaurantProvider()),
            ChangeNotifierProvider(create: (_) => MenuProvider()),
            ChangeNotifierProvider(create: (_) => RestaurantSettingsProvider()),

            //// delivery provider////
            ChangeNotifierProvider(create: (_) => DeliveryProvider()),
            ChangeNotifierProvider(create: (_) => DeliveryProfileProvider()),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'SMD Delivery',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
