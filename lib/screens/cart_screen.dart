import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      /// 🔝 APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xff8fd3d3),
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Search Shopcart.in",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              Icon(Icons.camera_alt_outlined, color: Colors.black54),
              SizedBox(width: 6),
              Icon(Icons.mic_none, color: Colors.black54),
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

      /// 📦 BODY
      body: Column(
        children: [

          /// 🛒 EMPTY CART
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                      "assets/image/cart.jpeg",
                      height: 50,
                    ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Shopcart Cart is empty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Pick up where you left off",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 8),

          /// 🔵 PRIME BOX
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1f6feb),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "~₹1/day! That's the effective price of Prime Shopping Edition, when paid annually.",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),

                const SizedBox(height: 10),

                const Text(
                  "FREE, Fast deliveries; Prime offers; early access & so much more — all with Prime Shopping Edition.",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),

                const SizedBox(height: 15),

                /// 🟡 BUTTON (Rounded like Shopcart)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffffd814),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Join Prime Shopping Edition at ₹399/year",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 15),

          /// 💳 UPI SECTION
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
              Image.network(
                  "https://cdn-icons-png.flaticon.com/512/825/825454.png",
                  height: 55,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Link once, pay anywhere, earn everytime with ",
                      children: [
                        TextSpan(
                          text: "Shopcart Pay UPI ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: "Link now",
                          style: TextStyle(color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          const Spacer(),

          /// 🟡 CONTINUE BUTTON
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffffd814),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Continue shopping",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),

       );
  }
}