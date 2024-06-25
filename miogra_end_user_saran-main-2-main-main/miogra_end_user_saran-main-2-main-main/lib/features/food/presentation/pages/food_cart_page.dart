import 'package:flutter/material.dart';
import 'package:miogra/features/food/models_foods/category_based_food_model.dart';
import 'package:miogra/features/food/presentation/pages/food_data/food_data.dart';
import 'package:provider/provider.dart';

class FoodCartPage extends StatelessWidget {
  const FoodCartPage({super.key});

  void removeItemFromCart(BuildContext context, CategoryBasedFood product) {
    context.read<Fooddata>().removeFromCart(product);
  }

  void removeItemFromCartWithQuantity(
      BuildContext context, Map<String, dynamic> productWithQuantity) {
    context.read<Fooddata>().removeFromCartWithQuantity(productWithQuantity);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Fooddata>().cart;

    final cartwithQuantity = context.watch<Fooddata>().cartwithQuantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Cart Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child:
                // ListView.builder(
                //     itemCount: cart.length,
                //     itemBuilder: (context, index) {
                //       final item = cart[index];

                //       return ListTile(
                //         title: Text(item.product!.modelName.toString()),
                //         subtitle: Text(item.product!.price!.toString()),
                //         trailing: IconButton(
                //             onPressed: () => removeItemFromCart(context, item),
                //             icon: Icon(Icons.remove)),
                //       );
                //     }),

                //

                ListView.builder(
                    itemCount: cartwithQuantity.length,
                    itemBuilder: (context, index) {
                      final item = cartwithQuantity[index];

                      return ListTile(
                        title: Text(item['productName'].product.modelName),
                        subtitle: Text(item['quantity'].toString()),
                        trailing: IconButton(
                            onPressed: () =>
                                // removeItemFromCart(context, item),
                                removeItemFromCartWithQuantity(context, item),
                            icon: Icon(Icons.remove)),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
