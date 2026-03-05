import 'package:app/screens/WelcomeScreen.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'catergories_screen.dart';


class MainNavigator extends StatefulWidget {
    final int userId;

  const MainNavigator({super.key, required this.userId});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  void _changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  // Function to navigate to any tab programmatically
  void navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass function to OffersScreen so its "Shop Now" can go to Home
    final List<Widget> _screens = [
      const HomeScreen(),
      const ShopcartWelcomeScreen(),
     CartScreen(userId: widget.userId),
      const CategoriesScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "menu"),
        ],
      ),
    );
  }
}