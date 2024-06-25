// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/selectedproduct.dart';
import 'package:miogra/features/usedProducts/models/get_allused_products.dart';
import 'package:miogra/features/usedProducts/pages/select_category_selling_page.dart';
import 'package:http/http.dart' as http;
import 'package:miogra/models/selectedproduct_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class UsedProductsLandingPage extends StatefulWidget {
  const UsedProductsLandingPage({super.key});

  @override
  State<UsedProductsLandingPage> createState() =>
      _UsedProductsLandingPageState();
}

class _UsedProductsLandingPageState extends State<UsedProductsLandingPage> {
  List<Order> orders = [];
  // final TextEditingController _controller = TextEditingController();
  List<Order> searchResults = [];
  bool showResults = false;

  List<UsedProducts> allProducts = [];
  List<UsedProducts> filteredFoodProducts = [];
  final TextEditingController searchController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   // Call fetchProducts when the widget is initialized
  //   fetchProducts();
  // }

  Future<void> fetchProducts() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    const url =
        'https://${ApiServices.ipAddress}/user_get_all_shopproducts/QMC77LVGSXM/ID7KRF1K7K8';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        setState(() {
          orders.clear();
          for (var item in jsonData) {
            Order order = Order(
              model_name: item['product']['model_name'],
              model_brand: item['product']['model_brand'],
              model_actual_price: item['product']['model_actual_price'],
              model_discount_price: item['product']['model_discount_price'],
            );
            orders.add(order);
          }
        });
      } else {
        print('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching orders: $e');
    }
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      setState(() {
        showResults = false;
        searchResults.clear();
      });
      return;
    }
    setState(() {
      showResults = true;
      searchResults.clear();
      searchResults
          .addAll(orders.where((order) => order.model_name.contains(query)));
    });
  }

  // void onOrderClicked(Order order) {
  //   // Handle click on order
  //   print('Order clicked: ${order.model_name}');
  //   // Navigate to the selected product page and pass the selected Order object
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SelectedProduct(order: order)),
  //   );
  // }

  void onOrderClicked(Order order) {
    if (searchResults.isNotEmpty) {
      // Access searchResults[0] only if the list is not empty
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SelectedProduct(order: searchResults[0])),
      );
    } else {
      // Handle the case where search results are empty (e.g., show a message)
    }
  }

  bool loadingFetchGetAllusedProducts = true;

  List<GetAllusedProducts> getAllusedProducts = [];

  Future<void> fetchGetAllusedProducts() async {
    final response = await http.get(
        Uri.parse('https://${ApiServices.ipAddress}/get_allused_products/'));

    debugPrint('https://${ApiServices.ipAddress}/get_allused_products');

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        getAllusedProducts = jsonResponse
            .map((data) => GetAllusedProducts.fromJson(data))
            .toList();
        loadingFetchGetAllusedProducts = false;
      });

      // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchGetAllusedProducts();
    // fetchProducts();
    _fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: textFeild(context),
              ),

              Visibility(
                visible: showSuggestions,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 246, 213, 248),
                    ),
                    duration: const Duration(microseconds: 1000),
                    curve: Curves.easeInToLinear,
                    height: showSuggestions ? 300 : 0,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Divider(
                          color: Colors.grey[500],
                          thickness: 0.5,
                        ),
                      ),
                      itemCount: filteredFoodProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredFoodProducts[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Text(product.name),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 20),
              //   height: 40,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: const Color(0xff870081),
              //       width: 1.3,
              //     ),
              //     borderRadius: const BorderRadius.all(
              //       Radius.circular(15),
              //     ),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         // Replace Text widget with TextField widget
              //         child: TextField(
              //           controller: _controller,
              //           decoration: InputDecoration(
              //             hintText: "Search in miogra", // Placeholder text
              //             hintStyle: TextStyle(
              //               color: Colors.grey.shade500,
              //               fontSize: 16,
              //             ),
              //             border: InputBorder.none, // Remove border
              //           ),
              //           style: const TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //           ), // Text style
              //           onChanged: (text) {
              //             // Handle text input changes
              //             log('Input: $text');
              //             searchOrders(text);
              //           },
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           // Perform the same action as onOrderClicked when the icon is tapped
              //           if (searchResults.isNotEmpty) {
              //             onOrderClicked(searchResults[0]);
              //           }
              //         },
              //         child: const Icon(
              //           Icons.search_rounded,
              //           color: Color(0xff870081),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Display search results here
              if (showResults)
                Column(
                  children: searchResults.map((order) {
                    return GestureDetector(
                      onTap: () => onOrderClicked(order),
                      child: ListTile(
                        title: Text(order.model_name),
                        subtitle: Text(order.model_brand),
                        // Add more widgets to display other details if needed
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 10),

              // Categories
              const Padding(
                padding: EdgeInsets.only(left: 10, bottom: 15, top: 15),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xE6434343)),
                ),
              ),
              // SizedBox(
              //   height: 203,
              //   child: Center(
              //     child: GridView.builder(
              //       shrinkWrap: true,
              //       primary: false,
              //       scrollDirection: Axis.horizontal,
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         crossAxisSpacing: 7,
              //         mainAxisSpacing: 10,
              //       ),
              //       // itemCount: userProductsCategory.length,
              //       itemCount: usedProductsItems.isNotEmpty
              //           ? usedProductsItems.length
              //           : 0,

              //       itemBuilder: (context, index) {
              //         return usedProductsItems.isEmpty
              //             ? const Text('nothing to Show')
              //             : categoryItem(
              //                 userProductsCategory[index]['image']!,
              //                 userProductsCategory[index]['name']!,
              //                 () {
              //                   Navigator.of(context).push(
              //                     MaterialPageRoute(
              //                       builder: (context) =>

              //                           // UsedProductsItem()
              //                           UsedProductsCategoryBasedProductsScreen(
              //                         subCategory: userProductsCategory[index]
              //                             ['name']!,
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               );
              //       },
              //     ),
              //   ),
              // ),

              const SizedBox(
                height: 30,
              ),

              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "Nearby Products",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xE6434343)),
                      ),
                    ),
                    // GridView.builder(
                    //   shrinkWrap: true,
                    //   primary: false,
                    //   padding: const EdgeInsets.only(left: 5, right: 5),
                    //   gridDelegate:
                    //       const SliverGridDelegateWithFixedCrossAxisCount(
                    //           crossAxisCount: 2,
                    //           crossAxisSpacing: 5,
                    //           mainAxisSpacing: 5,
                    //           childAspectRatio: .65),
                    //   // itemCount: usedProductsItems.length,
                    //   itemCount: usedProductsItems.isNotEmpty
                    //       ? usedProductsItems.length
                    //       : 0,
                    //   itemBuilder: (context, index) {
                    //     return usedProductsItems.isEmpty
                    //         ? const Text('Nothing to show')
                    //         : usedProductBox(
                    //             image: getAllusedProducts[index]
                    //                 .product
                    //                 .primaryImage,
                    //             pName: getAllusedProducts[index].product.name,
                    //             price: getAllusedProducts[index]
                    //                 .product
                    //                 .sellingPrice
                    //                 .toString(),
                    //             color: const Color(0x6B870081),
                    //             contact: usedProductsItems[index]["contact"]!,
                    //             location: usedProductsItems[index]["location"]!,
                    //             page: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) =>

                    //                       // UsedProductProductDetailsPage(
                    //                       //   productId: getAllusedProducts[index].product.productId,)
                    //                       const UsedProductDetailsScreen(),
                    //                 ),
                    //               );
                    //             },
                    //           );
                    //   },
                    // ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: primaryColor,
        child: const Text(
          "Sell",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectCategoryForSellingScreen(),
            ),
          );
        },
      ),
    );
  }

  PreferredSize textFeild(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60.0),
      child: TextField(
        onTap: () {
          setState(() {
            showSuggestions = true;
          });
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
          setState(() {
            showSuggestions = false;
          });
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5.0,
          ),
          hintText: 'Search in miogra',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ),
        onChanged: (value) {
          _filterProducts(value);
        },
      ),
    );
  }

  void _fetchAllProducts() async {
    // Replace with your actual API call and data parsing logic
    final response =
        await http.get(Uri.parse('https://miogra.com/get_allused_products'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        allProducts =
            (data as List).map((item) => UsedProducts.fromJson(item)).toList();
        filteredFoodProducts = allProducts; // Initially show all products
      });
    } else {
      // Handle API request error
    }
  }

  void _filterProducts(String searchTerm) {
    filteredFoodProducts = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
    setState(() {}); // Rebuild the UI with filtered products
  }

  bool showSuggestions = false;
}

class UsedProducts {
  final String name;

  UsedProducts.fromJson(Map<String, dynamic> json)
      : name = json['product']['model_name'];
}
