import 'dart:convert';

import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/data/model/quiz_resume/quiz_resume.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

abstract class ApiService {
  Stream<ProductSuggestion> getProductSuggestion(String userId, XFile file);

  Future<QuizResumeResponse> resumeQuiz(QuizResumeRequest request);
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
        print("📦 Received chunk: $chunk");
        
        // Try to parse the chunk directly as JSON first
        try {
          final json = jsonDecode(chunk.trim());
          final result = ProductSuggestion.fromJson(json);
          print("✅ Successfully parsed chunk: ${result.type} - ${result.message}");
          yield result;
        } catch (directParseError) {
          print("⚠️ Direct parse failed, trying line-by-line: $directParseError");
          
          // If direct parsing fails, try line-by-line parsing
          final lines = chunk.split('\n');
          for (final line in lines) {
            final trimmedLine = line.trim();
            if (trimmedLine.isNotEmpty) {
              try {
                print("🔄 Processing line: $trimmedLine");
                final json = jsonDecode(trimmedLine);
                final result = ProductSuggestion.fromJson(json);
                print("✅ Successfully parsed line: ${result.type} - ${result.message}");
                yield result;
              } catch (lineError) {
                print("❌ Error parsing line: $lineError");
                print("❌ Line content: $trimmedLine");
              }
            }
          }
        }
      } catch (e) {
        print("❌ Error processing chunk: $e");
      }
    }
  }

  @override
  Future<QuizResumeResponse> resumeQuiz(QuizResumeRequest request) async {
    print("🔄 Resuming quiz with data: ${request.toJson()}");
    
    // List of possible endpoints to try
    final endpoints = [
      "/quiz_resume",
      "/resume_quiz", 
      "/continue_quiz",
      "/submit_quiz_answers",
      "/quiz_answers"
    ];
    
    for (final endpoint in endpoints) {
      try {
        print("🔄 Trying endpoint: $endpoint");
        final response = await dio.post(
          endpoint,
          data: request.toJson(),
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );
        
        print("✅ Quiz resume response from $endpoint: ${response.data}");
        return QuizResumeResponse.fromJson(response.data);
      } catch (e) {
        print("❌ Endpoint $endpoint failed: $e");
        if (e is DioException) {
          print("❌ Status code: ${e.response?.statusCode}");
          print("❌ Response data: ${e.response?.data}");
        }
        
        // If this is the last endpoint, rethrow the error
        if (endpoint == endpoints.last) {
          print("❌ All endpoints failed, rethrowing last error");
          rethrow;
        }
      }
    }
    
    throw Exception("All quiz resume endpoints failed");
  }
}
