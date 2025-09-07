import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference_list.freezed.dart';
part 'preference_list.g.dart';

@freezed
class PreferenceListResponse with _$PreferenceListResponse {
  const factory PreferenceListResponse({
    required bool success,
    required List<PreferenceItem> data,
    String? error,
  }) = _PreferenceListResponse;

  factory PreferenceListResponse.fromJson(Map<String, dynamic> json) =>
      _$PreferenceListResponseFromJson(json);
}

@freezed
class PreferenceItem with _$PreferenceItem {
  const factory PreferenceItem({
    required int id,
    required String text,
    @JsonKey(name: 'user_id') required int userId,
  }) = _PreferenceItem;

  factory PreferenceItem.fromJson(Map<String, dynamic> json) =>
      _$PreferenceItemFromJson(json);
}
