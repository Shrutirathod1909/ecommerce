import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // 👈 2nd screen

class ShopcartWelcomeScreen extends StatelessWidget {
  const ShopcartWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),

      /// TOP SEARCH BAR
      appBar: AppBar(
        backgroundColor: const Color(0xffe6b980),
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
                  "Search or ask a question",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
              Icon(Icons.camera_alt_outlined, color: Colors.grey[700]),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.qr_code_scanner),
          ),
        ],
      ),

      /// BODY
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// 👋 Greeting Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("नमस्ते", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("EN"),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// 🏷 Welcome Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Welcome to Shopcart",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// 🟡 Create Account Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffE7C36F),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterScreen(
                        onSuccess: () {
                          // ✅ Navigate to HomeScreen after register success
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Create account",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// ⚪ Sign In Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        onSuccess: () {
                          // ✅ Navigate to HomeScreen after login success
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>ProfileScreen(name: "name",)),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Sign in",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// 📋 Benefits List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                BenefitTile(
                  icon: Icons.currency_rupee,
                  text: "Upto ₹100 cashback on your first order",
                ),
                SizedBox(height: 20),
                BenefitTile(
                  icon: Icons.local_shipping_outlined,
                  text: "Free Delivery on first order – for top categories",
                ),
                SizedBox(height: 20),
                BenefitTile(
                  icon: Icons.inventory_2_outlined,
                  text: "Easy Returns",
                ),
                SizedBox(height: 20),
                BenefitTile(
                  icon: Icons.payment_outlined,
                  text: "Pay on Delivery",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BenefitTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const BenefitTile({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          child: Icon(icon, color: Colors.orange, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}