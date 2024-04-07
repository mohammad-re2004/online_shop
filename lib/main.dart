import 'package:apple_shop/data/model/card_item.dart';
import 'package:apple_shop/di/di.dart';
import 'package:apple_shop/screens/dashbord_screen.dart';
import 'package:apple_shop/screens/login_screen.dart';
import 'package:apple_shop/util/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemAdapter());
  await Hive.openBox<BasketItem>('CardBox');
  await getItInit();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      debugShowCheckedModeBanner: false,
      home: (AuthManager.readAuth().isEmpty) ? LoginScreen() : DashbordScreen(),
    );
  }
}
