import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int selectedIndex = 0;

  /// LEFT SIDE MENU
  final List<Map<String, String>> sideMenu = [
    {"title": "Top Picks", "image": "assets/image/star.webp"},
    {"title": "Mobiles & Electronics", "image": "assets/image/mobile.webp"},
    {"title": "Deals & Savings", "image": "assets/image/wbanner1.jpeg"},
    {"title": "Fashion & Beauty", "image": "assets/image/fashion.webp"},
    {"title": "Home & Furniture", "image": "assets/image/home.webp"},
    {"title": "Groceries & Pet Supplies", "image": "assets/categories/geroceries&pet.png"},
    {"title": "Books & Education", "image": "assets/image/books.webp"},
    {"title": "Pharmacy & Household", "image": "assets/categories/pharmacy.webp"},
    {"title": "Travel & Auto", "image": "assets/categories/travel&auto.png"},
    {"title": "Toys & Kides", "image": "assets/image/toys.webp"},
    {"title": "Sports & Fitness", "image": "assets/categories/sport&fitness.webp"},
    {"title": "Gifting", "image": "assets/categories/gift.webp"}, 
    {"title": "Your Things", "image": "assets/categories/yourthings.webp"},
    {"title": "Account & Help", "image": "assets/categories/account&help.png"},
  ];

  /// CATEGORY DATA (Dynamic Right Side)
  final Map<String, List<Map<String, String>>> categoryData = {
    "Top Picks": [
      {"title": "Mobiles", "image": "assets/image/mobile.webp"},
      {"title": "Fashion", "image": "assets/image/fashion.webp"},
      {"title": "Electronics", "image": "assets/image/electronic.webp"},
      {"title": "Travel", "image": "assets/categories/travel&auto.png"},
      {"title": "Deals & Savings", "image": "assets/image/wbanner1.jpeg"},
      {"title": "Furniture", "image": "assets/image/wbanner3.jpeg"},
      {"title": "Home", "image": "assets/image/home.webp"},
      {"title": "Bills & Recharges", "image": "assets/image/bills&recharges.png"},
      {"title": "Beauty", "image": "assets/image/beauty.webp"},
      {"title": "Appliances", "image": "assets/categories/Appliances.jpg"},
      {"title": "Everyday Needs", "image": "assets/image/daily_needs.webp"},
      {"title": "Kids & Toys", "image": "assets/image/toys.webp"},
    ],
    "Mobiles & Electronics": [
      {"title": "Smartphones", "image": "assets/categories/mobile/1.jpg"},
      {"title": "Electronics", "image": "assets/categories/mobile/2.jpg"},
      {"title": "Laptops", "image": "assets/categories/mobile/3.jpg"},
      {"title": "Home Application", "image": "assets/categories/mobile/4.jpg"},
      {"title": "Televisions", "image": "assets/categories/mobile/5.jpg"},
      {"title": "Echo,Kindle & More", "image": "assets/categories/mobile/6.jpg"},
      {"title": "Smart Home", "image": "assets/categories/mobile/7.jpg"},
      {"title": " Kitchen Application", "image": "assets/categories/mobile/8.jpg"},
      {"title": "Headphones", "image": "assets/categories/mobile/9.jpg"},
      {"title": "Smart Watches", "image": "assets/categories/mobile/10.jpg"},
      {"title": "Video Games", "image": "assets/categories/mobile/11.webp"},
      {"title": "Software", "image": "assets/categories/mobile/12.jpg"},
    ],
    "Deals & Savings": [
      {"title": "Today's Deals", "image": "assets/image/wbanner1.jpeg"},
      {"title": "Rewards", "image": "assets/categories/deals/2.webp"},
      {"title": "Buy More,Save More", "image": "assets/categories/deals/3.jpg"},

    ],
    "Fashion & Beauty": [
      {"title": "Men's Clothing", "image": "assets/categories/fashion/2.webp"},
      {"title": "Women's Clothing", "image": "assets/categories/fashion/1.jpg"},
      {"title": "Kids Fashion", "image": "assets/categories/fashion/3.webp"},
      {"title": "Beauty & Makeup", "image": "assets/categories/fashion/4.webp"},
      {"title": "Shoes & Footware", "image": "assets/categories/fashion/5.webp"},
      {"title": "Bags & Luggage", "image": "assets/categories/fashion/9.webp"},
      {"title": "Watches", "image": "assets/categories/fashion/6.webp"},
      {"title": "Jawellery", "image": "assets/categories/fashion/7.webp"},
      {"title": "Eyewear", "image": "assets/categories/fashion/8.webp"},
    ],
    "Home & Furniture": [
      {"title": "Home & Kitchen", "image": "assets/image/Banner4.webp"},
      {"title": "furniture", "image": "assets/image/home.webp"},
      {"title": "Cookware & Dining", "image": "assets/categories/home/1.jpg"},
      {"title": "Home Decor", "image": "assets/image/home.webp"},
      {"title": "Fire TV Streaming Devices", "image": "assets/categories/home/2.webp"},
      {"title": "Garden & Outdoor", "image": "assets/categories/home/2.jpg"},
     
    ],
    "Groceries & Pet Supplies": [
    {"title": "Everyday Needs", "image": "assets/image/daily_needs.webp"},
    {"title": "Groceries & Gourmet", "image": "assets/categories/home/3.webp"},
    {"title": "Fresh Meat", "image": "assets/categories/home/5.webp"},
    {"title": "Pet Supplies", "image": "assets/categories/home/pet_supplies.png"},
    {"title": "Fruits & Vegetables", "image": "assets/categories/home/4.webp"},
  ],
  "Books & Education": [
    {"title": "Books", "image": "assets/image/books.webp"},
    {"title": "eBooks", "image": "assets/categories/2.webp"},
    {"title": "Audible Audiobooks", "image": "assets/categories/home/audible.jpg"},
  ],
  "Pharmacy & Household": [
    {"title": "Health & Household", "image": "assets/categories/pharmacy/health_household.jpg"},
    {"title": "Pharmacy", "image": "assets/categories/pharmacy/pharmacy.avif"},
    {"title": "Health Care Devices", "image": "assets/categories/pharmacy/device.webp"}
  ],
  "Travel & Auto": [
    {"title": "Flight Tickets", "image": "assets/categories/travel/flight.webp"},
    {"title": "Hotel Bookings", "image": "assets/categories/travel/hotel.webp"},
    {"title": "Bus Tickets", "image": "assets/categories/travel/bus.webp"},
    {"title": "Train Tickets", "image": "assets/categories/travel/train.webp"},
    {"title": "Metro Recharge", "image": "assets/categories/travel/metro.jpg"},
    {"title": "FASTag Recharge", "image": "assets/categories/travel/fastag.webp"},
    {"title": "Bags & Luggage", "image": "assets/categories/fashion/9.webp"},
    {"title": "Cars & Bike Parts", "image": "assets/categories/travel/car&bike.webp"},
    {"title": "Auto Insurance", "image": "assets/categories/travel/auto_insurance.webp"}
  ],
  "Toys & Kides": [
    {"title": "Kids'Fashion", "image": "assets/categories/fashion/3.webp"},
    {"title": "Baby", "image": "assets/categories/kides/baby.webp"},
    {"title": "Toys & Games ", "image": "assets/categories/kides/toy&game.webp"},
  ],
  "Sports & Fitness": [
    {"title": "Fitness & Sports", "image":  "assets/categories/fitness/fitness.webp"},
    {"title": "Sports Clothing", "image":  "assets/categories/fitness/sports_clothing.webp"},
    {"title": "Sports Shoes", "image": "assets/categories/fitness/sports_shoes.webp"},
    {"title": "Health Drinks", "image": "assets/categories/fitness/health_drinks.webp"}
  ],
  "Gifting": [
    {"title": "Gift Cards", "image": "assets/categories/fitness/gift_card.webp"},
    {"title": "Gift Finder", "image": "assets/categories/fitness/giftfinder.jpg"},
    {"title": "Handicrafts", "image": "assets/categories/fitness/handicrafts.jpg"},
    {"title": "Small & Medium Businesses", "image": "assets/categories/fitness/support_small.webp"},
    {"title": "Echo, Kindle & More", "image": "assets/categories/mobile/6.jpg"},
  ],
  "Your Things": [
    {"title": "Your Order", "image": "assets/categories/your Things/your_Orders.png"},
    {"title": "Buy Again", "image": "assets/categories/your Things/buy_again.avif"},
    {"title": "Your Lists", "image": "assets/categories/your Things/list.webp"},
    {"title": "Your Account", "image": "assets/categories/your Things/account.webp"},
    {"title": "Your Transactions", "image": "assets/categories/your Things/transation.webp"},
  ],
  "Account & Help": [
    {"title": "Switch Accounts", "image": "assets/categories/your Things/switch.png"},
    {"title": "Sign Out", "image": "assets/categories/your Things/signout.webp"},
    {"title": "Customer Service", "image": "assets/categories/your Things/customer_service.webp"}
  ]
};

  @override
  Widget build(BuildContext context) {
    final selectedTitle = sideMenu[selectedIndex]["title"];
    final selectedCategories = categoryData[selectedTitle] ?? [];

    return Scaffold(
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

      body: Row(
        children: [

          /// LEFT SIDE MENU
          Container(
            width: 110,
            color: const Color(0xffF4F4F4),
            child: ListView.builder(
              itemCount: sideMenu.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 8),
                    decoration: BoxDecoration(
      
                      color: isSelected
                          ? Colors.white
                          : const Color(0xffF4F4F4),
                      border: isSelected
                          ? const Border(
                              left: BorderSide(
                                color: Color(0xffF08804),
                                width: 4,
                              ),
                            )
                          : null,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          sideMenu[index]["image"]!,
                          height: 28,
                          width: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sideMenu[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// RIGHT SIDE CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    selectedTitle ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: GridView.builder(
                      itemCount: selectedCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.60,
                      ),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xffFAFAFA),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  selectedCategories[index]["image"]!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              selectedCategories[index]["title"]!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}