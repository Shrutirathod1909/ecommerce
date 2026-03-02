import 'package:flutter/material.dart';

class MyWishlistScreen extends StatefulWidget {
  const MyWishlistScreen({super.key});

  @override
  State<MyWishlistScreen> createState() => _MyWishlistScreenState();
}

class _MyWishlistScreenState extends State<MyWishlistScreen> {

  // Dummy Wishlist Data
  List<Map<String, dynamic>> wishlistItems = [
    {
      "title": "Premium Smart Watch",
      "price": 4999.00,
      "image": "https://via.placeholder.com/150"
    },
    {
      "title": "Wireless Headphones",
      "price": 2999.00,
      "image": "https://via.placeholder.com/150"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: const Color(0xFF131921),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: wishlistItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [

                        /// 🖼 Product Image
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),
                          child: Image.network(
                            item["image"],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 📦 Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                item["title"],
                                style: const TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 16),
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "₹${item["price"].toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color:
                                      Color(0xFFFF9900),
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// Buttons
                              Row(
                                children: [

                                  /// Add to Cart
                                  ElevatedButton.icon(
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          const Color(
                                              0xFFFF9900),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    6),
                                      ),
                                      padding:
                                          const EdgeInsets
                                              .symmetric(
                                                  vertical:
                                                      6,
                                                  horizontal:
                                                      10),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger
                                              .of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Added to cart")),
                                      );
                                    },
                                    icon: const Icon(
                                        Icons
                                            .shopping_cart,
                                        size: 18,
                                        color:
                                            Colors.white),
                                    label: const Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .white),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// Remove
                                  OutlinedButton(
                                    style:
                                        OutlinedButton
                                            .styleFrom(
                                      foregroundColor:
                                          Colors.red,
                                      side:
                                          const BorderSide(
                                              color:
                                                  Colors
                                                      .red),
                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                                    6),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        wishlistItems
                                            .removeAt(
                                                index);
                                      });
                                    },
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  /// Empty State UI
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: const [
          Icon(Icons.favorite_border,
              size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Your wishlist is empty",
            style:
                TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}