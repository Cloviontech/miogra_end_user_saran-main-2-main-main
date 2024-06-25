import 'package:flutter/material.dart';
import 'package:miogra/features/food/presentation/pages/components/product_tile.dart';
import 'package:miogra/features/food/presentation/pages/products_selected.dart';
import 'package:provider/provider.dart';

class SelectProduct extends StatelessWidget {
  const SelectProduct({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<Shop>().shop;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Page"),
      ),
      body: ListView.builder(
          itemCount: products.length,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, index) {
            final product = products[index];

            // return as a product tile Ui

            return ProductTile(product: product);
          }),
    );
  }
}
