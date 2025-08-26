import 'package:enia/constants/app_colors.dart';
import 'package:enia/main_screen.dart';
import 'package:enia/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Cairo',
      ),

      home: SplashScreen(),
    );
  }
}
