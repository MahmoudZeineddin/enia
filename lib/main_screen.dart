import 'package:enia/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    // HomeScreen(),
    // CrfMain(),
    // NotificationScreen(),
    // AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: AppColors.background,
        iconSize: screenWidth * 0.07,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textLight,
        unselectedItemColor: Colors.white38,
        selectedLabelStyle: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.normal,
        ),

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "البروفايل"),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: "الرسائل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "لوحة التحكم",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
        ],
      ),
    );
  }
}
