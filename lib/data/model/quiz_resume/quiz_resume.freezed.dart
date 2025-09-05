// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_resume.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizResumeRequest _$QuizResumeRequestFromJson(Map<String, dynamic> json) {
  return _QuizResumeRequest.fromJson(json);
}

/// @nodoc
mixin _$QuizResumeRequest {
  @JsonKey(name: 'thread_id')
  String get threadId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_and_answers')
  List<String> get questionAndAnswers => throw _privateConstructorUsedError;

  /// Serializes this QuizResumeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResumeRequestCopyWith<QuizResumeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResumeRequestCopyWith<$Res> {
  factory $QuizResumeRequestCopyWith(
    QuizResumeRequest value,
    $Res Function(QuizResumeRequest) then,
  ) = _$QuizResumeRequestCopyWithImpl<$Res, QuizResumeRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'thread_id') String threadId,
    @JsonKey(name: 'question_and_answers') List<String> questionAndAnswers,
  });
}

/// @nodoc
class _$QuizResumeRequestCopyWithImpl<$Res, $Val extends QuizResumeRequest>
    implements $QuizResumeRequestCopyWith<$Res> {
  _$QuizResumeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threadId = null, Object? questionAndAnswers = null}) {
    return _then(
      _value.copyWith(
            threadId: null == threadId
                ? _value.threadId
                : threadId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionAndAnswers: null == questionAndAnswers
                ? _value.questionAndAnswers
                : questionAndAnswers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizResumeRequestImplCopyWith<$Res>
    implements $QuizResumeRequestCopyWith<$Res> {
  factory _$$QuizResumeRequestImplCopyWith(
    _$QuizResumeRequestImpl value,
    $Res Function(_$QuizResumeRequestImpl) then,
  ) = __$$QuizResumeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'thread_id') String threadId,
    @JsonKey(name: 'question_and_answers') List<String> questionAndAnswers,
  });
}

