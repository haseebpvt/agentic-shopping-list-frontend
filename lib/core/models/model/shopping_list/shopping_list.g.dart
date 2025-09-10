// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListResponseImpl _$$ShoppingListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingListResponseImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'] as String?,
);

Map<String, dynamic> _$$ShoppingListResponseImplToJson(
  _$ShoppingListResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'error': instance.error,
};

_$ShoppingListItemImpl _$$ShoppingListItemImplFromJson(
  Map<String, dynamic> json,
) => _$ShoppingListItemImpl(
  userId: (json['user_id'] as num).toInt(),
  itemName: json['item_name'] as String,
  note: json['note'] as String,
  quantity: json['quantity'] as String,
  unit: json['unit'] as String,
  id: (json['id'] as num).toInt(),
  categoryId: (json['category_id'] as num).toInt(),
  categoryName: json['category_name'] as String,
  isPurchased: json['is_purchased'] as bool,
  timestamp: (json['timestamp'] as num).toInt(),
);

Map<String, dynamic> _$$ShoppingListItemImplToJson(
  _$ShoppingListItemImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'item_name': instance.itemName,
  'note': instance.note,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'id': instance.id,
  'category_id': instance.categoryId,
  'category_name': instance.categoryName,
  'is_purchased': instance.isPurchased,
  'timestamp': instance.timestamp,
};
