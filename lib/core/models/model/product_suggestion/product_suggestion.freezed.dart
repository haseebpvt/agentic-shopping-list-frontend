// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductSuggestion _$ProductSuggestionFromJson(Map<String, dynamic> json) {
  return _ProductSuggestion.fromJson(json);
}

/// @nodoc
mixin _$ProductSuggestion {
  String get type => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'thread_id')
  String? get threadId => throw _privateConstructorUsedError;
  Quiz? get quiz => throw _privateConstructorUsedError;
  @JsonKey(name: 'products')
  List<Product>? get products => throw _privateConstructorUsedError;
  dynamic get suggestion => throw _privateConstructorUsedError;

  /// Serializes this ProductSuggestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSuggestionCopyWith<ProductSuggestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSuggestionCopyWith<$Res> {
  factory $ProductSuggestionCopyWith(
    ProductSuggestion value,
    $Res Function(ProductSuggestion) then,
  ) = _$ProductSuggestionCopyWithImpl<$Res, ProductSuggestion>;
  @useResult
  $Res call({
    String type,
    String message,
    @JsonKey(name: 'thread_id') String? threadId,
    Quiz? quiz,
    @JsonKey(name: 'products') List<Product>? products,
    dynamic suggestion,
  });

  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class _$ProductSuggestionCopyWithImpl<$Res, $Val extends ProductSuggestion>
    implements $ProductSuggestionCopyWith<$Res> {
  _$ProductSuggestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? threadId = freezed,
    Object? quiz = freezed,
    Object? products = freezed,
    Object? suggestion = freezed,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            threadId: freezed == threadId
                ? _value.threadId
                : threadId // ignore: cast_nullable_to_non_nullable
                      as String?,
            quiz: freezed == quiz
                ? _value.quiz
                : quiz // ignore: cast_nullable_to_non_nullable
                      as Quiz?,
            products: freezed == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<Product>?,
            suggestion: freezed == suggestion
                ? _value.suggestion
                : suggestion // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizCopyWith<$Res>? get quiz {
    if (_value.quiz == null) {
      return null;
    }

    return $QuizCopyWith<$Res>(_value.quiz!, (value) {
      return _then(_value.copyWith(quiz: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductSuggestionImplCopyWith<$Res>
    implements $ProductSuggestionCopyWith<$Res> {
  factory _$$ProductSuggestionImplCopyWith(
    _$ProductSuggestionImpl value,
    $Res Function(_$ProductSuggestionImpl) then,
  ) = __$$ProductSuggestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String type,
    String message,
    @JsonKey(name: 'thread_id') String? threadId,
    Quiz? quiz,
    @JsonKey(name: 'products') List<Product>? products,
    dynamic suggestion,
  });

  @override
  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class __$$ProductSuggestionImplCopyWithImpl<$Res>
    extends _$ProductSuggestionCopyWithImpl<$Res, _$ProductSuggestionImpl>
    implements _$$ProductSuggestionImplCopyWith<$Res> {
  __$$ProductSuggestionImplCopyWithImpl(
    _$ProductSuggestionImpl _value,
    $Res Function(_$ProductSuggestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? message = null,
    Object? threadId = freezed,
    Object? quiz = freezed,
    Object? products = freezed,
    Object? suggestion = freezed,
  }) {
    return _then(
      _$ProductSuggestionImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        threadId: freezed == threadId
            ? _value.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
        quiz: freezed == quiz
            ? _value.quiz
            : quiz // ignore: cast_nullable_to_non_nullable
                  as Quiz?,
        products: freezed == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<Product>?,
        suggestion: freezed == suggestion
            ? _value.suggestion
            : suggestion // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSuggestionImpl implements _ProductSuggestion {
  const _$ProductSuggestionImpl({
    required this.type,
    required this.message,
    @JsonKey(name: 'thread_id') this.threadId,
    this.quiz,
    @JsonKey(name: 'products') final List<Product>? products,
    this.suggestion,
  }) : _products = products;

  factory _$ProductSuggestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSuggestionImplFromJson(json);

  @override
  final String type;
  @override
  final String message;
  @override
  @JsonKey(name: 'thread_id')
  final String? threadId;
  @override
  final Quiz? quiz;
  final List<Product>? _products;
  @override
  @JsonKey(name: 'products')
  List<Product>? get products {
    final value = _products;
    if (value == null) return null;
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final dynamic suggestion;

  @override
  String toString() {
    return 'ProductSuggestion(type: $type, message: $message, threadId: $threadId, quiz: $quiz, products: $products, suggestion: $suggestion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSuggestionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.threadId, threadId) ||
                other.threadId == threadId) &&
            (identical(other.quiz, quiz) || other.quiz == quiz) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other.suggestion,
              suggestion,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    message,
    threadId,
    quiz,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(suggestion),
  );

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSuggestionImplCopyWith<_$ProductSuggestionImpl> get copyWith =>
      __$$ProductSuggestionImplCopyWithImpl<_$ProductSuggestionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSuggestionImplToJson(this);
  }
}

abstract class _ProductSuggestion implements ProductSuggestion {
  const factory _ProductSuggestion({
    required final String type,
    required final String message,
    @JsonKey(name: 'thread_id') final String? threadId,
    final Quiz? quiz,
    @JsonKey(name: 'products') final List<Product>? products,
    final dynamic suggestion,
  }) = _$ProductSuggestionImpl;

  factory _ProductSuggestion.fromJson(Map<String, dynamic> json) =
      _$ProductSuggestionImpl.fromJson;

  @override
  String get type;
  @override
  String get message;
  @override
  @JsonKey(name: 'thread_id')
  String? get threadId;
  @override
  Quiz? get quiz;
  @override
  @JsonKey(name: 'products')
  List<Product>? get products;
  @override
  dynamic get suggestion;

  /// Create a copy of ProductSuggestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSuggestionImplCopyWith<_$ProductSuggestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return _Quiz.fromJson(json);
}

/// @nodoc
mixin _$Quiz {
  /// The incoming JSON has `"quiz": { "quiz": [ ... ] }`
  List<QuizQuestion>? get quiz => throw _privateConstructorUsedError;

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCopyWith<Quiz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCopyWith<$Res> {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) then) =
      _$QuizCopyWithImpl<$Res, Quiz>;
  @useResult
  $Res call({List<QuizQuestion>? quiz});
}

/// @nodoc
class _$QuizCopyWithImpl<$Res, $Val extends Quiz>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quiz = freezed}) {
    return _then(
      _value.copyWith(
            quiz: freezed == quiz
                ? _value.quiz
                : quiz // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizImplCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$$QuizImplCopyWith(
    _$QuizImpl value,
    $Res Function(_$QuizImpl) then,
  ) = __$$QuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<QuizQuestion>? quiz});
}

/// @nodoc
class __$$QuizImplCopyWithImpl<$Res>
    extends _$QuizCopyWithImpl<$Res, _$QuizImpl>
    implements _$$QuizImplCopyWith<$Res> {
  __$$QuizImplCopyWithImpl(_$QuizImpl _value, $Res Function(_$QuizImpl) _then)
    : super(_value, _then);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quiz = freezed}) {
    return _then(
      _$QuizImpl(
        quiz: freezed == quiz
            ? _value._quiz
            : quiz // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizImpl implements _Quiz {
  const _$QuizImpl({final List<QuizQuestion>? quiz}) : _quiz = quiz;

  factory _$QuizImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizImplFromJson(json);

  /// The incoming JSON has `"quiz": { "quiz": [ ... ] }`
  final List<QuizQuestion>? _quiz;

  /// The incoming JSON has `"quiz": { "quiz": [ ... ] }`
  @override
  List<QuizQuestion>? get quiz {
    final value = _quiz;
    if (value == null) return null;
    if (_quiz is EqualUnmodifiableListView) return _quiz;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Quiz(quiz: $quiz)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizImpl &&
            const DeepCollectionEquality().equals(other._quiz, _quiz));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_quiz));

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      __$$QuizImplCopyWithImpl<_$QuizImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizImplToJson(this);
  }
}

