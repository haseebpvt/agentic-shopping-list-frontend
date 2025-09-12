// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LocalShoppingListItem _$LocalShoppingListItemFromJson(
  Map<String, dynamic> json,
) {
  return _LocalShoppingListItem.fromJson(json);
}

/// @nodoc
mixin _$LocalShoppingListItem {
  int? get id => throw _privateConstructorUsedError; // Local database ID
  String get itemName => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  String get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError; // API category ID
  bool get isPurchased => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LocalShoppingListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocalShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocalShoppingListItemCopyWith<LocalShoppingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocalShoppingListItemCopyWith<$Res> {
  factory $LocalShoppingListItemCopyWith(
    LocalShoppingListItem value,
    $Res Function(LocalShoppingListItem) then,
  ) = _$LocalShoppingListItemCopyWithImpl<$Res, LocalShoppingListItem>;
  @useResult
  $Res call({
    int? id,
    String itemName,
    String note,
    String quantity,
    String unit,
    String categoryName,
    int? categoryId,
    bool isPurchased,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$LocalShoppingListItemCopyWithImpl<
  $Res,
  $Val extends LocalShoppingListItem
>
    implements $LocalShoppingListItemCopyWith<$Res> {
  _$LocalShoppingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocalShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? note = null,
    Object? quantity = null,
    Object? unit = null,
    Object? categoryName = null,
    Object? categoryId = freezed,
    Object? isPurchased = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            itemName: null == itemName
                ? _value.itemName
                : itemName // ignore: cast_nullable_to_non_nullable
                      as String,
            note: null == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as String,
            unit: null == unit
                ? _value.unit
                : unit // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: freezed == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int?,
            isPurchased: null == isPurchased
                ? _value.isPurchased
                : isPurchased // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LocalShoppingListItemImplCopyWith<$Res>
    implements $LocalShoppingListItemCopyWith<$Res> {
  factory _$$LocalShoppingListItemImplCopyWith(
    _$LocalShoppingListItemImpl value,
    $Res Function(_$LocalShoppingListItemImpl) then,
  ) = __$$LocalShoppingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String itemName,
    String note,
    String quantity,
    String unit,
    String categoryName,
    int? categoryId,
    bool isPurchased,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$LocalShoppingListItemImplCopyWithImpl<$Res>
    extends
        _$LocalShoppingListItemCopyWithImpl<$Res, _$LocalShoppingListItemImpl>
    implements _$$LocalShoppingListItemImplCopyWith<$Res> {
  __$$LocalShoppingListItemImplCopyWithImpl(
    _$LocalShoppingListItemImpl _value,
    $Res Function(_$LocalShoppingListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LocalShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? itemName = null,
    Object? note = null,
    Object? quantity = null,
    Object? unit = null,
    Object? categoryName = null,
    Object? categoryId = freezed,
    Object? isPurchased = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$LocalShoppingListItemImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        itemName: null == itemName
            ? _value.itemName
            : itemName // ignore: cast_nullable_to_non_nullable
                  as String,
        note: null == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as String,
        unit: null == unit
            ? _value.unit
            : unit // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: freezed == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int?,
        isPurchased: null == isPurchased
            ? _value.isPurchased
            : isPurchased // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LocalShoppingListItemImpl implements _LocalShoppingListItem {
  const _$LocalShoppingListItemImpl({
    this.id,
    required this.itemName,
    required this.note,
    required this.quantity,
    required this.unit,
    required this.categoryName,
    this.categoryId,
    this.isPurchased = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory _$LocalShoppingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocalShoppingListItemImplFromJson(json);

  @override
  final int? id;
  // Local database ID
  @override
  final String itemName;
  @override
  final String note;
  @override
  final String quantity;
  @override
  final String unit;
  @override
  final String categoryName;
  @override
  final int? categoryId;
  // API category ID
  @override
  @JsonKey()
  final bool isPurchased;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LocalShoppingListItem(id: $id, itemName: $itemName, note: $note, quantity: $quantity, unit: $unit, categoryName: $categoryName, categoryId: $categoryId, isPurchased: $isPurchased, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocalShoppingListItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.isPurchased, isPurchased) ||
                other.isPurchased == isPurchased) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    itemName,
    note,
    quantity,
    unit,
    categoryName,
    categoryId,
    isPurchased,
    createdAt,
    updatedAt,
  );

  /// Create a copy of LocalShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocalShoppingListItemImplCopyWith<_$LocalShoppingListItemImpl>
  get copyWith =>
      __$$LocalShoppingListItemImplCopyWithImpl<_$LocalShoppingListItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LocalShoppingListItemImplToJson(this);
  }
}

abstract class _LocalShoppingListItem implements LocalShoppingListItem {
  const factory _LocalShoppingListItem({
    final int? id,
    required final String itemName,
    required final String note,
    required final String quantity,
    required final String unit,
    required final String categoryName,
    final int? categoryId,
    final bool isPurchased,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$LocalShoppingListItemImpl;

  factory _LocalShoppingListItem.fromJson(Map<String, dynamic> json) =
      _$LocalShoppingListItemImpl.fromJson;

  @override
  int? get id; // Local database ID
  @override
  String get itemName;
  @override
  String get note;
  @override
  String get quantity;
  @override
  String get unit;
  @override
  String get categoryName;
  @override
  int? get categoryId; // API category ID
  @override
  bool get isPurchased;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of LocalShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocalShoppingListItemImplCopyWith<_$LocalShoppingListItemImpl>
  get copyWith => throw _privateConstructorUsedError;
}
