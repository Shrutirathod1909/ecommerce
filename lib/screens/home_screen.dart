import 'dart:async';
import 'dart:convert';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/product_screen.dart';
import 'package:app/screens/qr_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<String> selectedCategories = ["All"];
  String selectedPrice = "Under ₹299";

  int _currentPage = 0;
  Timer? _timer;

  final List<String> banners = [
    "assets/image/sweets.png",
    "assets/image/thecha.png",
    "assets/image/masala.png",
    "assets/image/pickles.png",
   
  ];

final List<List<Color>> bgGradients = [
  [Color(0xFF8E2A2A), Color(0xFFFFF3F3)], // Sweets
  [Color(0xFF2F7A3E), Color(0xFFEAF7ED)], // Thecha
  [Color(0xFFB85C00), Color(0xFFFFF4E5)], // Masala
  [Color(0xFF3E6B3E), Color(0xFFEFF7EF)], // Pickles
];
  List<Map<String, dynamic>> products = [];
  bool isLoadingProducts = true;
  List categories = [];
  List subcategories = [];

  String baseUrl = "http://192.168.1.39/ecommerce";

  final double horizontalPadding = 15; // 🔥 uniform horizontal padding

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
    getCategories();
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
      var url = Uri.parse("$baseUrl/get_products.php");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == true) {
          setState(() {
            products = List<Map<String, dynamic>>.from(data['data']);
            isLoadingProducts = false;
          });
        } else {
          setState(() => isLoadingProducts = false);
        }
      } else {
        setState(() => isLoadingProducts = false);
      }
    } catch (e) {
      setState(() => isLoadingProducts = false);
    }
  }

  Future getCategories() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_categories.php"));
      final data = jsonDecode(response.body);
      if (data["status"] == true) {
        setState(() {
          categories = data["data"];
        });
      }
    } catch (e) {}
  }
final ImagePicker _picker = ImagePicker();

