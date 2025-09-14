import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:advanced_shopping_list_frontend/core/services/api_service.dart';
import 'package:advanced_shopping_list_frontend/core/services/local_shopping_list_service.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/local_shopping_list/local_shopping_list.dart';

class CategoryIdentificationService {
  final ApiService _apiService;
  final LocalShoppingListService _localService;
  final VoidCallback? _onCategoryUpdated;

  CategoryIdentificationService({
    required ApiService apiService,
    required LocalShoppingListService localService,
    VoidCallback? onCategoryUpdated,
  }) : _apiService = apiService, 
       _localService = localService,
       _onCategoryUpdated = onCategoryUpdated;

  /// Identify category for a specific item and update the database
  Future<void> identifyItemCategory(LocalShoppingListItem item) async {
    await _identifyAndUpdateItemCategory(item);
  }

  /// Process all items that don't have category IDs
  Future<void> identifyAllUncategorizedItems() async {
    try {
      // Get items without category IDs
      final itemsWithoutCategories = await _localService.getItemsWithoutCategoryId();
      
      if (itemsWithoutCategories.isEmpty) {
        return; // Nothing to process
      }

      print("🔄 Processing ${itemsWithoutCategories.length} uncategorized items");

      // Process each item
      for (final item in itemsWithoutCategories) {
        await _identifyAndUpdateItemCategory(item);
        
        // Add a small delay between requests to avoid overwhelming the API
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      print("❌ Error in uncategorized items identification: $e");
    }
  }

  /// Identify category for a specific item and update the database
  Future<void> _identifyAndUpdateItemCategory(LocalShoppingListItem item) async {
    try {
      if (item.id == null) {
        print("⚠️ Skipping item without ID: ${item.itemName}");
        return;
      }

      print("🔍 Identifying category for item: ${item.itemName}");
      
      // Call the API to identify the category
      final categoryResponse = await _apiService.identifyCategory(item.itemName);
      
      if (categoryResponse.success && categoryResponse.data.categories.isNotEmpty) {
        final category = categoryResponse.data.categories.first;
        
        print("✅ Category identified for '${item.itemName}': ${category.name} (ID: ${category.id})");
        
        // Store the category in local database
        await _localService.storeCategory(category.id, category.name);
        
        // Update the item with the category information
        await _localService.updateItemCategoryId(
          item.id!,
          category.id,
          category.name,
        );
        
        print("✅ Updated item '${item.itemName}' with category: ${category.name}");
        
        // Notify that a category was updated
        _onCategoryUpdated?.call();
      } else {
        print("⚠️ No category found for item: ${item.itemName}");
        
        // Still update the item to mark it as processed (even if no category found)
        // This prevents repeated API calls for items that can't be categorized
        await _localService.updateItemCategoryId(
          item.id!,
          -1, // Use -1 to indicate "no category found" vs null for "not processed"
          "Other", // Default category
        );
      }
    } catch (e) {
      print("❌ Error identifying category for '${item.itemName}': $e");
    }
  }

  /// Dispose of resources
  void dispose() {
    // No resources to dispose of anymore
  }
}
