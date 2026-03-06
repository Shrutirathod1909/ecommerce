import 'package:app/screens/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? loggedInUserId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    // Fetch userId from SharedPreferences or API
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userid") ?? 1; // default 1
    setState(() {
      loggedInUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loggedInUserId == null) {
      // Still loading userId
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopCart',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: MainNavigator(
        key: MainNavigator.navigatorKey, // GlobalKey stays the same
        userId: loggedInUserId!,          // Pass the current logged-in user
      ),
    );
  }
}