Future<void> openCamera() async {
  final XFile? photo = await _picker.pickImage(
    source: ImageSource.camera,
  );

  if (photo != null) {
    print("Image Path: ${photo.path}");
  }
}

  Future fetchSubcategories(String category) async {
    try {
      var response = await http.get(
        Uri.parse(
          "$baseUrl/get_subcategories.php?category=${Uri.encodeComponent(category)}",
        ),
      );
      var data = jsonDecode(response.body);
      if (data["status"] == true) {
        setState(() {
          subcategories = data["data"];
        });
      }
    } catch (e) {}
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
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                toolbarHeight: 80,
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _searchBar(),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    _locationBar(),
                    const SizedBox(height: 15),
                    _bannerSlider(),
                    const SizedBox(height: 15),
                    _quickOptions(),
                    const SizedBox(height: 15),
                    _categoriesSection(),
                    const SizedBox(height: 10),
                    _homeKitchenSection(),
                    // const SizedBox(height: 15),
                    _wholesaleSection(),
                    // const SizedBox(height: 15),
                    _discoverSection(),
                    // const SizedBox(height: 15),
                    _productListSection(),
                    // const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _searchBar() {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: 10,
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black54, size: 20),
                const SizedBox(width: 8),

                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase().trim();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Search ShopCart.in",
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),

              GestureDetector(
  onTap: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      ),
    );

    if (result != null) {
      print("Scanned Code: $result");
    }
  },
  child: const Icon(
    Icons.qr_code_scanner,
    color: Colors.black54,
    size: 20,
  ),
),

                const SizedBox(width: 8),

               GestureDetector(
  onTap: () {
    openCamera();
  },
  child: const Icon(
    Icons.camera_alt_outlined,
    color: Colors.black54,
    size: 20,
  ),
)
              ],
            ),
          ),
        ),
      ],
    ),
  );
}  Widget _locationBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 12,
      ),
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
              style: TextStyle(fontSize: 9,fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  Widget _bannerSlider() {
    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: _pageController,
        itemCount: banners.length,
        padEnds: true,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(banners[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }

  Widget _quickOptions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: _amazonIcon(Icons.local_shipping_outlined, "Free Delivery"),
          ),
          Expanded(
            child: _amazonIcon(Icons.account_balance_wallet_outlined, "UPI"),
          ),
          Expanded(child: _amazonIcon(Icons.card_giftcard_outlined, "Coupons")),
          Expanded(child: _amazonIcon(Icons.currency_rupee, "Deals")),
        ],
      ),
    );
  }

  Widget _amazonIcon(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.black, size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /// CATEGORIES SECTION
  Widget _categoriesSection() {
    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          var cat = categories[index];
          String categoryName = cat["category_name"];

          return GestureDetector(
            onTap: () async {
              await fetchSubcategories(categoryName);

              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  if (subcategories.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Text("No Subcategories")),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: subcategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: .85,
                        ),
                    itemBuilder: (context, index) {
                      var sub = subcategories[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductScreen(subcategory: sub["title"]),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[200],
                              ),
                              child: Image.network(
                                "$baseUrl/${sub["image"]}",
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              sub["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage("$baseUrl/${cat["image"]}"),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: images.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.contain,
                  ),
                ),
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
    List<String> discoverCategories = [
      "All",
      ...categories.map((c) => c["category_name"]).toList(),
    ];

    List<String> priceFilters = [
      "Under ₹299",
      "₹300-499",
      "₹500-999",
      "₹1000+",
    ];

    return StatefulBuilder(
      builder: (context, setState) {
        void openCategorySheet() {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) {
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// 🔥 MULTI SELECT CATEGORY LIST
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: discoverCategories.map((cat) {
                                bool active = selectedCategories.contains(cat);

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
                                      horizontal: 16,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? Colors.orange
                                          : const Color(0xffF2F2F2),
                                      borderRadius: BorderRadius.circular(30),
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
                              BoxShadow(color: Colors.black12, blurRadius: 5),
                            ],
                          ),
                          child: Row(
                            children: [
                              if (showCancel)
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selectedCategories = ["All"];
                                      });
                                    },
                                    child: const Text(
                                      "Cancel Filter",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                              if (showCancel) const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {}); // refresh products
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
    List filteredProducts = products.where((p) {
      String category = (p['category'] ?? "").toString().toLowerCase().trim();
      List selected = selectedCategories
          .map((e) => e.toLowerCase().trim())
          .toList();

      if (!selected.contains("all") && !selected.contains(category)) {
        return false;
      }

      double price = double.tryParse(p['price'].toString()) ?? 0;

      if (selectedPrice == "Under ₹299" && price > 299) return false;
      if (selectedPrice == "₹300-499" && (price < 300 || price > 499))
        return false;
      if (selectedPrice == "₹500-999" && (price < 500 || price > 999))
        return false;
      if (selectedPrice == "₹1000+" && price < 1000) return false;

      // 🔥 SEARCH FILTER
      if (searchQuery.isNotEmpty &&
          !(p['name'] ?? "").toString().toLowerCase().contains(searchQuery)) {
        return false;
      }

      return true;
    }).toList();
    if (isLoadingProducts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredProducts.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return Container(
  color: Colors.white, // 🔥 Section background white
  child: GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    itemCount: filteredProducts.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.75,
    ),
    itemBuilder: (context, index) {
      final p = filteredProducts[index];

      String imageUrl = "";
      if (p['image'] != null && p['image'] != "") {
        imageUrl =
            "http://192.168.1.39/ecommerce/productgallery/${p['image']}";
      }

      return InkWell(
        onTap: () {
          int productId =
              int.tryParse((p['productid'] ?? p['id']).toString()) ?? 0;

          if (productId == 0) {
            print("Invalid product ID");
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductDetailScreen(productId: productId),
            ),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xffE6E6E6),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Center(
                  child: SizedBox(
                    height: 100,
                    child: imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.contain)
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                p['name'] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
  } 
  }

