import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const ProductCard({super.key, required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  product.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("-${product.discount}%",
                        style: TextStyle(color: Colors.red)),
                    Text("₹${product.price}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("₹${product.oldPrice}",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: onAdd,
              child: CircleAvatar(
                backgroundColor: Color(0xffFF9900),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}