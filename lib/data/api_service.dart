import 'dart:convert';

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

    print("🚀 Starting API call to /get_product_recommendation");
    print("📁 File: $fileName");
    print("👤 User ID: $userId");

    final response = await dio.post(
      "/get_product_recommendation",
      data: formData,
      options: Options(responseType: ResponseType.stream),
    );

    print("✅ Got response, starting to process stream...");

    ProductSuggestion? lastResult;
    
    await for (final bytes in response.data!.stream) {
      try {
        // Decode bytes to string using utf8.decode with allowMalformed
        final chunk = utf8.decode(bytes, allowMalformed: true);
        
        print("📦 Raw chunk received:");
        print("---START CHUNK---");
        print(chunk);
        print("---END CHUNK---");
        
        // Parse the complete JSON
        final json = jsonDecode(chunk);
        print("🔍 Parsed JSON:");
        print(json);
        
        // Convert to ProductSuggestion object
        final result = ProductSuggestion.fromJson(json);
        print("✨ Converted to ProductSuggestion:");
        print("   Type: ${result.type}");
        print("   Message: ${result.message}");
        print("   Thread ID: ${result.threadId}");
        if (result.quiz != null) {
          print("   Quiz: ${result.quiz!.quiz?.length ?? 0} questions");
        }
        if (result.suggestion != null) {
          print("   Suggestion: ${result.suggestion!.products?.length ?? 0} products");
        }
        print("---");
        
        lastResult = result;
      } catch (e) {
        print("❌ Error processing chunk: $e");
        print("📦 Problematic bytes length: ${bytes.length}");
      }
    }

    print("🏁 Stream processing completed");
    
    if (lastResult == null) {
      throw Exception("No valid ProductSuggestion received from stream");
    }
    
    return lastResult;
  }
}
