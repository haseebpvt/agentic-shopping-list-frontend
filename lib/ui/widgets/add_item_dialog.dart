import 'package:flutter/material.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';

class AddEditItemBottomSheet extends StatefulWidget {
  final LocalShoppingListItem? item; // null for add mode, item for edit mode

  const AddEditItemBottomSheet({super.key, this.item});

  @override
  State<AddEditItemBottomSheet> createState() => _AddEditItemBottomSheetState();
}

class _AddEditItemBottomSheetState extends State<AddEditItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _noteController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  
  String _selectedCategory = 'Groceries';
  
  bool get _isEditMode => widget.item != null;
  
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
    'Bakery and Desserts',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _initializeForEdit();
    }
  }

  void _initializeForEdit() {
    final item = widget.item!;
    _itemNameController.text = item.itemName;
    _noteController.text = item.note;
    _quantityController.text = item.quantity == "Not specified" ? "" : item.quantity;
    _unitController.text = item.unit;
    
    // Check if the item's category exists in our predefined list
    if (_categories.contains(item.categoryName)) {
      _selectedCategory = item.categoryName;
    } else {
      // If the category doesn't exist, add it to the list
      _categories.add(item.categoryName);
      _selectedCategory = item.categoryName;
    }
  }

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
      final item = _isEditMode
          ? widget.item!.copyWith(
              itemName: _itemNameController.text.trim(),
              note: _noteController.text.trim(),
              quantity: _quantityController.text.trim().isEmpty 
                  ? 'Not specified' 
                  : _quantityController.text.trim(),
              unit: _unitController.text.trim(),
              categoryName: _selectedCategory,
            )
          : LocalShoppingListItem.fromApiModel(
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
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _isEditMode ? 'Edit Item' : 'Add New Item',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Form content
          Flexible(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _saveItem,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_isEditMode ? 'Update Item' : 'Add Item'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
