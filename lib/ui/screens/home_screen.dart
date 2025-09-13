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
    // Check for uncategorized items and identify them
    context.read<LocalShoppingListBloc>().add(IdentifyUncategorizedItems());
    // Load AI suggestions for the count
    context.read<ShoppingListBloc>().add(LoadShoppingList(userId: _userId));
  }

  void _onCameraButtonPressed() {
    widget.onPageChange?.call(1);
  }

  Future<void> _onRefresh() async {
    context.read<LocalShoppingListBloc>().add(LoadLocalShoppingList());
    // Also check for uncategorized items on refresh
    context.read<LocalShoppingListBloc>().add(IdentifyUncategorizedItems());
    // Refresh AI suggestions count
    context.read<ShoppingListBloc>().add(RefreshShoppingList(userId: _userId));
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

  Future<void> _showAddItemBottomSheet({LocalShoppingListItem? item}) async {
    final result = await showModalBottomSheet<LocalShoppingListItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<CategoryBloc>(),
          ),
          BlocProvider.value(
            value: context.read<LocalShoppingListBloc>(),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom,
          ),
          child: AddEditItemBottomSheet(item: item),
        ),
      ),
    );

    if (result != null) {
      if (item == null) {
        // Add new item
        context.read<LocalShoppingListBloc>().add(
          AddLocalShoppingListItem(item: result),
        );
      } else {
        // Update existing item
        context.read<LocalShoppingListBloc>().add(
          UpdateLocalShoppingListItem(item: result),
        );
      }
    }
  }

  /// Builds an animated category list that smoothly handles reordering
  Widget _buildAnimatedCategoryList({
    required Map<String, List<LocalShoppingListItem>> groupedItems,
    required List<String> categories,
    required bool isReordering,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: ListView.builder(
        key: ValueKey(categories.join('_')), // Key changes when categories change order
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          final category = categories[categoryIndex];
          final categoryItems = groupedItems[category]!;
          
          return AnimatedContainer(
            duration: Duration(milliseconds: isReordering ? 400 : 200),
            curve: Curves.easeInOut,
            child: _buildCategorySection(
              category: category,
              categoryItems: categoryItems,
              isReordering: isReordering,
            ),
          );
        },
      ),
    );
  }

  /// Builds a single category section with its items
  Widget _buildCategorySection({
    required String category,
    required List<LocalShoppingListItem> categoryItems,
    required bool isReordering,
  }) {
    return Column(
      key: ValueKey('category_$category'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        AnimatedContainer(
          duration: Duration(milliseconds: isReordering ? 300 : 150),
          curve: Curves.easeInOut,
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
              AnimatedContainer(
                duration: Duration(milliseconds: isReordering ? 300 : 150),
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
        
        // Category items with animation
        ...categoryItems.map((item) => _buildAnimatedListItem(
          item: item,
          isReordering: isReordering,
        )),
        
        // Add spacing between categories
        const SizedBox(height: 16),
      ],
    );
  }

  /// Builds an animated circular checkbox
  Widget _buildAnimatedCircularCheckbox({
    required bool isChecked,
    required ValueChanged<bool?>? onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged?.call(!isChecked),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? const Color(0xFF4CAF50) : Colors.transparent,
          border: Border.all(
            color: isChecked ? const Color(0xFF4CAF50) : Colors.grey,
            width: 2,
          ),
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: isChecked ? 1.0 : 0.0,
          curve: Curves.elasticOut,
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }

  /// Builds an animated list item
  Widget _buildAnimatedListItem({
    required LocalShoppingListItem item,
    required bool isReordering,
  }) {
    return AnimatedContainer(
      key: ValueKey('item_${item.id}'),
      duration: Duration(milliseconds: isReordering ? 400 : 200),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 8),
      child: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: isReordering ? 400 : 200),
        tween: Tween<double>(begin: isReordering ? 0.8 : 1.0, end: 1.0),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Card(
                elevation: item.isPurchased ? 1 : 2,
                color: item.isPurchased 
                    ? Theme.of(context).cardColor.withOpacity(0.7)
                    : Theme.of(context).cardColor,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: item.isPurchased 
                        ? Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            width: 1,
                          )
                        : null,
                  ),
                  child: ListTile(
                onTap: () => _showAddItemBottomSheet(item: item),
                leading: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: CircleAvatar(
                    backgroundColor: item.isPurchased 
                        ? const Color(0xFF4CAF50) 
                        : Theme.of(context).primaryColor,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        item.isPurchased 
                            ? Icons.check 
                            : Icons.shopping_basket,
                        key: ValueKey(item.isPurchased ? 'check' : 'basket'),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                title: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    decoration: item.isPurchased 
                        ? TextDecoration.lineThrough 
                        : null,
                    color: item.isPurchased 
                        ? Theme.of(context).disabledColor 
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  child: Text(item.itemName),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          : _buildAnimatedCircularCheckbox(
                              isChecked: item.isPurchased,
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
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
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
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.secondaryContainer,
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'AI Suggestions',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  BlocBuilder<ShoppingListBloc, ShoppingListState>(
                                    builder: (context, state) {
                                      if (state is ShoppingListLoaded) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${state.items.length}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      } else if (state is ShoppingListLoading) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const SizedBox(
                                            width: 12,
                                            height: 12,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
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
                            onPressed: () => context.read<LocalShoppingListBloc>().add(
                              LoadLocalShoppingList(),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is LocalShoppingListLoaded || 
                           state is LocalShoppingListItemUpdating || 
                           state is LocalShoppingListReordering) {
                    final items = state is LocalShoppingListLoaded 
                        ? state.items 
                        : state is LocalShoppingListItemUpdating
                          ? state.items
                          : (state as LocalShoppingListReordering).newItems;
                    
                    if (items.isEmpty) {
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
                                    Icons.shopping_cart_outlined,
                                    size: 64,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No items in your shopping list',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add items using the + button below',
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

                    final groupedItems = _groupLocalItemsByCategory(items);
                    final categories = groupedItems.keys.toList();
                    
                    // Sort categories with "Other" at the top
                    categories.sort((a, b) {
                      if (a.toLowerCase() == 'other' || a.toLowerCase() == 'others') return -1;
                      if (b.toLowerCase() == 'other' || b.toLowerCase() == 'others') return 1;
                      return a.compareTo(b);
                    });

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: _buildAnimatedCategoryList(
                        groupedItems: groupedItems, 
                        categories: categories,
                        isReordering: state is LocalShoppingListReordering,
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            // Camera and Add item buttons at bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: _onCameraButtonPressed,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: const Icon(Icons.camera_alt),
                  ),
                  FloatingActionButton(
                    onPressed: () => _showAddItemBottomSheet(),
                    child: const Icon(Icons.add),
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
