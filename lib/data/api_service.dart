import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

abstract class ApiService {
  Future<ProductSuggestion> getProductSuggestion(String userId, XFile file);
}

class ApiServiceImpl implements ApiService {
  final Dio dio;

  const ApiServiceImpl(this.dio);

  @override
  Future<ProductSuggestion> getProductSuggestion(
    String userId,
    XFile file,
  ) async {
    String fileName = file.path.split("/").last;
    FormData formData = FormData.fromMap({
      "user_id": userId,
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(
      "/get_product_recommendation",
      data: formData,
    );

    return response.data;
  }
}
