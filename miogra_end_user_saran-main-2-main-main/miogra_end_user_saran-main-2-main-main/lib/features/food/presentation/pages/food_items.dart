import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:miogra/core/api_services.dart';
import 'package:miogra/core/colors.dart';
import 'package:miogra/features/food/models_foods/food_get_products_model.dart';
import 'package:miogra/features/food/models_foods/my_food_data.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, dynamic>> CustmyFoodData = [
  {
    "id": "1",
    "prof": 'assets/images/appliances.jpeg',
    "foodname": "Chiken Manchurian",
    "price": "150",
    "description":
        "Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad",
  },
  {
    "id": "2",
    "prof": 'assets/images/appliances.jpeg',
    "foodname": "Chiken 65",
    "price": "180",
    "description":
        "Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad",
  },
  {
    "id": "3",
    "prof": 'assets/images/appliances.jpeg',
    "foodname": "Chiken grill",
    "price": "250",
    "description":
        "Chiken grill + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad Chiken Manchurian + Salad",
  },
];

// List<int> qty = List<int>.generate(CustmyFoodData.length, (index) => 0);

class FoodItems extends StatefulWidget {
  final String categoryName;
  final String foodId;
  const FoodItems(
      {super.key, required this.foodId, required this.categoryName});

  @override
  State<FoodItems> createState() => _FoodItemsState();
}

class _FoodItemsState extends State<FoodItems> {
  bool loadingFetchMyFoodData = true;

  bool loadingFetchFoodGetProducts = true;

  List<int> qty = [];

  static List<FoodGetProducts> foodGetProducts = [];

