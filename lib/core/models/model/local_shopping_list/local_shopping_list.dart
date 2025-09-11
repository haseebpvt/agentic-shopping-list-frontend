import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_shopping_list.freezed.dart';
part 'local_shopping_list.g.dart';

@freezed
class LocalShoppingListItem with _$LocalShoppingListItem {
  const factory LocalShoppingListItem({
    int? id, // Local database ID
    required String itemName,
    required String note,
    required String quantity,
    required String unit,
    required String categoryName,
    @Default(false) bool isPurchased,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _LocalShoppingListItem;

  factory LocalShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$LocalShoppingListItemFromJson(json);

  // Convert from API model to local model
  factory LocalShoppingListItem.fromApiModel({
    required String itemName,
    required String note,
    required String quantity,
    required String unit,
    required String categoryName,
  }) {
    return LocalShoppingListItem(
      itemName: itemName,
      note: note,
      quantity: quantity,
      unit: unit,
      categoryName: categoryName,
      createdAt: DateTime.now(),
    );
  }

  // Create from database map
  factory LocalShoppingListItem.fromDbMap(Map<String, dynamic> map) {
    return LocalShoppingListItem(
      id: map['id'] as int?,
      itemName: map['item_name'] as String,
      note: map['note'] as String,
      quantity: map['quantity'] as String,
      unit: map['unit'] as String,
      categoryName: map['category_name'] as String,
      isPurchased: (map['is_purchased'] as int) == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updatedAt: map['updated_at'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : null,
    );
  }
}

// Extension to add toDbMap functionality
extension LocalShoppingListItemExtension on LocalShoppingListItem {
  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'item_name': itemName,
      'note': note,
      'quantity': quantity,
      'unit': unit,
      'category_name': categoryName,
      'is_purchased': isPurchased ? 1 : 0,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }
}
