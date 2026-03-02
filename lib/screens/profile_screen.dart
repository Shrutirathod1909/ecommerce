import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String name;

  const ProfileScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3f3f3),

      /// 🔷 TOP SEARCH BAR
      appBar: AppBar(
        backgroundColor: const Color(0xff79c3c9),
        elevation: 0,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black54),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Search Amazon.in",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
              const Icon(Icons.camera_alt_outlined),
              const SizedBox(width: 10),
              const Icon(Icons.mic_none),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.qr_code_scanner),
          )
        ],
      ),

      body: ListView(
        children: [

          /// 👤 HELLO ROW
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(radius: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Hello, $name",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const Icon(Icons.settings),
                const SizedBox(width: 15),
                const Icon(Icons.notifications_none),
                const SizedBox(width: 10),
                const Text("EN"),
              ],
            ),
          ),

          /// 🔘 QUICK BUTTONS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _chip("Orders"),
                _chip("Buy Again"),
                _chip("Account"),
                _chip("Lists"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 📦 YOUR ORDERS
          _section(
            title: "Your Orders",
            subtitle: "Hi! You have no recent orders.",
            buttonText: "Return to the Homepage",
          ),

          /// 🔁 BUY AGAIN
          _section(
            title: "Buy Again",
            subtitle: "See what others are reordering on Buy Again",
            buttonText: "Visit Buy Again",
          ),

          /// 📋 YOUR LISTS
          _section(
            title: "Your Lists",
            subtitle: "You haven’t created any lists.",
            buttonText: "Create a List",
          ),

          /// 👤 YOUR ACCOUNT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Your Account",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("See all", style: TextStyle(color: Colors.teal)),
              ],
            ),
          ),

          /// ACCOUNT CARDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _accountBox("Your Orders"),
                _accountBox("Your Addresses"),
                _accountBox("Payments"),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 🛒 KEEP SHOPPING
          _section(
            title: "Keep shopping for",
            subtitle: "Viewed categories appear here.",
            buttonText: "",
          ),

          /// ❓ HELP
          _section(
            title: "Need more help?",
            subtitle: "",
            buttonText: "Visit customer service",
          ),

          const SizedBox(height: 30),
        ],
      ),

      /// 🔻 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "You"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu"),
        ],
      ),
    );
  }

  /// 🔘 Chip Button
  Widget _chip(String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(text),
      ),
    );
  }

  /// 📦 Section Widget
  Widget _section({
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          if (buttonText.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(buttonText),
            )
        ],
      ),
    );
  }

  /// 🧾 Account Box
  Widget _accountBox(String text) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Text(text),
    );
  }
}