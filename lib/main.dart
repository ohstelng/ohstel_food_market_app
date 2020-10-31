import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/landing_page.dart';

import 'hive_methods/hive_class.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init hive
  await InitHive().startHive(boxName: 'userDataBox');

  // init Firebase
  await Firebase.initializeApp();

  // run app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // provider is being used here at the top most widget tree so we can notify
    // every other sub widget down the widget tree.
    return MaterialApp(
      title: "OHstel Food and Market Agent App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LandingPage(),
    );
  }
}
