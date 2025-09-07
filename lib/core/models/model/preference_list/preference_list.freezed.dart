// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preference_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PreferenceListResponse _$PreferenceListResponseFromJson(
  Map<String, dynamic> json,
) {
  return _PreferenceListResponse.fromJson(json);
}

/// @nodoc
mixin _$PreferenceListResponse {
  bool get success => throw _privateConstructorUsedError;
  List<PreferenceItem> get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this PreferenceListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreferenceListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferenceListResponseCopyWith<PreferenceListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferenceListResponseCopyWith<$Res> {
  factory $PreferenceListResponseCopyWith(
    PreferenceListResponse value,
    $Res Function(PreferenceListResponse) then,
  ) = _$PreferenceListResponseCopyWithImpl<$Res, PreferenceListResponse>;
  @useResult
  $Res call({bool success, List<PreferenceItem> data, String? error});
}

/// @nodoc
class _$PreferenceListResponseCopyWithImpl<
  $Res,
  $Val extends PreferenceListResponse
>
    implements $PreferenceListResponseCopyWith<$Res> {
  _$PreferenceListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreferenceListResponse
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
                      as List<PreferenceItem>,
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
abstract class _$$PreferenceListResponseImplCopyWith<$Res>
    implements $PreferenceListResponseCopyWith<$Res> {
  factory _$$PreferenceListResponseImplCopyWith(
    _$PreferenceListResponseImpl value,
    $Res Function(_$PreferenceListResponseImpl) then,
  ) = __$$PreferenceListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<PreferenceItem> data, String? error});
}

/// @nodoc
class __$$PreferenceListResponseImplCopyWithImpl<$Res>
    extends
        _$PreferenceListResponseCopyWithImpl<$Res, _$PreferenceListResponseImpl>
    implements _$$PreferenceListResponseImplCopyWith<$Res> {
  __$$PreferenceListResponseImplCopyWithImpl(
    _$PreferenceListResponseImpl _value,
    $Res Function(_$PreferenceListResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreferenceListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(
      _$PreferenceListResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<PreferenceItem>,
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
class _$PreferenceListResponseImpl implements _PreferenceListResponse {
  const _$PreferenceListResponseImpl({
    required this.success,
    required final List<PreferenceItem> data,
    this.error,
  }) : _data = data;

  factory _$PreferenceListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferenceListResponseImplFromJson(json);

  @override
  final bool success;
  final List<PreferenceItem> _data;
  @override
  List<PreferenceItem> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'PreferenceListResponse(success: $success, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferenceListResponseImpl &&
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

  /// Create a copy of PreferenceListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferenceListResponseImplCopyWith<_$PreferenceListResponseImpl>
  get copyWith =>
      __$$PreferenceListResponseImplCopyWithImpl<_$PreferenceListResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferenceListResponseImplToJson(this);
  }
}

abstract class _PreferenceListResponse implements PreferenceListResponse {
  const factory _PreferenceListResponse({
    required final bool success,
    required final List<PreferenceItem> data,
    final String? error,
  }) = _$PreferenceListResponseImpl;

  factory _PreferenceListResponse.fromJson(Map<String, dynamic> json) =
      _$PreferenceListResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<PreferenceItem> get data;
  @override
  String? get error;

  /// Create a copy of PreferenceListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferenceListResponseImplCopyWith<_$PreferenceListResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PreferenceItem _$PreferenceItemFromJson(Map<String, dynamic> json) {
  return _PreferenceItem.fromJson(json);
}

/// @nodoc
mixin _$PreferenceItem {
  int get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;

  /// Serializes this PreferenceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreferenceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreferenceItemCopyWith<PreferenceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreferenceItemCopyWith<$Res> {
  factory $PreferenceItemCopyWith(
    PreferenceItem value,
    $Res Function(PreferenceItem) then,
  ) = _$PreferenceItemCopyWithImpl<$Res, PreferenceItem>;
  @useResult
  $Res call({int id, String text, @JsonKey(name: 'user_id') int userId});
}

/// @nodoc
class _$PreferenceItemCopyWithImpl<$Res, $Val extends PreferenceItem>
    implements $PreferenceItemCopyWith<$Res> {
  _$PreferenceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreferenceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? userId = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PreferenceItemImplCopyWith<$Res>
    implements $PreferenceItemCopyWith<$Res> {
  factory _$$PreferenceItemImplCopyWith(
    _$PreferenceItemImpl value,
    $Res Function(_$PreferenceItemImpl) then,
  ) = __$$PreferenceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String text, @JsonKey(name: 'user_id') int userId});
}

/// @nodoc
class __$$PreferenceItemImplCopyWithImpl<$Res>
    extends _$PreferenceItemCopyWithImpl<$Res, _$PreferenceItemImpl>
    implements _$$PreferenceItemImplCopyWith<$Res> {
  __$$PreferenceItemImplCopyWithImpl(
    _$PreferenceItemImpl _value,
    $Res Function(_$PreferenceItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreferenceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? text = null, Object? userId = null}) {
    return _then(
      _$PreferenceItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreferenceItemImpl implements _PreferenceItem {
  const _$PreferenceItemImpl({
    required this.id,
    required this.text,
    @JsonKey(name: 'user_id') required this.userId,
  });

  factory _$PreferenceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreferenceItemImplFromJson(json);

  @override
  final int id;
  @override
  final String text;
  @override
  @JsonKey(name: 'user_id')
  final int userId;

  @override
  String toString() {
    return 'PreferenceItem(id: $id, text: $text, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreferenceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, userId);

  /// Create a copy of PreferenceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreferenceItemImplCopyWith<_$PreferenceItemImpl> get copyWith =>
      __$$PreferenceItemImplCopyWithImpl<_$PreferenceItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreferenceItemImplToJson(this);
  }
}

abstract class _PreferenceItem implements PreferenceItem {
  const factory _PreferenceItem({
    required final int id,
    required final String text,
    @JsonKey(name: 'user_id') required final int userId,
  }) = _$PreferenceItemImpl;

  factory _PreferenceItem.fromJson(Map<String, dynamic> json) =
      _$PreferenceItemImpl.fromJson;

  @override
  int get id;
  @override
  String get text;
  @override
  @JsonKey(name: 'user_id')
  int get userId;

  /// Create a copy of PreferenceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreferenceItemImplCopyWith<_$PreferenceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
