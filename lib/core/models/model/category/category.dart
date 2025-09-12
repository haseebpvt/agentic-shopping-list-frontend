import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    required bool success,
    required CategoryData data,
    String? error,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@freezed
class CategoryData with _$CategoryData {
  const factory CategoryData({
    required List<Category> categories,
  }) = _CategoryData;

  factory CategoryData.fromJson(Map<String, dynamic> json) =>
      _$CategoryDataFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String name,
    required int id,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

// Extension to add database-specific methods
extension CategoryDb on Category {
  // Convert to map for local database storage
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
    };
  }
  
  // Create from database map
  static Category fromDbMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
