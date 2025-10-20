import 'package:flutter/material.dart';
import 'package:online_shop/screens/splash_screen.dart';
import 'package:online_shop/styles/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      home: SplashScreen(),
    );
  }
}
