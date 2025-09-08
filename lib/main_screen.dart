import 'package:enia/constants/app_colors.dart';
import 'package:enia/home_screen.dart';
import 'package:flutter/material.dart';

// شاشات إضافية لكل دور
import 'qa_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'doctor_dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  final String role; // "patient" أو "doctor"
  const MainScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // القوائم الخاصة بكل دور
    final patientScreens = [
      HomeScreen(),
      QAScreen(),
      ChatScreen(),
      ProfileScreen(),
    ];

    final doctorScreens = [
      HomeScreen(),
      DoctorDashboardScreen(),
      ChatScreen(),
      ProfileScreen(),
    ];

    final patientNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
      BottomNavigationBarItem(
        icon: Icon(Icons.question_answer),
        label: "الأسئلة",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "المحادثات"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
    ];

    final doctorNavItems = [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: "لوحة التحكم",
      ),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: "المحادثات"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
    ];

    // اختيار المجموعة حسب الدور
    final screens = widget.role == "doctor" ? doctorScreens : patientScreens;
    final navItems = widget.role == "doctor" ? doctorNavItems : patientNavItems;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.background,
        iconSize: screenWidth * 0.07,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.textLight,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.normal,
        ),
        items: navItems,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
