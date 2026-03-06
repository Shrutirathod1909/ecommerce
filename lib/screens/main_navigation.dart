import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'catergories_screen.dart';
import 'cart_screen.dart';
import 'WelcomeScreen.dart';

class MainNavigator extends StatefulWidget {
  final int userId;

  const MainNavigator({super.key, required this.userId});

  static final GlobalKey<_MainNavigatorState> navigatorKey =
      GlobalKey<_MainNavigatorState>();

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// 🔥 Programmatically tab change
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const WelcomeProfileScreen(),
      CartScreen(),
      const CategoriesScreen(),
      
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _changeTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF131921),
        selectedItemColor: const Color(0xFFFF9900),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu",
          ),
        ],
      ),
    );
  }
}