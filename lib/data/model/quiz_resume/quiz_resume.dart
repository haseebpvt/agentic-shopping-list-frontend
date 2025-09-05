import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_resume.freezed.dart';
part 'quiz_resume.g.dart';

@freezed
class QuizResumeResponse with _$QuizResumeResponse {
  const factory QuizResumeResponse({
    required bool success,
    required QuizResumeData data,
    String? error,
  }) = _QuizResumeResponse;

  factory QuizResumeResponse.fromJson(Map<String, dynamic> json) =>
      _$QuizResumeResponseFromJson(json);
}

@freezed
class QuizResumeData with _$QuizResumeData {
  const factory QuizResumeData({
    required List<QuizResumeProduct> products,
  }) = _QuizResumeData;

  factory QuizResumeData.fromJson(Map<String, dynamic> json) =>
      _$QuizResumeDataFromJson(json);
}

@freezed
class QuizResumeProduct with _$QuizResumeProduct {
  const factory QuizResumeProduct({
    required String name,
    @JsonKey(name: 'reason_for_suggestion') required String reasonForSuggestion,
    String? note,
    @JsonKey(name: 'obvious_choice') required bool obviousChoice,
  }) = _QuizResumeProduct;

  factory QuizResumeProduct.fromJson(Map<String, dynamic> json) =>
      _$QuizResumeProductFromJson(json);
}
