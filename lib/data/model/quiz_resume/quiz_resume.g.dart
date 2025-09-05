// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_resume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizResumeResponseImpl _$$QuizResumeResponseImplFromJson(
  Map<String, dynamic> json,
) => _$QuizResumeResponseImpl(
  success: json['success'] as bool,
  data: QuizResumeData.fromJson(json['data'] as Map<String, dynamic>),
  error: json['error'] as String?,
);

Map<String, dynamic> _$$QuizResumeResponseImplToJson(
  _$QuizResumeResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'error': instance.error,
};

_$QuizResumeDataImpl _$$QuizResumeDataImplFromJson(Map<String, dynamic> json) =>
    _$QuizResumeDataImpl(
      products: (json['products'] as List<dynamic>)
          .map((e) => QuizResumeProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizResumeDataImplToJson(
  _$QuizResumeDataImpl instance,
) => <String, dynamic>{'products': instance.products};

_$QuizResumeProductImpl _$$QuizResumeProductImplFromJson(
  Map<String, dynamic> json,
) => _$QuizResumeProductImpl(
  name: json['name'] as String,
  reasonForSuggestion: json['reason_for_suggestion'] as String,
  note: json['note'] as String?,
  obviousChoice: json['obvious_choice'] as bool,
);

Map<String, dynamic> _$$QuizResumeProductImplToJson(
  _$QuizResumeProductImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'reason_for_suggestion': instance.reasonForSuggestion,
  'note': instance.note,
  'obvious_choice': instance.obviousChoice,
};
