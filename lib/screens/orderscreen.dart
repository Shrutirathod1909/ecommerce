import 'package:flutter/material.dart';
import 'PaymentRefundScreen.dart';

class MyOrdersScreen extends StatelessWidget {
  final String uid;

  const MyOrdersScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Dummy orders for UI preview
    final orders = [
      {
        "orderId": "1001",
        "status": "Delivered",
        "paymentStatus": "Paid",
        "total": 1200.0
      },
      {
        "orderId": "1002",
        "status": "Pending",
        "paymentStatus": "Unpaid",
        "total": 599.0
      },
      {
        "orderId": "1003",
        "status": "Cancelled",
        "paymentStatus": "Unpaid",
        "total": 899.0
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF131921),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFEAEDED),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text("Order #${order['orderId']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Status: ${order['status']}"),
                  Text("Payment: ${order['paymentStatus']}"),
                  Text(
                    "Total: ₹${(order['total'] as num).toDouble().toStringAsFixed(2)}",
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to PaymentRefundScreen (UI-only)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentRefundScreen(
                    
                      orderId: order['orderId'].toString(),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}