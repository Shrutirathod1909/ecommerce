import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {

  final int userId;

  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List cartItems = [];
  bool isLoading = true;
  bool isError = false;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  /// FETCH CART
 Future fetchCart() async {

  try {

    var response = await http.get(
      Uri.parse("http://192.168.1.39/ecommerce/get_cart.php?userid=${widget.userId}")
    );

    var data = json.decode(response.body);

    if(data["success"]){

      setState(() {

        cartItems = data["cart"];
        calculateSubtotal();
        isLoading = false;
        isError = false;

      });

    }else{

      setState(() {
        isLoading = false;
        isError = true;
      });

    }

  }catch(e){

    setState(() {
      isLoading = false;
      isError = true;
    });

  }

} /// CALCULATE SUBTOTAL
  void calculateSubtotal(){

    subtotal = 0;

    for(var item in cartItems){

      double price = double.tryParse(item["price"].toString()) ?? 0;
      int qty = int.tryParse(item["quantity"].toString()) ?? 1;

      subtotal += price * qty;

    }

  }

  /// UPDATE QUANTITY
  Future updateQuantity(int productId, int quantity) async {

    await http.post(
      Uri.parse("http://192.168.1.39/ecommerce/update_cart.php"),
      body: {
        "userid": widget.userId.toString(),
        "productid": productId.toString(),
        "quantity": quantity.toString()
      }
    );

    fetchCart();
  }

  /// DELETE ITEM
  Future deleteItem(int productId) async {

    await http.post(
      Uri.parse("http://192.168.1.39/ecommerce/delete_cart.php"),
      body: {
        "userid": widget.userId.toString(),
        "productid": productId.toString()
      }
    );

    fetchCart();
  }

  /// RETRY
  void retry(){
    setState(() {
      isLoading = true;
      isError = false;
    });

    fetchCart();
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if(isError){
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: retry,
            child: const Text("Retry"),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      /// APPBAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDB07F),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.search),
              SizedBox(width: 10),
              Expanded(child: Text("Search or ask a question")),
              Icon(Icons.camera_alt_outlined),
              SizedBox(width: 10),
              Icon(Icons.mic_none),
              SizedBox(width: 10),
            ],
          ),
        ),
      ),

      /// BODY
      body: ListView(
        children: [

          /// SUBTOTAL
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Text(
              "Subtotal ₹$subtotal",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),

          /// BUY BUTTON
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Proceed to Buy (${cartItems.length} item)",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// CART ITEMS
          ...cartItems.map((item){

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom:10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// IMAGE
                  Image.network(
                    "http://192.168.1.39/ecommerce/productgallery/${item["image1"]}",
                    height: 120,
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context,error,stack){
                      return const Icon(Icons.image,size:80);
                    },
                  ),

                  const SizedBox(width: 10),

                  /// DETAILS
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          item["item_name"],
                          style: const TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "₹${item["price"]}",
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),

                        const SizedBox(height: 10),

                        /// QUANTITY
                        Row(
                          children: [

                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {

                                int qty = int.parse(item["quantity"].toString());

                                if(qty > 1){
                                  updateQuantity(item["productid"], qty - 1);
                                }

                              },
                            ),

                            Text(item["quantity"].toString()),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {

                                int qty = int.parse(item["quantity"].toString());

                                updateQuantity(item["productid"], qty + 1);

                              },
                            ),

                          ],
                        ),

                        const SizedBox(height: 10),

                        /// DELETE
                        OutlinedButton(
                          onPressed: (){
                            deleteItem(item["productid"]);
                          },
                          child: const Text("Delete"),
                        )

                      ],
                    ),
                  )
                ],
              ),
            );

          }).toList()

        ],
      ),
    );
  }
}