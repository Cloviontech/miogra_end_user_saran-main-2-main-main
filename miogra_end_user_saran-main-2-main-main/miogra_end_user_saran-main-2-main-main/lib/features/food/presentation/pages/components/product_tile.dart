import 'package:flutter/material.dart';
import 'package:miogra/features/food/presentation/pages/product.dart';
import 'package:miogra/features/food/presentation/pages/products_selected.dart';
import 'package:provider/provider.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  void addItemToCart (BuildContext context) {

    context.read<Shop>().addToCart(product);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.pink.shade400, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 300,
      child: Column(
        children: [
          // product image
          Icon(Icons.favorite_outline),

          Text(product.name),

          Text(product.description),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(product.price.toStringAsFixed(2)),
              IconButton(onPressed: () {
                addItemToCart(context);
              }, icon: Icon(Icons.add))
            ],
          )
        ],
      ),
    );
  }
}
