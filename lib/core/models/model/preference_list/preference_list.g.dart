// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreferenceListResponseImpl _$$PreferenceListResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PreferenceListResponseImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => PreferenceItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  error: json['error'] as String?,
);

Map<String, dynamic> _$$PreferenceListResponseImplToJson(
  _$PreferenceListResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'error': instance.error,
};

_$PreferenceItemImpl _$$PreferenceItemImplFromJson(Map<String, dynamic> json) =>
    _$PreferenceItemImpl(
      id: (json['id'] as num).toInt(),
      text: json['text'] as String,
      userId: (json['user_id'] as num).toInt(),
    );

Map<String, dynamic> _$$PreferenceItemImplToJson(
  _$PreferenceItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'text': instance.text,
  'user_id': instance.userId,
};
