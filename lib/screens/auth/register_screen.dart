import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSuccess;

  const RegisterScreen({super.key, required this.onSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;

  /// REGISTER API
  Future<void> registerUser() async {

    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    var url = Uri.parse("http://192.168.1.39/ecommerce/register.php");

    try {

      var response = await http.post(
        url,
        body: {
          "fullname": nameController.text.trim(),
          "email": emailController.text.trim(),
          "phone": mobileController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      var data = jsonDecode(response.body);

      setState(() => isLoading = false);

      if (data["status"] == "success") {

        int userId = data["user"]["id"];
        String userName = data["user"]["fullname"];

        /// SAVE LOGIN DATA
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        await prefs.setInt("userid", userId);
        await prefs.setString("username", userName);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registration Successful")),
        );

        /// RETURN USER DATA
        widget.onSuccess({
          "userid": userId,
          "username": userName
        });

        Navigator.pop(context);

      } else {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Registration Failed")),
        );

      }

    } catch (e) {

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error")),
      );

    }

  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// UI
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
                    child: Icon(Icons.store,size:50,color:Colors.orange),
                  ),

                  const SizedBox(height:20),

                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize:24,fontWeight:FontWeight.bold),
                  ),

                  const SizedBox(height:20),

                  /// NAME
                  buildTextField(
                    "Your Name",
                    nameController,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Name is required";
                      }
                      if(value.length<3){
                        return "Minimum 3 characters";
                      }
                      return null;
                    },
                  ),

                  /// MOBILE
                  buildTextField(
                    "Mobile Number",
                    mobileController,
                    keyboard: TextInputType.phone,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Mobile number required";
                      }
                      if(!RegExp(r'^[0-9]{10}$').hasMatch(value)){
                        return "Enter valid 10 digit mobile";
                      }
                      return null;
                    },
                  ),

                  /// EMAIL
                  buildTextField(
                    "Email",
                    emailController,
                    keyboard: TextInputType.emailAddress,
                    validator: (value){
                      if(value==null || value.isEmpty){
                        return "Email required";
                      }
                      if(!RegExp(r'\S+@\S+\.\S+').hasMatch(value)){
                        return "Enter valid email";
                      }
                      return null;
                    },
                  ),

                  /// PASSWORD
                  buildPasswordField(
                    "Password",
                    passwordController,
                    _obscurePassword,
                    (){
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  /// CONFIRM PASSWORD
                  buildPasswordField(
                    "Confirm Password",
                    confirmPasswordController,
                    _obscureConfirmPassword,
                    (){
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value){
                      if(value != passwordController.text){
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height:20),

                  /// REGISTER BUTTON
                  SizedBox(

                    width: double.infinity,
                    height:45,

                    child: ElevatedButton(

                      onPressed: isLoading ? null : registerUser,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC107),
                        foregroundColor: Colors.black,
                      ),

                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              "Create your ShopCart account",
                              style: TextStyle(fontWeight: FontWeight.bold),
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

  /// TEXT FIELD
  Widget buildTextField(
      String label,
      TextEditingController controller,
      {TextInputType keyboard = TextInputType.text,
      String? Function(String?)? validator}) {

    return Padding(

      padding: const EdgeInsets.only(bottom:15),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(label,style:const TextStyle(fontWeight:FontWeight.bold)),

          const SizedBox(height:5),

          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator: validator,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),

        ],

      ),

    );

  }

  /// PASSWORD FIELD
  Widget buildPasswordField(
      String label,
      TextEditingController controller,
      bool obscure,
      VoidCallback toggle,
      {String? Function(String?)? validator}) {

    return Padding(

      padding: const EdgeInsets.only(bottom:15),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(label,style:const TextStyle(fontWeight:FontWeight.bold)),

          const SizedBox(height:5),

          TextFormField(

            controller: controller,
            obscureText: obscure,

            validator: validator ??
                (value){
                  if(value==null || value.isEmpty){
                    return "Password required";
                  }
                  if(value.length<6){
                    return "Minimum 6 characters";
                  }
                  return null;
                },

            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility
                ),
                onPressed: toggle,
              ),
            ),

          ),

        ],

      ),

    );

  }

}