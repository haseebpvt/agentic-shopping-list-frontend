// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSuggestionImpl _$$ProductSuggestionImplFromJson(
  Map<String, dynamic> json,
) => _$ProductSuggestionImpl(
  type: json['type'] as String,
  message: json['message'] as String,
  threadId: json['thread_id'] as String?,
  quiz: json['quiz'] == null
      ? null
      : Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
  products: (json['products'] as List<dynamic>?)
      ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
  suggestion: json['suggestion'],
);

Map<String, dynamic> _$$ProductSuggestionImplToJson(
  _$ProductSuggestionImpl instance,
) => <String, dynamic>{
  'type': instance.type,
  'message': instance.message,
  'thread_id': instance.threadId,
  'quiz': instance.quiz,
  'products': instance.products,
  'suggestion': instance.suggestion,
};

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
  quiz: (json['quiz'] as List<dynamic>?)
      ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{'quiz': instance.quiz};

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      question: json['question'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'question': instance.question,
      'answers': instance.answers,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      name: json['name'] as String,
      reasonForSuggestion: json['reason_for_suggestion'] as String,
      note: json['note'] as String?,
      obviousChoice: json['obvious_choice'] as bool,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reason_for_suggestion': instance.reasonForSuggestion,
      'note': instance.note,
      'obvious_choice': instance.obviousChoice,
    };
