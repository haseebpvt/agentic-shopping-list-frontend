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
  final TextEditingController _messageController = TextEditingController();
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onSubmitMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ShoppingListBloc>().add(
        InsertData(userId: widget.userId, userText: message),
      );
      _messageController.clear();
    }
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

    // Mark the item as purchased in the AI suggestions list
    context.read<ShoppingListBloc>().add(
      MarkItemPurchased(
        userId: widget.userId,
        itemId: item.id,
        isPurchased: true,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.itemName} added to your shopping list'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AI suggestions content
            Expanded(
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
                            color: Theme.of(context).colorScheme.error,
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
              
              // Filter out purchased items from the display
              final unpurchasedItems = items.where((item) => !item.isPurchased).toList();
              
              if (unpurchasedItems.isEmpty) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 64,
                                color: Theme.of(context).disabledColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                items.isEmpty 
                                    ? 'No AI suggestions available'
                                    : 'All suggestions added to cart',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pull down to refresh',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                  ),
                );
              }

              final groupedItems = _groupItemsByCategory(unpurchasedItems);
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
                                child: Container(
                                  decoration: item.isAiSuggestion ? BoxDecoration(
                                    border: Border.all(
                                      color: Colors.amber.shade400,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ) : null,
                                  child: ListTile(
                                  onLongPress: () async {
                                    // Show confirmation dialog for deletion
                                    final confirmed = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Suggestion'),
                                        content: Text(
                                          'Are you sure you want to delete "${item.itemName}" from AI suggestions?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(true),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Theme.of(context).colorScheme.error,
                                            ),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    if (confirmed == true) {
                                      context.read<ShoppingListBloc>().add(
                                        DeleteShoppingListItem(
                                          userId: widget.userId,
                                          itemId: item.id,
                                        ),
                                      );
                                    }
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: item.isAiSuggestion 
                                        ? Colors.amber.shade400 
                                        : Theme.of(context).colorScheme.secondary,
                                    child: Icon(
                                      item.isAiSuggestion ? Icons.auto_awesome : Icons.lightbulb,
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
                                      // AI Suggestion Badge
                                      if (item.isAiSuggestion) ...[
                                        const SizedBox(height: 4),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.amber.shade400),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.auto_awesome,
                                                size: 14,
                                                color: Colors.amber.shade700,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'AI Suggestion',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.amber.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      if (item.note.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          'Note: ${item.note}',
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      if (item.quantity.isNotEmpty && item.quantity != "Not specified") ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Quantity: ${item.quantity}${item.unit.isNotEmpty ? ' ${item.unit}' : ''}',
                                                style: TextStyle(
                                                  color: Theme.of(context).hintColor,
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
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
            
            // AI input field at bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                builder: (context, state) {
                  final isInserting = state is ShoppingListInserting;
                  
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Text field
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !isInserting,
                            decoration: InputDecoration(
                              hintText: isInserting ? 'Getting suggestions...' : 'Ask AI for suggestions...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            maxLines: null,
                            onSubmitted: isInserting ? null : (_) => _onSubmitMessage(),
                          ),
                        ),
                        // Submit button
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: isInserting ? null : _onSubmitMessage,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isInserting 
                                    ? Theme.of(context).disabledColor 
                                    : Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: isInserting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