  Future<void> fetchFoodGetProducts1(String foodId) async {
    final response = await http.get(
        Uri.parse('http://${ApiServices.ipAddress}/food_get_products/$foodId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);

      setState(() {
        foodGetProducts =
            jsonResponse.map((data) => FoodGetProducts.fromJson(data)).toList();
        loadingFetchFoodGetProducts = false;
      });

      // return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

//  for FoodGetProducts
  Future<List<FoodGetProducts>> fetchFoodGetProducts(String foodId) async {
    final response = await http.get(
        Uri.parse('http://${ApiServices.ipAddress}/food_get_products/$foodId'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      // setState(() {
      //   loadingFetchFoodGetProducts = false;
      // });

      return data.map((json) => FoodGetProducts.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

//  for MyFoodData

  late MyFoodData myFoodData;

  void fetchMyFoodData1(String foodId) async {
    final response = await http
        .get(Uri.parse('http://${ApiServices.ipAddress}/my_food_data/$foodId'));

    if (response.statusCode == 200) {
      setState(() {
        myFoodData = MyFoodData.fromJson(jsonDecode(response.body));
        loadingFetchMyFoodData = false;
      });
    } else {
      throw Exception('Failed to load user');
    }
  }

//  for MyFoodData

  Future<MyFoodData> fetchMyFoodData(String foodId) async {
    final response = await http
        .get(Uri.parse('http://${ApiServices.ipAddress}/my_food_data/$foodId'));

    if (response.statusCode == 200) {
      // setState(() {
      //   loadingFetchMyFoodData = false;
      // });
      return MyFoodData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  String userId = 'a';

  addToCartAllSelectedProductsLoop() {
    for (var i = 0; i < orderedFoods.length; i++) {
      addToCart(orderedFoods[i][1], widget.categoryName, qty[i]);
    }
  }

  addToCart(String productId, String category, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("api_response").toString();
    });

    debugPrint('userId : $userId');
    debugPrint('productId : $productId');
    debugPrint('category : $category');
    debugPrint('quantity : $quantity');

    var headers = {
      'Context-Type': 'application/json',
    };

    var requestBody = {
      "quantity": quantity.toString(),
      // 'area': areaController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(
            "http://${ApiServices.ipAddress}/cart_product/$userId/$productId/$category/"),
        headers: headers,
        body: requestBody,
      );
      debugPrint(
          "http://${ApiServices.ipAddress}/cart_product/$userId/$productId/$category/}");
      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        print(response.statusCode);
        print('Product Added To Cart Successfully');
      } else {
        print('status code : ${response.statusCode}');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateValueInc(int index1) {
    print('update quantity');
    setState(() {
      // Increment the value at the specified index
      // if (index >= 0 && index < qty.length) {
      // qty[index1] = qty[index1] + 1;

      qty[index1]++;

      if (!(orderedFoods.any((list) =>
          list.toString() ==
          [foodGetProducts[index1].foodId, foodGetProducts[index1].productId]
              .toString()))) {
        setState(() {
          orderedFoods.insert(index1, [
            foodGetProducts[index1].foodId,
            foodGetProducts[index1].productId
          ]);

          print('orderedFoods : $orderedFoods');
        });
      }

      // addToCart(foodGetProducts[index1].productId,
      //     foodGetProducts[index1].category, qty[index1]);
    });
    // print('orderedFoods : $orderedFoods');
    print(qty.toString());
    print(qty.length);
    print(qty[index1]);
    print(index1 + 1);
  }

  void updateValueDec(int index1) {
    if (qty[index1] >= 1) {
      setState(() {
        qty[index1]--;
      });
    } else {}

    if (qty[index1] == 0) {
      setState(() {
        orderedFoods.removeAt(
          index1,

          //  [
          //   foodGetProducts[index1].foodId,
          //   foodGetProducts[index1].productId
          // ]
        );

        print('orderedFoods remove : $orderedFoods');
      });
    }
  }

  List<int> totalQtyBasedPrice = [];

  List<int> totalqty = [];

  int totalQtyBasedPrice1 = 0;

  int totalqty1 = 0;

  calcTotalPriceWithResQty() {
    setState(() {
      totalQtyBasedPrice1 = 0;
      totalQtyBasedPrice = [];
      totalqty1 = 0;
      totalqty = [];
    });
    // totalQuantity = 0;
    for (var i = 0; i < foodGetProducts.length; i++) {
      print(foodGetProducts[i].product.sellingPrice);
      setState(() {
        totalQtyBasedPrice
            .add(foodGetProducts[i].product.sellingPrice.toInt() * qty[i]);

        totalqty.add(qty[i]);
      });
    }

    setState(() {
      totalQtyBasedPrice1 =
          totalQtyBasedPrice.reduce((value, element) => value + element);

      totalqty1 = totalqty.reduce((value, element) => value + element);
    });

    print('totalQtyBasedPrice1 $totalQtyBasedPrice1');
  }

  List orderedFoods = [];

  late Future<MyFoodData> futureMyFoodData;

  late Future<List<FoodGetProducts>> futureFetchGetProducts;

  //  Future<void> getUserIdInSharedPreferences() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userId = prefs.getString("api_response").toString();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    totalQtyBasedPrice1 = 0;
    // futureMyFoodData = fetchMyFoodData(widget.foodId);
    // futureFetchGetProducts = fetchFoodGetProducts(widget.foodId);
    fetchFoodGetProducts1(widget.foodId).whenComplete(
      () => qty = List<int>.generate(foodGetProducts.length, (index) => 0),
      // null
    );
    fetchMyFoodData1(widget.foodId);

    // qty = List<int>.generate(foodGetProducts.length, (index) => 0);

    // calcTotalPriceWithResQty();
  }

  @override
  Widget build(BuildContext context) {
    // late int totalQuantity = 0;

    // int calcTotalQuantity() {
    //   totalQuantity = 0;
    //   for (var i = 0; i < qty.length; i++) {
    //     totalQuantity = totalQuantity + qty[i];
    //   }
    //   return totalQuantity;
    // }

    // int totalQuantity1 = calcTotalQuantity();

    // late int totalPrice = 0;

    // int calcTotalPrice() {
    //   totalPrice = 0;
    //   for (var i = 0; i < CustmyFoodData.length; i++) {
    //     totalPrice = totalPrice + int.parse(CustmyFoodData[i]['price']);
    //   }
    //   return totalPrice;
    // }

    // int totalPrice1 = calcTotalPrice();

    // calcTotalPriceWithResQty() {
    //   totalQuantity = 0;
    //   for (var i = 0; i < CustmyFoodData.length; i++) {
    //     setState(() {
    //       totalQtyBasedPrice = int.parse(CustmyFoodData[i]['price']) * qty[i];
    //     });
    //   }
    // }

    String selected = "";

    final themeData = Theme.of(context);

    Widget customRadioBtn(String name, String index) {
      return GestureDetector(
          onTap: () {
            setState(() {
              selected = index;
            });

            print('radio1');
            print(selected);
          },
          child: (selected == 'veg')
              ? Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (selected == 'veg') ? primaryColor : Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      color: (selected == 'veg') ? Colors.blue : primaryColor,
                    ),
                  ),
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      color: (selected == 'veg') ? Colors.white : primaryColor,
                    ),
                  ),
                )
              : (selected == 'nonveg')
                  ? Container(
                      width: 100,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (selected == 'nonveg')
                            ? primaryColor
                            : Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(
                          color: (selected == 'nonveg')
                              ? Colors.blue
                              : primaryColor,
                        ),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          color: (selected == 'nonveg')
                              ? Colors.white
                              : primaryColor,
                        ),
                      ),
                    )
                  : (selected == 'egg')
                      ? Container(
                          width: 100,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: (selected == 'egg')
                                ? primaryColor
                                : Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: (selected == 'egg')
                                  ? Colors.blue
                                  : primaryColor,
                            ),
                          ),
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                              color: (selected == 'egg')
                                  ? Colors.white
                                  : primaryColor,
                            ),
                          ),
                        )
                      : const SizedBox());
    }

    return Scaffold(
      // backgroundColor: const Color(0xff870081),
      // backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xff870081),
      // ),
      body: SingleChildScrollView(
        child: loadingFetchMyFoodData && loadingFetchFoodGetProducts
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        color: const Color(0xff870081),
                      ),
                      Column(
                        children: [
                          Container(
                            height: 100,
                          ),
                          Container(
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 70,
                                      ),
                                      Text(
                                        // snapshot.data!.businessName
                                        //     .toString(),

                                        myFoodData.businessName.toString(),
                                        style: themeData.textTheme.titleLarge,
                                      ),
                                      Text(
                                        // snapshot.data!.streetName
                                        //     .toString(),

                                        myFoodData.streetName.toString(),
                                        style: themeData.textTheme.titleMedium,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 3,
                                          right: 1,
                                        ),
                                        decoration: const BoxDecoration(
                                            color: Color(0xff870081),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "4.3",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: .5,
                                            ),
                                            Icon(Icons.star,
                                                size: 13, color: Colors.white),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Delivery within ',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                            text: '${10} min',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                              text: ' to',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text: ' ${20} min',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w500))
                                        ]),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const Divider(
                                        thickness: BorderSide.strokeAlignCenter,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      // Text(snapshot.data!.foodId.toString()),
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceAround,
                                      //   children: [
                                      //     // customRadioBtn("Veg", "veg"),
                                      //     // customRadioBtn("Non Veg", "nonveg"),
                                      //     // customRadioBtn("Egg", "egg"),
                                      //   ],
                                      // ),
                                      // const SizedBox(
                                      //   height: 15,
                                      // ),
                                      // const SizedBox(
                                      //   height: 15,
                                      // ),
                                    ],
                                  ),
                                ),

                                // foodItemBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 50,
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              image: DecorationImage(
                                image: NetworkImage(
                                  myFoodData.profile.toString(),
                                ),

                                // fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Container(
                  //   height: 300,

                  //   color: Color(0xff870081),
                  //   // color: Colors.white,
                  // ),

                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Food Items',
                      style: TextStyle(
                          // leadingDistribution: TextLeadingDistribution.even,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xE6434343)),
                    ),
                  ),

                  // Text(foodGetProducts.length.toString()),

                  Column(
                    children: [
                      //  Text('data'),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: foodGetProducts.length,
                        controller: ScrollController(),
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 15,
                                childAspectRatio: 2.1),
                        itemBuilder: (context, index) {
                          return Container(
                            // padding: const EdgeInsets.only(top: 7),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
//  Text(foodGetProducts.length.toString()),

                                      // Text(foods![index].foodId.toString()),
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              // image: AssetImage(
                                              //     'assets/images/appliances.jpeg'),

                                              image: NetworkImage(
                                                // foods![index]
                                                foodGetProducts[index]
                                                    .product
                                                    .primaryImage
                                                    .toString(),
                                              ),
                                              fit: BoxFit.fill,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  updateValueDec(index);

                                                  calcTotalPriceWithResQty();
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xff870081),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5),
                                                      bottomLeft:
                                                          Radius.circular(5),
                                                    ),
                                                  ),
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 35,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff870081))),
                                                child: Text(
                                                  // _quantity
                                                  //     .toString(),
                                                  qty[index].toString(),
                                                  style: const TextStyle(
                                                      color: Color(0xff870081),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  updateValueInc(index);

                                                  calcTotalPriceWithResQty();
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              Color(0xff870081),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          )),
                                                  height: 30,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "+",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        // flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // "Chiken Manchurian",
                                              foodGetProducts[index]
                                                  .product
                                                  .name[0],
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 19,
                                                color: Color(0xE6434343),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              // "₹150",
                                              '₹ ${foodGetProducts[index].product.sellingPrice}',
                                              style: const TextStyle(
                                                  fontSize: 19,
                                                  color: Color(0xE6434343)),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20))),
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30.0),
                                                          child: Column(
                                                            children: [
                                                              // temperory used for description
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child: Image.network(
                                                                    foodGetProducts[
                                                                            index]
                                                                        .product
                                                                        .primaryImage),
                                                              ),
                                                              const SizedBox(
                                                                height: 50,
                                                              ),
                                                              Text(
                                                                foodGetProducts[
                                                                        index]
                                                                    .product
                                                                    .otherImages[0],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Text(
                                                // temperory used for description

                                                foodGetProducts[index]
                                                    .product
                                                    .otherImages[0],

                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xE6434343)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.white),
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const OrderSuccess()));

                bottomDetailsScreen(
                    context: context,
                    qtyB: totalqty1,
                    priceB: totalQtyBasedPrice1,
                    deliveryB: 50);
              },
              child:
                  // Text(
                  //   '$totalqty1 Items | ₹ ${totalQtyBasedPrice1}',
                  //   style: TextStyle(color: Colors.purple, fontSize: 18),
                  // ),

                  AutoSizeText(
                '$totalqty1 Items | ₹ ${totalQtyBasedPrice1 + (totalQtyBasedPrice1 == 0 ? 0 : 0)}',
                minFontSize: 18,
                maxFontSize: 24,
                maxLines: 1, // Adjust this value as needed
                overflow: TextOverflow.ellipsis, // Handle overflow text
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(250, 50)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                )),
                backgroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              onPressed: () {
                print('orderedFoods : $orderedFoods');

                addToCartAllSelectedProductsLoop();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => OrderingFor(
                //               totalPrice: totalQtyBasedPrice1,
                //               totalQty: totalqty1,
                //               selectedFoods: orderedFoods,
                //               qty: qty, productCategory: 'food',
                //             )));

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => MyCart(
                //               selectedFoods: orderedFoods,
                //             )));
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

bottomDetailsScreen({
  required BuildContext context,
  required int qtyB,
  required int priceB,
  required int deliveryB,
}) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Details',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price ($qtyB Items)',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ $priceB',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Fees)',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ $deliveryB',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order Total',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    const Text(' : '),
                    Text(
                      '₹ ${priceB + deliveryB}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
