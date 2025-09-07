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
  id: (json['id'] as num).toInt(),
);

Map<String, dynamic> _$$ShoppingListItemImplToJson(
  _$ShoppingListItemImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'item_name': instance.itemName,
  'note': instance.note,
  'quantity': instance.quantity,
  'id': instance.id,
};
