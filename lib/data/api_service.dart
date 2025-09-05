import 'dart:convert';

import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

abstract class ApiService {
  Stream<ProductSuggestion> getProductSuggestion(String userId, XFile file);
}

class ApiServiceImpl implements ApiService {
  final Dio dio;

  const ApiServiceImpl(this.dio);

  @override
  Stream<ProductSuggestion> getProductSuggestion(
    String userId,
    XFile file,
  ) async* {
    String fileName = file.path.split("/").last;
    FormData formData = FormData.fromMap({
      "user_id": userId,
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    final response = await dio.post(
      "/get_product_recommendation",
      data: formData,
      options: Options(responseType: ResponseType.stream),
    );
    
    await for (final bytes in response.data!.stream) {
      try {
        // Decode bytes to string using utf8.decode with allowMalformed
        final chunk = utf8.decode(bytes, allowMalformed: true);

        final json = jsonDecode(chunk);
        final result = ProductSuggestion.fromJson(json);

        yield result;
      } catch (e) {
        print("❌ Error processing chunk: $e");
      }
    }
  }
}
