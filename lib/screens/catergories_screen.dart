import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  List categories = [];
  List subcategories = [];

  bool isLoading = true;
  int selectedIndex = 0;

  String baseUrl = "http://192.168.1.39/ecommerce";

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  /// FETCH CATEGORIES
  Future fetchCategories() async {

    try{

      var response = await http.get(
          Uri.parse("$baseUrl/get_categories.php")
      );

      var data = jsonDecode(response.body);

      if(data["status"] == true){

        setState(() {

          categories = data["data"];
          isLoading = false;

        });

        if(categories.isNotEmpty){
          fetchSubcategories(categories[0]["category_name"]);
        }

      }

    }catch(e){
      print(e);
    }
  }

  /// FETCH SUBCATEGORIES
  Future fetchSubcategories(String category) async {

    try{

      var response = await http.get(
          Uri.parse("$baseUrl/get_subcategories.php?category=${Uri.encodeComponent(category)}")
      );

      var data = jsonDecode(response.body);

      if(data["status"] == true){

        setState(() {

          subcategories = data["data"];

        });
      }

    }catch(e){
      print(e);
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

      /// APP BAR
      appBar: AppBar(

        backgroundColor: const Color(0xffe6b980),
        elevation: 0,

        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),

          child: Row(
            children: const [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Search or ask a question",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
              Icon(Icons.camera_alt_outlined),
            ],
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner,color: Colors.black),
            onPressed: () {},
          )
        ],
      ),

      /// BODY
      body: Row(
        children: [

          /// LEFT CATEGORY MENU
          Container(
            width: 110,
            color: const Color(0xffF4F4F4),

            child: ListView.builder(

              itemCount: categories.length,

              itemBuilder: (context,index){

                bool isSelected = selectedIndex == index;

                return GestureDetector(

                  onTap: (){

                    setState(() {
                      selectedIndex = index;
                    });

                    fetchSubcategories(categories[index]["category_name"]);

                  },

                  child: AnimatedContainer(

                    duration: const Duration(milliseconds: 300),

                    padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 8
                    ),

                    decoration: BoxDecoration(

                      color: isSelected
                          ? Colors.white
                          : const Color(0xffF4F4F4),

                      border: isSelected
                          ? const Border(
                        left: BorderSide(
                          color: Color(0xffF08804),
                          width: 4,
                        ),
                      )
                          : null,
                    ),

                    child: Column(

                      children: [

                        Image.network(
                          "$baseUrl/${categories[index]["image"]}",
                          height: 28,
                          width: 28,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          categories[index]["category_name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// RIGHT SUBCATEGORY GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// CATEGORY TITLE
                  Text(
                    categories[selectedIndex]["category_name"],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// SUBCATEGORY GRID
                  Expanded(
                    child: GridView.builder(

                      itemCount: subcategories.length,

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.60,
                      ),

                      itemBuilder: (context,index){

                        return GestureDetector(

                          onTap: (){

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  subcategory: subcategories[index]["title"],
                                ),
                              ),
                            );

                          },

                          child: Column(

                            children: [

                              Container(

                                height: 60,
                                width: 60,

                                decoration: BoxDecoration(
                                  color: const Color(0xffFAFAFA),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0,3),
                                    )
                                  ],
                                ),

                                child: ClipRRect(

                                  borderRadius: BorderRadius.circular(15),

                                  child: Image.network(
                                    "$baseUrl/${subcategories[index]["image"]}",
                                    fit: BoxFit.cover,
                                  ),

                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                subcategories[index]["title"],
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              )

                            ],
                          ),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}