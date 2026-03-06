import 'dart:convert';
import 'package:app/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          childAspectRatio: 0.68,
        ),

        itemBuilder: (context,index){

          var product = products[index];

          return GestureDetector(

      onTap: () {

  int productId = int.tryParse(product['id'].toString()) ?? 0;

  if (productId == 0) {
    print("Invalid product id");
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(
        productId: productId,
      ),
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

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  /// PRODUCT IMAGE
                  Stack(
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12)
                        ),

                        child: Image.network(
                          "$baseUrl/productgallery/${product["image"]}",
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),

                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                          color: Colors.red,
                          child: const Text(
                            "20% OFF",
                            style: TextStyle(color: Colors.white,fontSize: 10),
                          ),
                        ),
                      ),

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        /// NAME
                        Text(
                          product["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// RATING
                        Row(
                          children: const [
                            Icon(Icons.star,size:14,color:Colors.orange),
                            Icon(Icons.star,size:14,color:Colors.orange),
                            Icon(Icons.star,size:14,color:Colors.orange),
                            Icon(Icons.star,size:14,color:Colors.orange),
                            Icon(Icons.star_half,size:14,color:Colors.orange),
                            SizedBox(width:4),
                            Text("(120)",style:TextStyle(fontSize:10))
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// PRICE
                        Row(
                          children: [

                            Text(
                              "₹ ${product["price"]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),

                            const SizedBox(width:6),

                            const Text(
                              "₹499",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 8),

                        /// ADD CART BUTTON
                        SizedBox(
                          width: double.infinity,
                          height: 32,

                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),

                            onPressed: (){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to cart")
                                )
                              );
                            },

                            child: const Text(
                              "Add to Cart",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )

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