import 'package:flutter/material.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> offers = [
      {
        "title": "50% Off on Electronics",
        "subtitle": "Limited Time Offer",
        "discount": "50%"
      },
      {
        "title": "Buy 1 Get 1 Free",
        "subtitle": "On Fashion Items",
        "discount": "BOGO"
      },
      {
        "title": "Flat 30% Off",
        "subtitle": "On Shoes",
        "discount": "30%"
      },
      {
        "title": "Special Discount",
        "subtitle": "On Beauty Products",
        "discount": "40%"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEAEDED),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Today's Deals"),
        backgroundColor: const Color(0xFF131921),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// 🔥 SALE BANNER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9900), Color(0xFFFF6A00)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Mega Sale\nUp to 70% OFF",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// ⏳ STATIC TIMER UI
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Deal ends in:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "01h 00m 00s",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// 🏷 OFFERS LIST
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {

                  final offer = offers[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔴 Discount Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            offer["discount"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          offer["title"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          offer["subtitle"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9900),
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Explore Deals"),
                                ),
                              );
                            },
                            child: const Text(
                              "Shop Now",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}