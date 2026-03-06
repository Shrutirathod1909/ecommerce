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

  /// DELETE WISHLIST
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

      /// ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB07F),
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search or ask a question",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),
      ),

      /// ================= BODY =================
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// LISTS HEADER
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Lists and Registries",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.add),
                        )
                      ],
                    ),
                  ),

                  /// SHOPPING LIST CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.list),
                                SizedBox(width: 10),
                                Text("Shopping List")
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.mic),
                                SizedBox(width: 10),
                                Text("Alexa List")
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ALL SAVES HEADER
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "All saves",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Add item",
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FILTER BUTTONS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [

                        filterButton("Filters"),
                        const SizedBox(width: 10),
                        filterButton("All", active: true),
                        const SizedBox(width: 10),
                        filterButton("Deals"),
                        const SizedBox(width: 10),
                        filterButton("Trending now"),

                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ================= GRID =================
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    itemCount: wishlist.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
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

                              /// IMAGE
                              Stack(
                                children: [

                                  Container(
                                    height: 120,
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      image,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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

                              /// NAME
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

                              const SizedBox(height: 5),

                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8),
                                child: Text(
                                  "Saved in Shopping List",
                                  style: TextStyle(
                                      color: Colors.blue),
                                ),
                              ),

                              const Spacer(),

                              /// ADD TO CART
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                    minimumSize: const Size(
                                        double.infinity, 35),
                                  ),

                                  onPressed: () {},

                                  child: const Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                        color: Colors.black),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget filterButton(String text, {bool active = false}) {

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: active ? Colors.white : Colors.black),
      ),
    );
  }
}