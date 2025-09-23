import 'package:enia/constants/app_colors.dart';
import 'package:enia/home_screen.dart';
import 'package:flutter/material.dart';

// شاشات إضافية لكل دور
import 'qa_screen.dart';
import 'messages_screen.dart';
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
  List<Widget> _screens = [];
  List<BottomNavigationBarItem> _navItems = [];

  @override
  void initState() {
    super.initState();
    _initializeScreens();
  }

  void _initializeScreens() {
    try {
      // القوائم الخاصة بكل دور
      final patientScreens = [
        HomeScreen(),
        QAScreen(),
        MessagesScreen(),
        ProfileScreen(),
      ];

      final doctorScreens = [
        HomeScreen(),
        DoctorDashboardScreen(),
        MessagesScreen(),
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

      setState(() {
        _screens = widget.role == "doctor" ? doctorScreens : patientScreens;
        _navItems = widget.role == "doctor" ? doctorNavItems : patientNavItems;
      });
    } catch (e) {
      print('Error initializing screens: $e');
      // يمكن إضافة معالجة إضافية للأخطاء هنا
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_screens.isEmpty || _navItems.isEmpty) {
      return Scaffold(body: Center(child: Text('جاري تحميل التطبيق...')));
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
        items: _navItems,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
