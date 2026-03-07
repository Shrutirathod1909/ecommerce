import 'package:flutter/material.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool showAddressForm = false;
  String selectedPayment = '';
  final addressFormKey = GlobalKey<FormState>();

  // Controllers for address form
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController flatController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  String stateValue = 'Select';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange[200],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Address Card
              if (!showAddressForm)
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delivering to Rashmi',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No-09 Sairaj Soc, Ganesh Nagar, Diva, MAHARASHTRA, 400612, India',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showAddressForm = true;
                            });
                          },
                          child: const Text(
                            'Change delivery address',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Payment Options
              if (!showAddressForm)
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(top: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Options',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        RadioListTile(
                          value: 'Amazon Pay UPI',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Amazon Pay UPI'),
                          subtitle: const Text('Get up to ₹50 cashback*'),
                        ),
                        RadioListTile(
                          value: 'Google Pay',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Google Pay'),
                        ),
                        RadioListTile(
                          value: 'UPI Apps',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Pay by any UPI App'),
                          subtitle:
                              const Text('Google Pay, PhonePe, Paytm and more'),
                        ),
                        RadioListTile(
                          value: 'Credit/Debit Card',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Credit/Debit Card'),
                        ),
                        RadioListTile(
                          value: 'Net Banking',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Net Banking'),
                        ),
                        RadioListTile(
                          value: 'COD',
                          groupValue: selectedPayment,
                          onChanged: (value) {
                            setState(() {
                              selectedPayment = value!;
                            });
                          },
                          title: const Text('Cash on Delivery/Pay on Delivery'),
                          subtitle:
                              const Text('Cash, UPI and Cards accepted.'),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Address Form
              if (showAddressForm)
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: addressFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter a new delivery address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Mobile number',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: flatController,
                            decoration: const InputDecoration(
                              labelText: 'Flat, House no., Building, Company, Apartment',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: areaController,
                            decoration: const InputDecoration(
                              labelText: 'Area, Street, Sector, Village',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: landmarkController,
                            decoration: const InputDecoration(
                              labelText: 'Landmark (optional)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: pincodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Pincode',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: cityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Town/City',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: stateValue,
                            items: <String>[
                              'Select',
                              'Maharashtra',
                              'Gujarat',
                              'Delhi'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                stateValue = value!;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'State',
                            ),
                          ),
                          const SizedBox(height: 12),
                          CheckboxListTile(
                            value: false,
                            onChanged: (value) {},
                            title: const Text('Make this my default address'),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow[700],
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                if (addressFormKey.currentState!.validate()) {
                                  setState(() {
                                    showAddressForm = false;
                                  });
                                }
                              },
                              child: const Text('Use this address'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}