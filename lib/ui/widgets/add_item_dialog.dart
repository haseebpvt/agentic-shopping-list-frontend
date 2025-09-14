import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';
import 'package:advanced_shopping_list_frontend/core/bloc/category_bloc/category_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/category/category.dart';
import 'package:shimmer/shimmer.dart';

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
  
  String _selectedCategory = 'Others';
  
  bool get _isEditMode => widget.item != null;

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
    _selectedCategory = item.categoryName;
  }

  Category? _findCategoryByName(List<Category> categories, String name) {
    try {
      return categories.firstWhere((cat) => cat.name == name);
    } catch (e) {
      return null;
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
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                  
                  if (state is CategoryError) {
                    return Container(
                      height: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Failed to load categories',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                state.error,
                                style: const TextStyle(
                                  color: Colors.red, 
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<CategoryBloc>().add(const RefreshCategories());
                            },
                            child: const Text('Retry', style: TextStyle(fontSize: 10)),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is CategoryLoaded) {
                    final categories = state.categories;
                    
                    // Ensure selected category exists in the list
                    if (_isEditMode && _selectedCategory.isNotEmpty) {
                      final category = _findCategoryByName(categories, _selectedCategory);
                      if (category == null) {
                        // Fallback to first category if current doesn't exist
                        if (categories.isNotEmpty) {
                          _selectedCategory = categories.first.name;
                        }
                      }
                    } else if (categories.isNotEmpty && _selectedCategory == 'Others') {
                      // Set default to first category from API
                      final othersCategory = _findCategoryByName(categories, 'Others');
                      if (othersCategory != null) {
                        _selectedCategory = othersCategory.name;
                      } else {
                        _selectedCategory = categories.first.name;
                      }
                    }
                    
                    return DropdownButtonFormField<Category>(
                      initialValue: _findCategoryByName(categories, _selectedCategory),
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (Category? value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value.name;
                          });
                        }
                      },
                    );
                  }
                  
                  return const SizedBox.shrink();
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
