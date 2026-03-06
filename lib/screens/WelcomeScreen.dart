import 'package:app/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';

class WelcomeProfileScreen extends StatefulWidget {
  const WelcomeProfileScreen({super.key});

  @override
  State<WelcomeProfileScreen> createState() => _WelcomeProfileScreenState();
}

class _WelcomeProfileScreenState extends State<WelcomeProfileScreen> {

  int? _userId;
  String _userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// LOAD USER
  Future<void> _loadUser() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userId = prefs.getInt("userid");
      _userName = prefs.getString("username") ?? "User";
    });
  }

  /// SAVE USER
  Future<void> _saveUserData(Map<String, dynamic> userData) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("userid", userData["userid"]);
    await prefs.setString("username", userData["username"]);

    _loadUser();
  }

  /// LOGOUT
  Future<void> _logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    setState(() {
      _userId = null;
      _userName = "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return _userId == null ? _welcomeScreen() : _profileScreen();
  }

  /// ================= WELCOME SCREEN =================
  Widget _welcomeScreen() {

    return Scaffold(

      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const SizedBox(height: 10),

            const Text(
              "नमस्ते",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search or ask a question",
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.camera_alt_outlined),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// REGISTER
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterScreen(
                      onSuccess: (userData) {
                        Navigator.pop(context, userData);
                      },
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  _saveUserData(result);
                }
              },
              child: const Text("Create account"),
            ),

            const SizedBox(height: 10),

            /// LOGIN
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {

                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(
                      onSuccess: (userData) {
                        Navigator.pop(context, userData);
                      },
                    ),
                  ),
                );

                if (result != null && result is Map<String, dynamic>) {
                  _saveUserData(result);
                }
              },
              child: const Text("Sign in"),
            ),

            const SizedBox(height: 30),

            _infoRow(Icons.currency_rupee, "Upto ₹100 cashback on your first order"),
            _infoRow(Icons.local_shipping, "Free Delivery on first order – for top categories"),
            _infoRow(Icons.assignment_return, "Easy Returns"),
            _infoRow(Icons.payment, "Pay on Delivery"),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        children: [

          Icon(icon, size: 30, color: Colors.orange),

          const SizedBox(width: 12),

          Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              )),
        ],
      ),
    );
  }

  /// ================= PROFILE SCREEN =================
  Widget _profileScreen() {

    return Scaffold(

      backgroundColor: const Color(0xfff3f3f3),

      appBar: AppBar(
        backgroundColor: const Color(0xffa7e0dc),

        elevation: 0,

        title: Container(
          height: 40,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),

          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search Amazon.in",
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.camera_alt_outlined),
            ),
          ),
        ),
      ),

      body: _youTab(),
    );
  }

  Widget _youTab() {

    return ListView(
      padding: const EdgeInsets.all(16),

      children: [

        Row(
          children: [

            const CircleAvatar(
                radius: 18,
                child: Icon(Icons.person)),

            const SizedBox(width: 10),

            Text(
              "Hello, $_userName",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),

            const Spacer(),

            IconButton(
                onPressed: _logout,
                icon: const Icon(Icons.logout)),

          ],
        ),

        const SizedBox(height: 15),

      Row(
  children: [
    _quickButton("Orders"),
    _quickButton("Buy Again"),
    _quickButton("Account"),
    
    _quickButton(
      "Lists",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WishlistScreen(),
          ),
        );
      },
    ),
  ],
),

        const SizedBox(height: 25),

        _section("Your Orders", "Return to the Homepage"),
        _section("Buy Again", "Visit Buy Again"),
        _section("Your Lists", "Create a List"),
        _section("Your Account", "Your Orders • Your Addresses • Amazon Pay"),
        _section("Keep shopping for", "Viewed categories appear here"),
        _section("Need more help?", "Visit customer service"),
      ],
    );
  }

  Widget _quickButton(String text, {VoidCallback? onTap}) {

  return Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.white,
        ),
        child: Center(child: Text(text)),
      ),
    ),
  );
}
  Widget _section(String title, String button) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            height: 45,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(button),
              ),
            ),
          )
        ],
      ),
    );
  }
}