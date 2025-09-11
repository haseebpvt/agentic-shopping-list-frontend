// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LocalShoppingListItemImpl _$$LocalShoppingListItemImplFromJson(
  Map<String, dynamic> json,
) => _$LocalShoppingListItemImpl(
  id: (json['id'] as num?)?.toInt(),
  itemName: json['itemName'] as String,
  note: json['note'] as String,
  quantity: json['quantity'] as String,
  unit: json['unit'] as String,
  categoryName: json['categoryName'] as String,
  isPurchased: json['isPurchased'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$LocalShoppingListItemImplToJson(
  _$LocalShoppingListItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'itemName': instance.itemName,
  'note': instance.note,
  'quantity': instance.quantity,
  'unit': instance.unit,
  'categoryName': instance.categoryName,
  'isPurchased': instance.isPurchased,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
