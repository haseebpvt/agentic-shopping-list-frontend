import 'package:flutter/material.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  
  String _selectedCategory = 'Groceries';
  
  final List<String> _categories = [
    'Groceries',
    'Electronics',
    'Clothing',
    'Health',
    'Home',
    'Sports',
    'Books',
    'Automotive',
    'Toys',
    'Beauty',
    'Food',
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _noteController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final item = LocalShoppingListItem.fromApiModel(
        itemName: _itemNameController.text.trim(),
        note: _noteController.text.trim(),
        quantity: _quantityController.text.trim().isEmpty 
            ? 'Not specified' 
            : _quantityController.text.trim(),
        unit: _unitController.text.trim(),
        categoryName: _selectedCategory,
      );

      Navigator.of(context).pop(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Item Name
              TextFormField(
                controller: _itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Quantity and Unit in a row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                        hintText: 'kg, pcs, etc.',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Note
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveItem,
          child: const Text('Add Item'),
        ),
      ],
    );
  }
}
