import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {

  File? image;
  final picker = ImagePicker();

  Future pickImage() async {

    final picked =
        await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {

      setState(() {
        image = File(picked.path);
      });

      searchProduct(image!);
    }
  }

  Future searchProduct(File img) async {

    var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://yourapi.com/search_product.php"));

    request.files.add(
      await http.MultipartFile.fromPath('image', img.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {

      var data = await response.stream.bytesToString();
      var jsonData = json.decode(data);

      print(jsonData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Search Product"),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: pickImage,
          ),
        ],
      ),

      body: Center(
        child: image == null
            ? const Text("Take Photo to Search Product")
            : Image.file(image!, height: 300),
      ),
    );
  }
}