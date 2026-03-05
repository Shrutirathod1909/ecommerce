import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  final int userId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.userId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  String imageUrl = "";
  Future addToCart() async {

  var response = await http.post(
    Uri.parse("http://192.168.1.39/ecommerce/add_to_cart.php"),
    body: {
      "userid": widget.userId.toString(),
      "productid": widget.productId.toString(),
      "quantity": "1"
    }
  );

  var data = json.decode(response.body);

  if(data["success"]){

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart"))
    );

  }else{

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Failed to add cart"))
    );

  }
} @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://192.168.1.39/ecommerce/product_details.php?id=${widget.productId}"),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        product = data['product'];

        /// IMAGE SAFE
        if (product?['image1'] != null && product?['image1'] != "") {
          imageUrl =
              "http://192.168.1.39/ecommerce/productgallery/${Uri.encodeComponent(product!['image1'])}";
        }

        setState(() => isLoading = false);
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 🔄 LOADING
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    /// ❌ NO PRODUCT
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Product not found")),
      );
    }

    /// ✅ SAFE PRICE CALCULATION (FIXED ERROR)
    double price = double.tryParse(product?['price'] ?? "") ?? 0;
    double mrp = price > 0 ? price * 1.4 : 0;

    int discount = 0;
    if (mrp > 0 && price > 0) {
      discount = (((mrp - price) / mrp) * 100).toInt();
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],

      /// 🔝 AMAZON SEARCH BAR
      appBar: AppBar(
  backgroundColor: const Color(0xFFDDB07F),
  elevation: 0,
  toolbarHeight: 70,
  automaticallyImplyLeading: false,

  title: Row(
    children: [

      /// 🔙 BACK BUTTON
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),

      const SizedBox(width: 10),

      /// 🔍 SEARCH BAR
      Expanded(
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [

              const SizedBox(width: 10),
              const Icon(Icons.search, color: Colors.black54),

              const SizedBox(width: 8),

              /// TEXT FIELD
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search or ask a question",
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// CAMERA
              const Icon(Icons.camera_alt_outlined,
                  color: Colors.black54),

              const SizedBox(width: 10),

              /// MIC
              const Icon(Icons.mic_none, color: Colors.black54),

              const SizedBox(width: 10),
            ],
          ),
        ),
      ),

      const SizedBox(width: 10),

      /// QR
      const Icon(Icons.qr_code_scanner, color: Colors.black),
    ],
  ),
),

      /// 🔥 BOTTOM BUTTONS
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [
        Expanded(
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.yellow,
      padding: const EdgeInsets.all(14),
    ),
    onPressed: (){
      addToCart();
    },
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
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () {},
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ),

      /// 📦 BODY
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🖼 IMAGE
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, height: 220)
                    : const Icon(Icons.image, size: 200),
              ),
            ),

            /// 🏷 BRAND + RATING
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    product?['brand'] ?? "Brand",
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const Text("2.7 (5)"),
                ],
              ),
            ),

            /// 📝 TITLE
          Container(
  color: Colors.white,
  padding: const EdgeInsets.all(12),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      /// 📝 NAME + PRICE
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PRODUCT NAME
            Text(
              product?['item_name'] ?? "",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 5),

               ],
        ),
      ),

      /// ❤️ LIKE BUTTON
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.favorite_border),
      ),

      /// 🔗 SHARE BUTTON
      IconButton(
        onPressed: () {},
        icon: const Icon(Icons.share),
      ),
    ],
  ),
),

            _divider(),

            /// 🎁 PRIME BOX
            _sectionBox(
              child: Row(
                children: [
                  const Text("prime",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Enjoy Unlimited FREE Same day delivery",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  )
                ],
              ),
            ),

            _divider(),

            /// 💰 PRICE
            _sectionBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("-$discount%",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 10),
                      Text("₹ ${price.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("M.R.P: ₹${mrp.toStringAsFixed(0)}",
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey)),
                  const SizedBox(height: 5),
                  const Text("Inclusive of all taxes"),
                ],
              ),
            ),

            _divider(),

            /// 🚚 DELIVERY
            _sectionBox(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FREE delivery Sunday",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text("Delivering to Mumbai"),
                  SizedBox(height: 5),
                  Text("Only few left in stock",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),

            _divider(),

            /// 📦 PRODUCT DETAILS
            _sectionBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Product Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Category: ${product?['category'] ?? '-'}"),
                  const SizedBox(height: 5),
                  Text("Brand: ${product?['brand'] ?? '-'}"),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// 🔻 DIVIDER
  Widget _divider() {
    return Container(height: 6, color: Colors.grey[200]);
  }

  /// 📦 COMMON BOX
  Widget _sectionBox({required Widget child}) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}