/// @nodoc
class __$$QuizResumeRequestImplCopyWithImpl<$Res>
    extends _$QuizResumeRequestCopyWithImpl<$Res, _$QuizResumeRequestImpl>
    implements _$$QuizResumeRequestImplCopyWith<$Res> {
  __$$QuizResumeRequestImplCopyWithImpl(
    _$QuizResumeRequestImpl _value,
    $Res Function(_$QuizResumeRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? threadId = null, Object? questionAndAnswers = null}) {
    return _then(
      _$QuizResumeRequestImpl(
        threadId: null == threadId
            ? _value.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionAndAnswers: null == questionAndAnswers
            ? _value._questionAndAnswers
            : questionAndAnswers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizResumeRequestImpl implements _QuizResumeRequest {
  const _$QuizResumeRequestImpl({
    @JsonKey(name: 'thread_id') required this.threadId,
    @JsonKey(name: 'question_and_answers')
    required final List<String> questionAndAnswers,
  }) : _questionAndAnswers = questionAndAnswers;

  factory _$QuizResumeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResumeRequestImplFromJson(json);

  @override
  @JsonKey(name: 'thread_id')
  final String threadId;
  final List<String> _questionAndAnswers;
  @override
  @JsonKey(name: 'question_and_answers')
  List<String> get questionAndAnswers {
    if (_questionAndAnswers is EqualUnmodifiableListView)
      return _questionAndAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questionAndAnswers);
  }

  @override
  String toString() {
    return 'QuizResumeRequest(threadId: $threadId, questionAndAnswers: $questionAndAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResumeRequestImpl &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            const DeepCollectionEquality().equals(
              other._questionAndAnswers,
              _questionAndAnswers,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    threadId,
    const DeepCollectionEquality().hash(_questionAndAnswers),
  );

  /// Create a copy of QuizResumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResumeRequestImplCopyWith<_$QuizResumeRequestImpl> get copyWith =>
      __$$QuizResumeRequestImplCopyWithImpl<_$QuizResumeRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResumeRequestImplToJson(this);
  }
}

abstract class _QuizResumeRequest implements QuizResumeRequest {
  const factory _QuizResumeRequest({
    @JsonKey(name: 'thread_id') required final String threadId,
    @JsonKey(name: 'question_and_answers')
    required final List<String> questionAndAnswers,
  }) = _$QuizResumeRequestImpl;

  factory _QuizResumeRequest.fromJson(Map<String, dynamic> json) =
      _$QuizResumeRequestImpl.fromJson;

  @override
  @JsonKey(name: 'thread_id')
  String get threadId;
  @override
  @JsonKey(name: 'question_and_answers')
  List<String> get questionAndAnswers;

  /// Create a copy of QuizResumeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResumeRequestImplCopyWith<_$QuizResumeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizResumeResponse _$QuizResumeResponseFromJson(Map<String, dynamic> json) {
  return _QuizResumeResponse.fromJson(json);
}

/// @nodoc
mixin _$QuizResumeResponse {
  bool get success => throw _privateConstructorUsedError;
  QuizResumeData get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this QuizResumeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResumeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResumeResponseCopyWith<QuizResumeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResumeResponseCopyWith<$Res> {
  factory $QuizResumeResponseCopyWith(
    QuizResumeResponse value,
    $Res Function(QuizResumeResponse) then,
  ) = _$QuizResumeResponseCopyWithImpl<$Res, QuizResumeResponse>;
  @useResult
  $Res call({bool success, QuizResumeData data, String? error});

  $QuizResumeDataCopyWith<$Res> get data;
}

/// @nodoc
class _$QuizResumeResponseCopyWithImpl<$Res, $Val extends QuizResumeResponse>
    implements $QuizResumeResponseCopyWith<$Res> {
  _$QuizResumeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResumeResponse
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
                      as QuizResumeData,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of QuizResumeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizResumeDataCopyWith<$Res> get data {
    return $QuizResumeDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuizResumeResponseImplCopyWith<$Res>
    implements $QuizResumeResponseCopyWith<$Res> {
  factory _$$QuizResumeResponseImplCopyWith(
    _$QuizResumeResponseImpl value,
    $Res Function(_$QuizResumeResponseImpl) then,
  ) = __$$QuizResumeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, QuizResumeData data, String? error});

  @override
  $QuizResumeDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$QuizResumeResponseImplCopyWithImpl<$Res>
    extends _$QuizResumeResponseCopyWithImpl<$Res, _$QuizResumeResponseImpl>
    implements _$$QuizResumeResponseImplCopyWith<$Res> {
  __$$QuizResumeResponseImplCopyWithImpl(
    _$QuizResumeResponseImpl _value,
    $Res Function(_$QuizResumeResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResumeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(
      _$QuizResumeResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as QuizResumeData,
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
class _$QuizResumeResponseImpl implements _QuizResumeResponse {
  const _$QuizResumeResponseImpl({
    required this.success,
    required this.data,
    this.error,
  });

  factory _$QuizResumeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResumeResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final QuizResumeData data;
  @override
  final String? error;

  @override
  String toString() {
    return 'QuizResumeResponse(success: $success, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResumeResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, error);

  /// Create a copy of QuizResumeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResumeResponseImplCopyWith<_$QuizResumeResponseImpl> get copyWith =>
      __$$QuizResumeResponseImplCopyWithImpl<_$QuizResumeResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResumeResponseImplToJson(this);
  }
}

abstract class _QuizResumeResponse implements QuizResumeResponse {
  const factory _QuizResumeResponse({
    required final bool success,
    required final QuizResumeData data,
    final String? error,
  }) = _$QuizResumeResponseImpl;

  factory _QuizResumeResponse.fromJson(Map<String, dynamic> json) =
      _$QuizResumeResponseImpl.fromJson;

  @override
  bool get success;
  @override
  QuizResumeData get data;
  @override
  String? get error;

  /// Create a copy of QuizResumeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResumeResponseImplCopyWith<_$QuizResumeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizResumeData _$QuizResumeDataFromJson(Map<String, dynamic> json) {
  return _QuizResumeData.fromJson(json);
}

/// @nodoc
mixin _$QuizResumeData {
  List<QuizResumeProduct> get products => throw _privateConstructorUsedError;

  /// Serializes this QuizResumeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResumeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResumeDataCopyWith<QuizResumeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResumeDataCopyWith<$Res> {
  factory $QuizResumeDataCopyWith(
    QuizResumeData value,
    $Res Function(QuizResumeData) then,
  ) = _$QuizResumeDataCopyWithImpl<$Res, QuizResumeData>;
  @useResult
  $Res call({List<QuizResumeProduct> products});
}

/// @nodoc
class _$QuizResumeDataCopyWithImpl<$Res, $Val extends QuizResumeData>
    implements $QuizResumeDataCopyWith<$Res> {
  _$QuizResumeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResumeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? products = null}) {
    return _then(
      _value.copyWith(
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<QuizResumeProduct>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizResumeDataImplCopyWith<$Res>
    implements $QuizResumeDataCopyWith<$Res> {
  factory _$$QuizResumeDataImplCopyWith(
    _$QuizResumeDataImpl value,
    $Res Function(_$QuizResumeDataImpl) then,
  ) = __$$QuizResumeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuizResumeProduct> products});
}

/// @nodoc
class __$$QuizResumeDataImplCopyWithImpl<$Res>
    extends _$QuizResumeDataCopyWithImpl<$Res, _$QuizResumeDataImpl>
    implements _$$QuizResumeDataImplCopyWith<$Res> {
  __$$QuizResumeDataImplCopyWithImpl(
    _$QuizResumeDataImpl _value,
    $Res Function(_$QuizResumeDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResumeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? products = null}) {
    return _then(
      _$QuizResumeDataImpl(
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<QuizResumeProduct>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizResumeDataImpl implements _QuizResumeData {
  const _$QuizResumeDataImpl({required final List<QuizResumeProduct> products})
    : _products = products;

  factory _$QuizResumeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResumeDataImplFromJson(json);

  final List<QuizResumeProduct> _products;
  @override
  List<QuizResumeProduct> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  String toString() {
    return 'QuizResumeData(products: $products)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResumeDataImpl &&
            const DeepCollectionEquality().equals(other._products, _products));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_products));

  /// Create a copy of QuizResumeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResumeDataImplCopyWith<_$QuizResumeDataImpl> get copyWith =>
      __$$QuizResumeDataImplCopyWithImpl<_$QuizResumeDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResumeDataImplToJson(this);
  }
}

abstract class _QuizResumeData implements QuizResumeData {
  const factory _QuizResumeData({
    required final List<QuizResumeProduct> products,
  }) = _$QuizResumeDataImpl;

  factory _QuizResumeData.fromJson(Map<String, dynamic> json) =
      _$QuizResumeDataImpl.fromJson;

  @override
  List<QuizResumeProduct> get products;

  /// Create a copy of QuizResumeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResumeDataImplCopyWith<_$QuizResumeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizResumeProduct _$QuizResumeProductFromJson(Map<String, dynamic> json) {
  return _QuizResumeProduct.fromJson(json);
}

/// @nodoc
mixin _$QuizResumeProduct {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'reason_for_suggestion')
  String get reasonForSuggestion => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'obvious_choice')
  bool get obviousChoice => throw _privateConstructorUsedError;

  /// Serializes this QuizResumeProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizResumeProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizResumeProductCopyWith<QuizResumeProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizResumeProductCopyWith<$Res> {
  factory $QuizResumeProductCopyWith(
    QuizResumeProduct value,
    $Res Function(QuizResumeProduct) then,
  ) = _$QuizResumeProductCopyWithImpl<$Res, QuizResumeProduct>;
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'reason_for_suggestion') String reasonForSuggestion,
    String? note,
    @JsonKey(name: 'obvious_choice') bool obviousChoice,
  });
}

/// @nodoc
class _$QuizResumeProductCopyWithImpl<$Res, $Val extends QuizResumeProduct>
    implements $QuizResumeProductCopyWith<$Res> {
  _$QuizResumeProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizResumeProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? reasonForSuggestion = null,
    Object? note = freezed,
    Object? obviousChoice = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            reasonForSuggestion: null == reasonForSuggestion
                ? _value.reasonForSuggestion
                : reasonForSuggestion // ignore: cast_nullable_to_non_nullable
                      as String,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            obviousChoice: null == obviousChoice
                ? _value.obviousChoice
                : obviousChoice // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizResumeProductImplCopyWith<$Res>
    implements $QuizResumeProductCopyWith<$Res> {
  factory _$$QuizResumeProductImplCopyWith(
    _$QuizResumeProductImpl value,
    $Res Function(_$QuizResumeProductImpl) then,
  ) = __$$QuizResumeProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'reason_for_suggestion') String reasonForSuggestion,
    String? note,
    @JsonKey(name: 'obvious_choice') bool obviousChoice,
  });
}

/// @nodoc
class __$$QuizResumeProductImplCopyWithImpl<$Res>
    extends _$QuizResumeProductCopyWithImpl<$Res, _$QuizResumeProductImpl>
    implements _$$QuizResumeProductImplCopyWith<$Res> {
  __$$QuizResumeProductImplCopyWithImpl(
    _$QuizResumeProductImpl _value,
    $Res Function(_$QuizResumeProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizResumeProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? reasonForSuggestion = null,
    Object? note = freezed,
    Object? obviousChoice = null,
  }) {
    return _then(
      _$QuizResumeProductImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        reasonForSuggestion: null == reasonForSuggestion
            ? _value.reasonForSuggestion
            : reasonForSuggestion // ignore: cast_nullable_to_non_nullable
                  as String,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        obviousChoice: null == obviousChoice
            ? _value.obviousChoice
            : obviousChoice // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizResumeProductImpl implements _QuizResumeProduct {
  const _$QuizResumeProductImpl({
    required this.name,
    @JsonKey(name: 'reason_for_suggestion') required this.reasonForSuggestion,
    this.note,
    @JsonKey(name: 'obvious_choice') required this.obviousChoice,
  });

  factory _$QuizResumeProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizResumeProductImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'reason_for_suggestion')
  final String reasonForSuggestion;
  @override
  final String? note;
  @override
  @JsonKey(name: 'obvious_choice')
  final bool obviousChoice;

  @override
  String toString() {
    return 'QuizResumeProduct(name: $name, reasonForSuggestion: $reasonForSuggestion, note: $note, obviousChoice: $obviousChoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResumeProductImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.reasonForSuggestion, reasonForSuggestion) ||
                other.reasonForSuggestion == reasonForSuggestion) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.obviousChoice, obviousChoice) ||
                other.obviousChoice == obviousChoice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, reasonForSuggestion, note, obviousChoice);

  /// Create a copy of QuizResumeProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResumeProductImplCopyWith<_$QuizResumeProductImpl> get copyWith =>
      __$$QuizResumeProductImplCopyWithImpl<_$QuizResumeProductImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizResumeProductImplToJson(this);
  }
}

abstract class _QuizResumeProduct implements QuizResumeProduct {
  const factory _QuizResumeProduct({
    required final String name,
    @JsonKey(name: 'reason_for_suggestion')
    required final String reasonForSuggestion,
    final String? note,
    @JsonKey(name: 'obvious_choice') required final bool obviousChoice,
  }) = _$QuizResumeProductImpl;

  factory _QuizResumeProduct.fromJson(Map<String, dynamic> json) =
      _$QuizResumeProductImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'reason_for_suggestion')
  String get reasonForSuggestion;
  @override
  String? get note;
  @override
  @JsonKey(name: 'obvious_choice')
  bool get obviousChoice;

  /// Create a copy of QuizResumeProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizResumeProductImplCopyWith<_$QuizResumeProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
