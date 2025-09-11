import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/core.dart';
import 'package:advanced_shopping_list_frontend/ui/widgets/widgets.dart';

class AiSuggestionsScreen extends StatefulWidget {
  final String userId;

  const AiSuggestionsScreen({super.key, required this.userId});

  @override
  State<AiSuggestionsScreen> createState() => _AiSuggestionsScreenState();
}

class _AiSuggestionsScreenState extends State<AiSuggestionsScreen> {
  /// Groups shopping list items by category
  Map<String, List<ShoppingListItem>> _groupItemsByCategory(List<ShoppingListItem> items) {
    final Map<String, List<ShoppingListItem>> groupedItems = {};
    
    for (final item in items) {
      final categoryName = item.categoryName;
      if (groupedItems[categoryName] == null) {
        groupedItems[categoryName] = [];
      }
      groupedItems[categoryName]!.add(item);
    }
    
    return groupedItems;
  }

  /// Returns an appropriate icon for the given category
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'sports':
        return Icons.sports_football;
      case 'food':
      case 'groceries':
        return Icons.fastfood;
      case 'clothing':
      case 'apparel':
        return Icons.shopping_bag;
      case 'electronics':
        return Icons.devices;
      case 'health':
      case 'pharmacy':
        return Icons.local_pharmacy;
      case 'home':
      case 'household':
        return Icons.home;
      case 'books':
        return Icons.book;
      case 'automotive':
      case 'car':
        return Icons.directions_car;
      case 'toys':
        return Icons.toys;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  @override
  void initState() {
    super.initState();
    // Load shopping list when screen initializes
    context.read<ShoppingListBloc>().add(LoadShoppingList(userId: widget.userId));
  }

  Future<void> _onRefresh() async {
    context.read<ShoppingListBloc>().add(RefreshShoppingList(userId: widget.userId));
  }

  void _addToLocalList(ShoppingListItem item) {
    final localItem = LocalShoppingListItem.fromApiModel(
      itemName: item.itemName,
      note: item.note,
      quantity: item.quantity,
      unit: item.unit,
      categoryName: item.categoryName,
    );

    context.read<LocalShoppingListBloc>().add(
      AddLocalShoppingListItem(item: localItem),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.itemName} added to your shopping list'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
            if (state is ShoppingListLoading) {
              return const ShoppingListShimmer();
            } else if (state is ShoppingListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<ShoppingListBloc>().add(
                        LoadShoppingList(userId: widget.userId),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
                  } else if (state is ShoppingListLoaded || state is ShoppingListItemUpdating || state is ShoppingListInserting) {
                    final items = state is ShoppingListLoaded 
                        ? state.items 
                        : state is ShoppingListItemUpdating
                        ? state.items
                        : (state as ShoppingListInserting).items;
              
              if (items.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No AI suggestions available',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pull down to refresh',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              final groupedItems = _groupItemsByCategory(items);
              final categories = groupedItems.keys.toList()..sort();

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: categories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = categories[categoryIndex];
                    final categoryItems = groupedItems[category]!;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getCategoryIcon(category),
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${categoryItems.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                              // Category items
                              ...categoryItems.map((item) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                elevation: 2,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    child: const Icon(
                                      Icons.lightbulb,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    item.itemName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (item.note.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Note: ${item.note}',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      if (item.quantity.isNotEmpty && item.quantity != "Not specified") ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              'Quantity: ${item.quantity}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                            ),
                                            if (item.unit.isNotEmpty) ...[
                                              const SizedBox(width: 4),
                                              Text(
                                                item.unit,
                                                style: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add_shopping_cart),
                                    onPressed: () => _addToLocalList(item),
                                    color: Theme.of(context).primaryColor,
                                    tooltip: 'Add to shopping list',
                                  ),
                                ),
                              )),
                        
                        // Add spacing between categories
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
