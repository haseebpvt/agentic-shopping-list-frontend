import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:flutter/material.dart';

class SuggestedProductView extends StatelessWidget {
  final Product product;

  const SuggestedProductView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Name: ${product.name}"),
            Text("Reason for suggestion: ${product.reasonForSuggestion}"),
            Text("Note: ${product.note ?? "N/A"}"),
          ],
        ),
      ),
    );
  }
}
