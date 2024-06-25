import 'package:flutter/material.dart';
import 'package:miogra/features/food/presentation/pages/food_data/food_data.dart';
import 'package:provider/provider.dart';

class CartPage1 extends StatelessWidget {
  const CartPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Fooddata>().productsInMainCart;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart 1'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(cart.length.toString()),
          Expanded(
            child: ListView.builder(
                // itemCount: cart.length,
                itemCount: 4,
                itemBuilder: (context, index) {
                  final item = cart[index];

                  return ListTile(
                    // title: Text(item[0][0].product.modelName.toString()),
                    // subtitle: Text(item[0][1].toString()),
                    title: Text(item.toString()),
                    // subtitle: Text(item[0][1].toString()),
                    trailing: IconButton(
                        onPressed: () {},
                        // removeItemFromCart(context, item),
                        // removeItemFromCartWithQuantity(context, item),
                        icon: Icon(Icons.remove)),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
