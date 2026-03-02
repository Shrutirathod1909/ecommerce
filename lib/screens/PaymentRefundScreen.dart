import 'package:flutter/material.dart';

class PaymentRefundScreen extends StatefulWidget {
  final String orderId;

  const PaymentRefundScreen({super.key, required this.orderId});

  @override
  State<PaymentRefundScreen> createState() => _PaymentRefundScreenState();
}

class _PaymentRefundScreenState extends State<PaymentRefundScreen> {
  String selectedPayment = "UPI";

  @override
  Widget build(BuildContext context) {
    // Dummy order data
    final products = [
      {"title": "Wireless Headphones", "price": 1200.0, "quantity": 1},
      {"title": "Smart Watch", "price": 899.0, "quantity": 2},
    ];
    final status = "Delivered";
    final paymentStatus = "Paid";
    final address = "Mumbai, India";

    // Calculate total
    double total = 0;
    for (var p in products) {
      total += (p['price'] as double) * (p['quantity'] as int);
    }

    bool canRefund = paymentStatus == "Paid" && status == "Delivered";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment & Refund"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Delivery Address",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(address),
              ),
            ),
            const SizedBox(height: 10),
            const Text("Order Summary",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            ...products.map((p) {
              final title = p['title'] as String;
              final price = p['price'] as double;
              final qty = p['quantity'] as int;
              return ListTile(
                title: Text(title),
                subtitle: Text("Qty: $qty\n₹${price.toStringAsFixed(2)}"),
              );
            }),
            const Divider(),
            Text("Total Amount: ₹${total.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Order Status: "),
                Chip(label: Text(status)),
              ],
            ),
            Row(
              children: [
                const Text("Payment Status: "),
                Chip(label: Text(paymentStatus)),
              ],
            ),
            const SizedBox(height: 20),
            if (paymentStatus == "Unpaid") ...[
              const Text("Select Payment Method"),
              RadioListTile(
                title: const Text("UPI"),
                value: "UPI",
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text("Credit/Debit Card"),
                value: "Card",
                groupValue: selectedPayment,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                child: const Text("Confirm Payment"),
              ),
            ],
            if (canRefund)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 40)),
                child: const Text("Request Refund"),
              ),
          ],
        ),
      ),
    );
  }
}