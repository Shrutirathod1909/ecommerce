import 'dart:convert';
import 'package:app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  List wishlist = [];
  bool loading = true;

  String baseUrl = "http://192.168.1.39/ecommerce/";
  String baseImage = "http://192.168.1.39/ecommerce/productgallery/";

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  /// FETCH WISHLIST
  Future fetchWishlist() async {

    var prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userid") ?? 0;

    var response = await http.post(
      Uri.parse("${baseUrl}wishlist.php"),
      body: {
        "action": "get",
        "userid": userid.toString()
      },
    );

    var data = json.decode(response.body);

    if (data["status"] == "success") {

      setState(() {
        wishlist = data["data"];
        loading = false;
      });

    } else {

      setState(() {
        loading = false;
      });

    }
  }

  /// DELETE FROM WISHLIST
  Future deleteWishlist(String productid) async {

    var prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userid") ?? 0;

    await http.post(
      Uri.parse("${baseUrl}wishlist.php"),
      body: {
        "action": "delete",
        "userid": userid.toString(),
        "productid": productid
      },
    );

    fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[200],

      /// APPBAR
    appBar: AppBar(
  backgroundColor: const Color(0xFFDDB07F),
  elevation: 0,
  titleSpacing: 0,
  title: Row(
    children: [

      /// SEARCH BOX
      Expanded(
        child: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Row(
            children: [

              const SizedBox(width: 8),

              const Icon(Icons.search, color: Colors.grey),

              const SizedBox(width: 5),

              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search products",
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// CAMERA
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {},
              ),

              /// MIC
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: () {},
              ),

            ],
          ),
        ),
      ),

      /// QR SCAN OUTSIDE SEARCH
      IconButton(
        icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
        onPressed: () {},
      ),

    ],
  ),
),   /// BODY
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(

        padding: const EdgeInsets.all(10),
        itemCount: wishlist.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),

        itemBuilder: (context, index) {

          var item = wishlist[index];

          String image =
              baseImage + (item["image1"] ?? "");

          return GestureDetector(

            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(
                        productId: int.parse(
                            item["productid"].toString()),
                      ),
                ),
              );

            },

            child: Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// IMAGE + HEART
                  Stack(
                    children: [

                      SizedBox(
                        height: 130,
                        width: double.infinity,
                        child: Image.network(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image),
                        ),
                      ),

                      Positioned(
                        right: 5,
                        top: 5,
                        child: GestureDetector(
                          onTap: () {
                            deleteWishlist(
                                item["productid"]
                                    .toString());
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 5),

                  /// PRODUCT NAME
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text(
                      item["item_name"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 5),

                  /// PRICE
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text(
                      "₹${item["price"]}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
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