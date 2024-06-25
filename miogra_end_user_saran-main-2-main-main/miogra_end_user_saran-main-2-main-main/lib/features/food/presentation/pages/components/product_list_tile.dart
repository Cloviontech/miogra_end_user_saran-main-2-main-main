import 'package:flutter/material.dart';

class ProductListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function ()? onTap;
  const ProductListTile({super.key, required this.text, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey,),
      title: Text(text),
      onTap: onTap,
    );
  }
}