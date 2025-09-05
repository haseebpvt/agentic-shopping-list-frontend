import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_suggestion.freezed.dart';
part 'product_suggestion.g.dart';

@freezed
class ProductSuggestion with _$ProductSuggestion {
  const factory ProductSuggestion({
    required String type,
    required String message,
    @JsonKey(name: 'thread_id') required String threadId,
    Quiz? quiz,
    Suggestion? suggestion,
  }) = _ProductSuggestion;

  factory ProductSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ProductSuggestionFromJson(json);
}

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    /// The incoming JSON has `"quiz": { "quiz": [ ... ] }`
    List<QuizQuestion>? quiz,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String question,
    required List<String> answers,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
class Suggestion with _$Suggestion {
  const factory Suggestion({
    List<Product>? products,
  }) = _Suggestion;

  factory Suggestion.fromJson(Map<String, dynamic> json) =>
      _$SuggestionFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String name,
    @JsonKey(name: 'reason_for_suggestion') required String reasonForSuggestion,
    String? note,
    @JsonKey(name: 'obvious_choice') required bool obviousChoice,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}