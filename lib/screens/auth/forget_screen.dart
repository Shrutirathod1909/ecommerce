import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool _obscurePassword = true;
  int step = 1; // 1 = phone, 2 = otp, 3 = reset

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
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // Logo
                  Center(
                    child: Image.asset(
                      "assets/image/icon.png",
                      height: 50,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Title
                  Text(
                    step == 1
                        ? "Forgot Password"
                        : step == 2
                            ? "Enter OTP"
                            : "Reset Password",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),

                  // ---------------- STEP 1 ----------------
                  if (step == 1) ...[
                    Text("Mobile Number",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold)),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: phoneController,
                      keyboardType:
                          TextInputType.phone,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Enter mobile number";
                        }
                        if (value.length < 10) {
                          return "Enter valid 10 digit number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  // ---------------- STEP 2 ----------------
                  if (step == 2) ...[
                    Text("OTP",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold)),
                    SizedBox(height: 5),
                    TextFormField(
                      controller: otpController,
                      keyboardType:
                          TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Enter OTP";
                        }
                        if (value.length < 4) {
                          return "Enter valid OTP";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  // ---------------- STEP 3 ----------------
                  if (step == 3) ...[
                    Text("New Password",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold)),
                    SizedBox(height: 5),
                    TextFormField(
                      controller:
                          newPasswordController,
                      obscureText:
                          _obscurePassword,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Enter new password";
                        }
                        if (value.length < 6) {
                          return "Minimum 6 characters required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 25),

                  // Continue / Reset Button
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (step < 3) {
                          nextStep();
                        } else {
                          if (_formKey
                              .currentState!
                              .validate()) {

                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Password Reset Successful"),
                                backgroundColor:
                                    Colors.green,
                              ),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LoginScreen(  onSuccess: () {},),
                              ),
                            );
                          }
                        }
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Color(0xFFFFC107),
                        foregroundColor:
                            Colors.black,
                      ),
                      child: Text(
                        step == 3
                            ? "Reset Password"
                            : "Continue",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Back to Login
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginScreen(onSuccess:() {},),
                          ),
                        );
                      },
                      child: Text(
                        "Back to Sign-In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight:
                              FontWeight.bold,
                        ),
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
}