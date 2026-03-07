import 'dart:convert';
import 'package:app/screens/auth/login_screen.dart';
import 'package:app/screens/auth/register_screen.dart';
import 'package:app/screens/buy_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int? userId;
  List cartItems = [];
  bool isLoading = true;
  double subtotal = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userid");

    if (userId != null) {
      fetchCart();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future fetchCart() async {
    var response = await http.get(
      Uri.parse("http://192.168.1.39/ecommerce/cart_list.php?userid=$userId"),
    );
    var data = json.decode(response.body);

    if (data["success"]) {
      setState(() {
        cartItems = data["cart"];
        isLoading = false;
        calculateSubtotal();
      });
    }
  }

  void calculateSubtotal() {
    subtotal = 0;
    for (var item in cartItems) {
      double price = double.parse(item["price"].toString());
      int qty = int.parse(item["quantity"].toString());
      subtotal += price * qty;
    }
  }

  Future updateCart(int cartid, int qty) async {
    await http.post(
      Uri.parse("http://192.168.1.39/ecommerce/update_cart.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"cartid": cartid, "quantity": qty}),
    );
    fetchCart();
  }

  Future deleteItem(int cartid) async {
    await http.post(
      Uri.parse("http://192.168.1.39/ecommerce/remove_cart.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"cartid": cartid}),
    );
    fetchCart();
  }

  Widget cartItem(item) {
    int qty = int.parse(item["quantity"].toString());
    int cartId = int.parse(item["cartid"].toString());

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: true, onChanged: (v) {}),
          Image.network(
            "http://192.168.1.39/ecommerce/productgallery/${item["image1"]}",
            height: 100,
            width: 90,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["item_name"], maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: Colors.red,
                      child: const Text("-70%", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: 6),
                    Text("₹${item["price"]}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (qty > 1) updateCart(cartId, qty - 1);
                            },
                          ),
                          Text("$qty"),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => updateCart(cartId, qty + 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () => deleteItem(cartId),
                      child: const Text("Delete"),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xffe7b98f),
        title: Container(
          height: 45,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: const TextField(
            decoration: InputDecoration(
                hintText: "Search or ask a question",
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search)),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userId == null
              ? _loginUI()
              : cartItems.isEmpty
                  ? const Center(
                      child: Text("Your Cart is Empty", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    )
                  : ListView(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Subtotal ₹${subtotal.toStringAsFixed(2)}",
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
    onPressed: () {
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CheckoutScreen(),
          ),
        );
      }
    },
    child: Text("Proceed to Buy (${cartItems.length} item)"),
  ),
),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...cartItems.map((item) => cartItem(item)).toList(),
                        const SizedBox(height: 20),
                      ],
                    ),
    );
  }

  Widget _loginUI() {
    return ListView(
      children: [
        const SizedBox(height: 40),
        Image.asset("assets/image/cart.jpeg", height: 150),
        const SizedBox(height: 20),
        const Center(
          child: Text("Your Cart is empty", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(
                    onSuccess: (userData) {
                      setState(() {
                        userId = userData["userid"];
                      });
                      fetchCart();
                    },
                  ),
                ),
              );
            },
            child: const Text("Sign in to your account", style: TextStyle(color: Colors.black)),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutlinedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterScreen(
                    onSuccess: (userData) {
                      setState(() {
                        userId = userData["userid"];
                      });
                      fetchCart();
                    },
                  ),
                ),
              );
            },
            child: const Text("Sign up now"),
          ),
        ),
      ],
    );
  }
}