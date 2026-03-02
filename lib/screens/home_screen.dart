import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _qrController;
  late Animation<double> _qrAnimation;

  int _currentPage = 0;
  Timer? _timer;

  final List<String> banners = [
    "assets/image/banner1.jpeg",
    "assets/image/banner2.jpeg",
    "assets/image/banner3.jpeg",
    "assets/image/banner4.jpeg",
    "assets/image/banner5.jpeg",
    "assets/image/banner6.jpeg",
    "assets/image/banner7.jpeg",
    "assets/image/banner8.jpeg",
    "assets/image/banner9.jpeg",
    "assets/image/banner10.jpeg",
    "assets/image/banner11.jpeg",
  ];

  final List<List<Color>> bgGradients = [
    [Colors.black, Colors.white],
    [ Color.fromARGB(255, 98, 97, 97), Colors.white],
    [Color.fromARGB(255, 242, 226, 164), Colors.white],
    [Color.fromARGB(255, 74, 74, 73), Colors.white],
    [Color.fromARGB(255, 112, 112, 111), Colors.white],
    [Colors.blue, Colors.white],
    [Colors.black, Colors.white],
    [Colors.black, Colors.white],
    [Color(0xffE55D53), Colors.white],
    [Color.fromARGB(255, 197, 173, 126), Colors.white],
    [Colors.pink, Colors.white],
  ];
 List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.75);

    _qrController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _qrAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _qrController, curve: Curves.easeInOut));

    _startAutoSlide();
     fetchProducts(); 
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );

      setState(() {});
    });
  }
    Future<void> fetchProducts() async {
    try {
      var url = Uri.parse("http://10.0.2.2/ecommerce/get_products.php");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['products']);
            isLoadingProducts = false;
          });
        }
      }
    } catch (e) {
      setState(() => isLoadingProducts = false);
      print("Error fetching products: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _qrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: bgGradients[_currentPage],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              /// 🔥 FIXED SEARCH + LOCATION BAR
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                toolbarHeight: 80, // 🔥 important
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _searchBar(),
                ),
              ),

              /// 🔥 BODY CONTENT
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    _locationBar(),
                    const SizedBox(height: 15),
                    _bannerSlider(),
                    const SizedBox(height: 20),
                    _quickOptions(),
                    const SizedBox(height: 20),
                    _categoriesSection(),
                    const SizedBox(height: 30),
                    _homeKitchenSection(),
                    const SizedBox(height: 25),
                    _wholesaleSection(),
                    const SizedBox(height: 30),
                    _discoverSection(),
                    const SizedBox(height: 30),
                     _productListSection(), // 🔥 Products Section
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SEARCH BAR
  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 42, // 🔥 Reduced height (before 50)
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                  color: Colors.black54,
                  size: 20,
                ), // smaller icon
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Search ShopCart.in",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13, // 🔥 smaller text
                    ),
                  ),
                ),
                Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          child: ScaleTransition(
            scale: _qrAnimation,
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.black,
              size: 26, // slightly smaller
            ),
          ),
        ),
      ],
    );
  }

  /// LOCATION BAR
  Widget _locationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "Delivering to Mumbai 400001",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  /// BANNER SLIDER
  Widget _bannerSlider() {
    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(banners[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }

  /// QUICK OPTIONS (Amazon Style)
  Widget _quickOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _amazonIcon(Icons.local_shipping_outlined, "Free Delivery"),
          _amazonIcon(Icons.account_balance_wallet_outlined, "UPI"),
          _amazonIcon(Icons.card_giftcard_outlined, "Coupons"),
          _amazonIcon(Icons.currency_rupee, "Deals"),
        ],
      ),
    );
  }

  Widget _amazonIcon(IconData icon, String text) {
    return Column(
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// CATEGORIES SECTION
  Widget _categoriesSection() {
    final List<Map<String, String>> categories = [
      {"image": "assets/image/mobile.webp", "title": "Mobiles"},
      {"image": "assets/image/fashion.webp", "title": "Fashion"},
      {"image": "assets/image/electronic.webp", "title": "Electronics"},
      {"image": "assets/image/home.webp", "title": "Home"},
      {"image": "assets/image/beauty.webp", "title": "Beauty"},
      {"image": "assets/image/books.webp", "title": "books"},
      {"image": "assets/image/toys.webp", "title": "Toys"},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    categories[index]["image"]!,
                    height: 65,
                    width: 65,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  categories[index]["title"]!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _homeKitchenSection() {
    List<String> images = [
      "assets/image/Banner1.jpg",
      "assets/image/Banner2.webp",
      "assets/image/Banner3.webp",
      "assets/image/Banner4.webp",
      "assets/image/Banner5.jpg",
      "assets/image/Banner6.webp",
      "assets/image/Banner7.webp",
      "assets/image/Banner8.jpg",
      "assets/image/Banner9.webp",
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Up to 40% Off | Home & Kitchen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: images.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2), // 🔥 Light Grey Box
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(images[index], fit: BoxFit.contain),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _wholesaleSection() {
    List<Map<String, String>> items = [
      {"image": "assets/image/wbanner4.jpeg", "title": "Home decor"},
      {"image": "assets/image/wbanner3.jpeg", "title": "Bedsheets & pillows"},
      {"image": "assets/image/wbanner2.jpeg", "title": "Storage & container"},
      {"image": "assets/image/wbanner1.jpeg", "title": "Shop all deals"},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: Text(
                  "Wholesale Price + Extra ₹100 Cashback",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "See all",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// 🔥 2 x 2 Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          items[index]["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      items[index]["title"]!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _discoverSection() {
    List<String> categories = [
      "All",
      "Automotive",
      "Baby Products",
      "Beauty",
      "Books",
      "Clothing",
      "Electronics",
      "Grocery",
      "Gym & Sports",
      "Home Decor & Kitchen",
      "Jewellery",
      "Luggage",
      "Luxury Beauty",
    ];

    List<String> priceFilters = [
      "Under ₹299",
      "₹300-499",
      "₹500-999",
      "₹1000+",
    ];

    // String selectedCategory = "All";
    String selectedPrice = "Under ₹299";

    return StatefulBuilder(
      builder: (context, setState) {
void openCategorySheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {

      List<String> selectedCategories = ["All"];

      return StatefulBuilder(
        builder: (context, setBottomState) {

          bool showCancel =
              !(selectedCategories.length == 1 &&
                selectedCategories.contains("All"));

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [

                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                /// 🔥 MULTI SELECT CATEGORY LIST
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: categories.map((cat) {

                        bool active =
                            selectedCategories.contains(cat);

                        return GestureDetector(
                          onTap: () {
                            setBottomState(() {

                              if (cat == "All") {
                                selectedCategories = ["All"];
                              } else {

                                selectedCategories.remove("All");

                                if (active) {
                                  selectedCategories.remove(cat);
                                } else {
                                  selectedCategories.add(cat);
                                }

                                if (selectedCategories.isEmpty) {
                                  selectedCategories = ["All"];
                                }
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 9),
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.orange
                                  : const Color(0xffF2F2F2),
                              borderRadius:
                                  BorderRadius.circular(30),
                              border: Border.all(
                                color: active
                                    ? Colors.orange
                                    : Colors.black12,
                              ),
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: active
                                    ? Colors.black
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                /// 🔥 STICKY BUTTONS
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      if (showCancel)
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {
                              setBottomState(() {
                                selectedCategories = ["All"];
                              });
                            },
                            child: const Text(
                              "Cancel Filter",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                      if (showCancel)
                        const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Show Products",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Discover products for you",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              /// 🔥 SCROLLABLE FILTER ROW
              SizedBox(
                height: 45,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    /// 🔽 CATEGORIES DROPDOWN BUTTON
                    GestureDetector(
                      onTap: openCategorySheet,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF2F2F2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Row(
                          children: const [
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.keyboard_arrow_down, size: 18),
                          ],
                        ),
                      ),
                    ),

                    /// 🔥 PRICE FILTERS
                    ...priceFilters.map((price) {
                      bool isSelected = selectedPrice == price;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPrice = price;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orange
                                : const Color(0xffF2F2F2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.black12,
                            ),
                          ),
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? Colors.black : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _productListSection() {
    if (isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }
    if (products.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "http://10.0.2.2/ecommerce/images/${p['image']}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(p['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text("₹${p['price']}",
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
              ],
            ),
          );
        },
      ),
    );
  }
}
