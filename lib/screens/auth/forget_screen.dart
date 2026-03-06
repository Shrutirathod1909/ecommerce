import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSuccess; // optional callback

  const ForgotPasswordScreen({super.key, this.onSuccess});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool _obscurePassword = true;
  int step = 1; // 1 = phone, 2 = otp, 3 = reset
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        step++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Icon(Icons.store, size: 50, color: Colors.orange),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    step == 1
                        ? "Forgot Password"
                        : step == 2
                            ? "Enter OTP"
                            : "Reset Password",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Step 1: Phone Number
                  if (step == 1)
                    buildTextField(
                      "Mobile Number",
                      phoneController,
                      keyboard: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter mobile number";
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Enter valid 10-digit number";
                        }
                        return null;
                      },
                    ),

                  // Step 2: OTP
                  if (step == 2)
                    buildTextField(
                      "OTP",
                      otpController,
                      keyboard: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter OTP";
                        }
                        if (value.length < 4) {
                          return "Enter valid OTP";
                        }
                        return null;
                      },
                    ),

                  // Step 3: Reset Password
                  if (step == 3)
                    buildPasswordField(
                      "New Password",
                      newPasswordController,
                      _obscurePassword,
                      () => setState(() => _obscurePassword = !_obscurePassword),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Enter new password";
                        if (value.length < 6) return "Minimum 6 characters required";
                        return null;
                      },
                    ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (step < 3) {
                                nextStep();
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Password Reset Successful"),
                                        backgroundColor: Colors.green),
                                  );

                                  // Call optional onSuccess callback
                                  widget.onSuccess?.call({"reset": true});

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          LoginScreen(onSuccess: (userData) {
                                        Navigator.pop(context, userData);
                                      }),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        step == 3 ? "Reset Password" : "Continue",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(onSuccess: (userData) {
                              Navigator.pop(context, userData);
                            }),
                          ),
                        );
                      },
                      child: const Text(
                        "Back to Sign-In",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField
  Widget buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator: validator,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  // Reusable PasswordField
  Widget buildPasswordField(String label, TextEditingController controller,
      bool obscure, VoidCallback toggle,
      {String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: toggle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}