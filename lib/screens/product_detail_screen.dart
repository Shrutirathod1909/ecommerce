
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  Map<String, dynamic>? product;
  bool isLoading = true;
  bool isWishlist = false;

  String baseUrl = "http://192.168.1.39/ecommerce/";
  String baseImage = "http://192.168.1.39/ecommerce/productgallery/";

  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    fetchProduct();
    checkWishlist();
  }

  /// FETCH PRODUCT
  Future fetchProduct() async {

    var response = await http.get(
      Uri.parse("${baseUrl}product_details.php?id=${widget.productId}"),
    );

    var data = json.decode(response.body);

    if (data["status"] == "success") {

      setState(() {

        product = data["product"];
        imageUrl = baseImage + (product?["image1"] ?? "");
        isLoading = false;

      });

    } else {

      setState(() {
        isLoading = false;
      });

    }
  }

  /// CHECK WISHLIST
  Future checkWishlist() async {

    var prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userid") ?? 0;

    var response = await http.post(
      Uri.parse("${baseUrl}wishlist.php"),
      body: {
        "action": "check",
        "userid": userid.toString(),
        "productid": widget.productId.toString()
      },
    );

    var data = json.decode(response.body);

    if (data["exists"] == true) {
      setState(() {
        isWishlist = true;
      });
    }
  }

  /// TOGGLE WISHLIST
  Future toggleWishlist() async {

    var prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userid") ?? 0;

    String action = isWishlist ? "delete" : "add";

    var response = await http.post(
      Uri.parse("${baseUrl}wishlist.php"),
      body: {
        "action": action,
        "userid": userid.toString(),
        "productid": widget.productId.toString(),
        "quantity": "1",
        "unit_price": product?["price"]?.toString() ?? "0"
      },
    );

    var data = json.decode(response.body);

    if (data["status"] == "success" || data["status"] == "exists") {

      setState(() {
        isWishlist = !isWishlist;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Updated")),
      );
    }
  }

  /// ADD TO CART
  Future addToCart() async {

    var prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userid") ?? 0;

    var response = await http.post(
      Uri.parse("${baseUrl}add_to_cart.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userid": userid,
        "productid": widget.productId,
        "quantity": 1
      }),
    );

    var data = json.decode(response.body);

    if (data["success"] == true) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Added to cart")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    double price =
        double.tryParse(product?["price"]?.toString() ?? "0") ?? 0;

    double mrp = price * 1.4;

    int discount = (((mrp - price) / mrp) * 100).toInt();

    return Scaffold(

      backgroundColor: Colors.grey[200],

      /// AMAZON STYLE APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search or ask a question",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.qr_code_scanner, color: Colors.black),
          )
        ],
      ),

      /// BOTTOM BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                ),
                onPressed: addToCart,
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: () {},
                child: const Text("Buy Now"),
              ),
            )

          ],
        ),
      ),

      /// BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PRODUCT IMAGE
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Image.network(
                imageUrl,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),

            divider(),

            /// TITLE + WISHLIST
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product?["brand"] ?? "",
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: Text(
                          product?["item_name"] ?? "",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      IconButton(
                        onPressed: toggleWishlist,
                        icon: Icon(
                          isWishlist
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isWishlist
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),

                      const Icon(Icons.share)

                    ],
                  )
                ],
              ),
            ),

            divider(),

            /// PRICE
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Text(
                        "-$discount%",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        "₹$price",
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "M.R.P ₹$mrp",
                    style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey),
                  ),

                  const Text("Inclusive of all taxes"),
                ],
              ),
            ),

            divider(),

            /// DELIVERY FULL WIDTH
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Icon(Icons.local_shipping_outlined, size: 18),

                      SizedBox(width: 6),

                      Text(
                        "FREE delivery Tomorrow",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),

                  SizedBox(height: 6),

                  Text("Delivering to Mumbai"),

                  SizedBox(height: 6),

                  Text(
                    "Only few left in stock",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100)

          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      height: 6,
      width: double.infinity,
      color: Colors.grey[200],
    );
  }
}
