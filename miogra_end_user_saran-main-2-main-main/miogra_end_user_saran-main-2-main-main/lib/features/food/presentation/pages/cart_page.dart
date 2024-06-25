import 'package:flutter/material.dart';
import 'package:miogra/features/food/presentation/pages/products_selected.dart';
import 'package:provider/provider.dart';
import 'package:miogra/features/food/presentation/pages/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  
  void removeItemFromCart(BuildContext context, Product product) {

    context.read<Shop>().removeFromCart(product);
  }

  @override
  Widget build(BuildContext context) {
    
    final cart = context.watch<Shop>().cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Page"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: cart.length,
                  itemBuilder: (context, index) {
                    final item = cart[index];

                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(item.price.toStringAsFixed(2)),
                      trailing: IconButton(
                          onPressed: () => removeItemFromCart(context, item),
                          icon: Icon(Icons.remove)),
                    );
                  }))
        ],
      ),
    );
  }
}
