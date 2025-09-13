// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShoppingListResponse _$ShoppingListResponseFromJson(Map<String, dynamic> json) {
  return _ShoppingListResponse.fromJson(json);
}

/// @nodoc
mixin _$ShoppingListResponse {
  bool get success => throw _privateConstructorUsedError;
  List<ShoppingListItem> get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ShoppingListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingListResponseCopyWith<ShoppingListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListResponseCopyWith<$Res> {
  factory $ShoppingListResponseCopyWith(
    ShoppingListResponse value,
    $Res Function(ShoppingListResponse) then,
  ) = _$ShoppingListResponseCopyWithImpl<$Res, ShoppingListResponse>;
  @useResult
  $Res call({bool success, List<ShoppingListItem> data, String? error});
}

/// @nodoc
class _$ShoppingListResponseCopyWithImpl<
  $Res,
  $Val extends ShoppingListResponse
>
    implements $ShoppingListResponseCopyWith<$Res> {
  _$ShoppingListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<ShoppingListItem>,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShoppingListResponseImplCopyWith<$Res>
    implements $ShoppingListResponseCopyWith<$Res> {
  factory _$$ShoppingListResponseImplCopyWith(
    _$ShoppingListResponseImpl value,
    $Res Function(_$ShoppingListResponseImpl) then,
  ) = __$$ShoppingListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<ShoppingListItem> data, String? error});
}

/// @nodoc
class __$$ShoppingListResponseImplCopyWithImpl<$Res>
    extends _$ShoppingListResponseCopyWithImpl<$Res, _$ShoppingListResponseImpl>
    implements _$$ShoppingListResponseImplCopyWith<$Res> {
  __$$ShoppingListResponseImplCopyWithImpl(
    _$ShoppingListResponseImpl _value,
    $Res Function(_$ShoppingListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ShoppingListResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<ShoppingListItem>,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingListResponseImpl implements _ShoppingListResponse {
  const _$ShoppingListResponseImpl({
    required this.success,
    required final List<ShoppingListItem> data,
    this.error,
  }) : _data = data;

  factory _$ShoppingListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListResponseImplFromJson(json);

  @override
  final bool success;
  final List<ShoppingListItem> _data;
  @override
  List<ShoppingListItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'ShoppingListResponse(success: $success, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    error,
  );

  /// Create a copy of ShoppingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListResponseImplCopyWith<_$ShoppingListResponseImpl>
  get copyWith =>
      __$$ShoppingListResponseImplCopyWithImpl<_$ShoppingListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListResponseImplToJson(this);
  }
}

abstract class _ShoppingListResponse implements ShoppingListResponse {
  const factory _ShoppingListResponse({
    required final bool success,
    required final List<ShoppingListItem> data,
    final String? error,
  }) = _$ShoppingListResponseImpl;

  factory _ShoppingListResponse.fromJson(Map<String, dynamic> json) =
      _$ShoppingListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<ShoppingListItem> get data;
  @override
  String? get error;

  /// Create a copy of ShoppingListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingListResponseImplCopyWith<_$ShoppingListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return _ShoppingListItem.fromJson(json);
}

/// @nodoc
mixin _$ShoppingListItem {
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_name')
  String get itemName => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  String get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_id')
  int get categoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'category_name')
  String get categoryName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_purchased')
  bool get isPurchased => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_ai_suggestion')
  bool get isAiSuggestion => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;

  /// Serializes this ShoppingListItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShoppingListItemCopyWith<ShoppingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListItemCopyWith<$Res> {
  factory $ShoppingListItemCopyWith(
    ShoppingListItem value,
    $Res Function(ShoppingListItem) then,
  ) = _$ShoppingListItemCopyWithImpl<$Res, ShoppingListItem>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') int userId,
    @JsonKey(name: 'item_name') String itemName,
    String note,
    String quantity,
    String unit,
    int id,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'is_purchased') bool isPurchased,
    @JsonKey(name: 'is_ai_suggestion') bool isAiSuggestion,
    int timestamp,
  });
}

/// @nodoc
class _$ShoppingListItemCopyWithImpl<$Res, $Val extends ShoppingListItem>
    implements $ShoppingListItemCopyWith<$Res> {
  _$ShoppingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? itemName = null,
    Object? note = null,
    Object? quantity = null,
    Object? unit = null,
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? isPurchased = null,
    Object? isAiSuggestion = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
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
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as int,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            isPurchased: null == isPurchased
                ? _value.isPurchased
                : isPurchased // ignore: cast_nullable_to_non_nullable
                      as bool,
            isAiSuggestion: null == isAiSuggestion
                ? _value.isAiSuggestion
                : isAiSuggestion // ignore: cast_nullable_to_non_nullable
                      as bool,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShoppingListItemImplCopyWith<$Res>
    implements $ShoppingListItemCopyWith<$Res> {
  factory _$$ShoppingListItemImplCopyWith(
    _$ShoppingListItemImpl value,
    $Res Function(_$ShoppingListItemImpl) then,
  ) = __$$ShoppingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') int userId,
    @JsonKey(name: 'item_name') String itemName,
    String note,
    String quantity,
    String unit,
    int id,
    @JsonKey(name: 'category_id') int categoryId,
    @JsonKey(name: 'category_name') String categoryName,
    @JsonKey(name: 'is_purchased') bool isPurchased,
    @JsonKey(name: 'is_ai_suggestion') bool isAiSuggestion,
    int timestamp,
  });
}