abstract class _Quiz implements Quiz {
  const factory _Quiz({final List<QuizQuestion>? quiz}) = _$QuizImpl;

  factory _Quiz.fromJson(Map<String, dynamic> json) = _$QuizImpl.fromJson;

  /// The incoming JSON has `"quiz": { "quiz": [ ... ] }`
  @override
  List<QuizQuestion>? get quiz;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get question => throw _privateConstructorUsedError;
  List<String> get answers => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
    QuizQuestion value,
    $Res Function(QuizQuestion) then,
  ) = _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({String question, List<String> answers});
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? question = null, Object? answers = null}) {
    return _then(
      _value.copyWith(
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
    _$QuizQuestionImpl value,
    $Res Function(_$QuizQuestionImpl) then,
  ) = __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String question, List<String> answers});
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
    _$QuizQuestionImpl _value,
    $Res Function(_$QuizQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? question = null, Object? answers = null}) {
    return _then(
      _$QuizQuestionImpl(
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl({
    required this.question,
    required final List<String> answers,
  }) : _answers = answers;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String question;
  final List<String> _answers;
  @override
  List<String> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'QuizQuestion(question: $question, answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    question,
    const DeepCollectionEquality().hash(_answers),
  );

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(this);
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion({
    required final String question,
    required final List<String> answers,
  }) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get question;
  @override
  List<String> get answers;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'reason_for_suggestion')
  String get reasonForSuggestion => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  @JsonKey(name: 'obvious_choice')
  bool get obviousChoice => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String name,
    @JsonKey(name: 'reason_for_suggestion') String reasonForSuggestion,
    String? note,
    @JsonKey(name: 'obvious_choice') bool obviousChoice,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
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
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
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
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
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
      _$ProductImpl(
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
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.name,
    @JsonKey(name: 'reason_for_suggestion') required this.reasonForSuggestion,
    this.note,
    @JsonKey(name: 'obvious_choice') required this.obviousChoice,
  });

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

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
    return 'Product(name: $name, reasonForSuggestion: $reasonForSuggestion, note: $note, obviousChoice: $obviousChoice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
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

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String name,
    @JsonKey(name: 'reason_for_suggestion')
    required final String reasonForSuggestion,
    final String? note,
    @JsonKey(name: 'obvious_choice') required final bool obviousChoice,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

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

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
