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
    required int id,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);
}