/// @nodoc
class __$$ShoppingListItemImplCopyWithImpl<$Res>
    extends _$ShoppingListItemCopyWithImpl<$Res, _$ShoppingListItemImpl>
    implements _$$ShoppingListItemImplCopyWith<$Res> {
  __$$ShoppingListItemImplCopyWithImpl(
    _$ShoppingListItemImpl _value,
    $Res Function(_$ShoppingListItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? itemName = null,
    Object? note = null,
    Object? quantity = null,
    Object? unit = null,
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? isPurchased = null,
    Object? isAiSuggestion = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$ShoppingListItemImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
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
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as int,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        isPurchased: null == isPurchased
            ? _value.isPurchased
            : isPurchased // ignore: cast_nullable_to_non_nullable
                  as bool,
        isAiSuggestion: null == isAiSuggestion
            ? _value.isAiSuggestion
            : isAiSuggestion // ignore: cast_nullable_to_non_nullable
                  as bool,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingListItemImpl implements _ShoppingListItem {
  const _$ShoppingListItemImpl({
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'item_name') required this.itemName,
    required this.note,
    required this.quantity,
    required this.unit,
    required this.id,
    @JsonKey(name: 'category_id') required this.categoryId,
    @JsonKey(name: 'category_name') required this.categoryName,
    @JsonKey(name: 'is_purchased') required this.isPurchased,
    @JsonKey(name: 'is_ai_suggestion') required this.isAiSuggestion,
    required this.timestamp,
  });

  factory _$ShoppingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListItemImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'item_name')
  final String itemName;
  @override
  final String note;
  @override
  final String quantity;
  @override
  final String unit;
  @override
  final int id;
  @override
  @JsonKey(name: 'category_id')
  final int categoryId;
  @override
  @JsonKey(name: 'category_name')
  final String categoryName;
  @override
  @JsonKey(name: 'is_purchased')
  final bool isPurchased;
  @override
  @JsonKey(name: 'is_ai_suggestion')
  final bool isAiSuggestion;
  @override
  final int timestamp;

  @override
  String toString() {
    return 'ShoppingListItem(userId: $userId, itemName: $itemName, note: $note, quantity: $quantity, unit: $unit, id: $id, categoryId: $categoryId, categoryName: $categoryName, isPurchased: $isPurchased, isAiSuggestion: $isAiSuggestion, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListItemImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.itemName, itemName) ||
                other.itemName == itemName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.isPurchased, isPurchased) ||
                other.isPurchased == isPurchased) &&
            (identical(other.isAiSuggestion, isAiSuggestion) ||
                other.isAiSuggestion == isAiSuggestion) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    itemName,
    note,
    quantity,
    unit,
    id,
    categoryId,
    categoryName,
    isPurchased,
    isAiSuggestion,
    timestamp,
  );

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      __$$ShoppingListItemImplCopyWithImpl<_$ShoppingListItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListItemImplToJson(this);
  }
}

abstract class _ShoppingListItem implements ShoppingListItem {
  const factory _ShoppingListItem({
    @JsonKey(name: 'user_id') required final int userId,
    @JsonKey(name: 'item_name') required final String itemName,
    required final String note,
    required final String quantity,
    required final String unit,
    required final int id,
    @JsonKey(name: 'category_id') required final int categoryId,
    @JsonKey(name: 'category_name') required final String categoryName,
    @JsonKey(name: 'is_purchased') required final bool isPurchased,
    @JsonKey(name: 'is_ai_suggestion') required final bool isAiSuggestion,
    required final int timestamp,
  }) = _$ShoppingListItemImpl;

  factory _ShoppingListItem.fromJson(Map<String, dynamic> json) =
      _$ShoppingListItemImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'item_name')
  String get itemName;
  @override
  String get note;
  @override
  String get quantity;
  @override
  String get unit;
  @override
  int get id;
  @override
  @JsonKey(name: 'category_id')
  int get categoryId;
  @override
  @JsonKey(name: 'category_name')
  String get categoryName;
  @override
  @JsonKey(name: 'is_purchased')
  bool get isPurchased;
  @override
  @JsonKey(name: 'is_ai_suggestion')
  bool get isAiSuggestion;
  @override
  int get timestamp;

  /// Create a copy of ShoppingListItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
