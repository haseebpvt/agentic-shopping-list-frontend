import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

@freezed
class ShoppingListResponse with _$ShoppingListResponse {
  const factory ShoppingListResponse({
    required bool success,
    required List<ShoppingListItem> data,
    String? error,
  }) = _ShoppingListResponse;

  factory ShoppingListResponse.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListResponseFromJson(json);
}

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const factory ShoppingListItem({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'item_name') required String itemName,
    required String note,
    required String quantity,
    required String unit,
    required int id,
    @JsonKey(name: 'category_id') required int categoryId,
    @JsonKey(name: 'category_name') required String categoryName,
    @JsonKey(name: 'is_purchased') required bool isPurchased,
    @JsonKey(name: 'is_ai_suggestion') required bool isAiSuggestion,
    required int timestamp,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);
}
