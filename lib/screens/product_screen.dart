import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_detail_screen.dart';

class ProductScreen extends StatefulWidget {

  final String subcategory;

  const ProductScreen({super.key, required this.subcategory});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  List products = [];
  bool isLoading = true;

  String baseUrl = "http://192.168.1.39/ecommerce";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future fetchProducts() async {

    var response = await http.get(
      Uri.parse("$baseUrl/get_products.php?subcategory=${Uri.encodeComponent(widget.subcategory)}")
    );

    var data = jsonDecode(response.body);

    if(data["status"] == true){

      setState(() {
        products = data["data"];
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.subcategory),
        backgroundColor: Colors.orange,
      ),

      body: GridView.builder(

        padding: const EdgeInsets.all(12),
        itemCount: products.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.65,
        ),

        itemBuilder: (context,index){

          var product = products[index];

          return GestureDetector(

            onTap: () {

              int productId =
              int.tryParse(product['id'].toString()) ?? 0;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  ProductDetailScreen(productId: productId),
                ),
              );

            },

            child: Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 5)
                ],
              ),

              child: Column(

                children: [

                  Expanded(
                    child: Image.network(
                      "$baseUrl/productgallery/${product["image"]}",
                      fit: BoxFit.contain,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          product["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height:5),

                        Text(
                          "₹ ${product["price"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                      ],
                    ),
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}