import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/core.dart';
import 'package:advanced_shopping_list_frontend/ui/screens/preferences_screen.dart';
import 'package:advanced_shopping_list_frontend/ui/screens/ai_suggestions_screen.dart';
import 'package:advanced_shopping_list_frontend/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onPageChange;
  
  const HomeScreen({super.key, this.onPageChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _messageController = TextEditingController();
  final String _userId = "8"; // For testing purposes, you can make this dynamic later

  /// Groups local shopping list items by category
  Map<String, List<LocalShoppingListItem>> _groupLocalItemsByCategory(List<LocalShoppingListItem> items) {
    final Map<String, List<LocalShoppingListItem>> groupedItems = {};
    
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
    // Load local shopping list when screen initializes
    context.read<LocalShoppingListBloc>().add(LoadLocalShoppingList());
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onCameraButtonPressed() {
    widget.onPageChange?.call(1);
  }

  Future<void> _onRefresh() async {
    context.read<LocalShoppingListBloc>().add(LoadLocalShoppingList());
  }

  void _openAiSuggestions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (newContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ShoppingListBloc>()),
            BlocProvider.value(value: context.read<LocalShoppingListBloc>()),
          ],
          child: AiSuggestionsScreen(userId: _userId),
        ),
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    final item = await showDialog<LocalShoppingListItem>(
      context: context,
      builder: (context) => const AddItemDialog(),
    );

    if (item != null) {
      context.read<LocalShoppingListBloc>().add(
        AddLocalShoppingListItem(item: item),
      );
    }
  }

  void _onSubmitMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ShoppingListBloc>().add(
        InsertData(userId: _userId, userText: message),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology),
            tooltip: 'Preferences',
            onPressed: () {
              // Get the API service from main.dart context by going up the widget tree
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (newContext) => MultiBlocProvider(
                    providers: [
                      // Provide all the same blocs that are available in main
                      BlocProvider.value(value: context.read<ProductSuggestionBloc>()),
                      BlocProvider.value(value: context.read<ShoppingListBloc>()),
                      BlocProvider.value(value: context.read<PreferenceListBloc>()),
                    ],
                    child: const PreferencesScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // AI Suggestions Banner
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                child: InkWell(
                  onTap: _openAiSuggestions,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.orange.shade600,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.lightbulb,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'AI Suggestions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Tap to view personalized suggestions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Shopping list content
            Expanded(
              child: BlocBuilder<LocalShoppingListBloc, LocalShoppingListState>(
                builder: (context, state) {
                  if (state is LocalShoppingListLoading) {
                    return const ShoppingListShimmer();
                  } else if (state is LocalShoppingListError) {
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
                            onPressed: () => context.read<LocalShoppingListBloc>().add(
                              LoadLocalShoppingList(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is LocalShoppingListLoaded || state is LocalShoppingListItemUpdating) {
                    final items = state is LocalShoppingListLoaded 
                        ? state.items 
                        : (state as LocalShoppingListItemUpdating).items;
                    
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
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No items in your shopping list',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Add items using the + button below',
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

                    final groupedItems = _groupLocalItemsByCategory(items);
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
                                    backgroundColor: item.isPurchased 
                                        ? Colors.green 
                                        : Theme.of(context).primaryColor,
                                    child: Icon(
                                      item.isPurchased 
                                          ? Icons.check 
                                          : Icons.shopping_basket,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    item.itemName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: item.isPurchased 
                                          ? TextDecoration.lineThrough 
                                          : null,
                                      color: item.isPurchased 
                                          ? Colors.grey.shade600 
                                          : null,
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
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      BlocBuilder<LocalShoppingListBloc, LocalShoppingListState>(
                                        builder: (context, state) {
                                          final isUpdating = state is LocalShoppingListItemUpdating && 
                                                            state.updatingItemId == item.id!;
                                          
                                          return isUpdating 
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Checkbox(
                                                value: item.isPurchased,
                                                onChanged: (bool? value) {
                                                  if (value != null && item.id != null) {
                                                    context.read<LocalShoppingListBloc>().add(
                                                      ToggleLocalItemPurchased(
                                                        id: item.id!,
                                                        isPurchased: value,
                                                      ),
                                                    );
                                                  }
                                                },
                                                activeColor: Colors.green,
                                              );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () {
                                          if (item.id != null) {
                                            context.read<LocalShoppingListBloc>().add(
                                              DeleteLocalShoppingListItem(id: item.id!),
                                            );
                                          }
                                        },
                                        color: Colors.red.shade400,
                                      ),
                                    ],
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
            // Message field at bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Text field for AI suggestions
                  Expanded(
                    child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                      builder: (context, state) {
                        final isInserting = state is ShoppingListInserting;
                        
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.grey.shade300,
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
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.camera_alt, size: 20),
                                      onPressed: isInserting ? null : _onCameraButtonPressed,
                                      color: Theme.of(context).primaryColor,
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
                                          ? Colors.grey.shade400 
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
                  const SizedBox(width: 12),
                  // Add item button
                  FloatingActionButton(
                    onPressed: _showAddItemDialog,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
