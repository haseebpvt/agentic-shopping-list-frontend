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

    print("🌐 Making request to: ${dio.options.baseUrl}/get_product_recommendation");
    print("📤 Request data: user_id=$userId, file=$fileName");

    final Response response;
    try {
      response = await dio.post(
        "/get_product_recommendation",
        data: formData,
        options: Options(responseType: ResponseType.stream),
      );
      
      print("✅ Connected successfully, status: ${response.statusCode}");
    } catch (e) {
      print("❌ Connection failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
    
    String buffer = '';
    await for (final bytes in response.data!.stream) {
      try {
        // Decode bytes to string using utf8.decode with allowMalformed
        final chunk = utf8.decode(bytes, allowMalformed: true);
        buffer += chunk;
        print("📦 Received chunk: $chunk");
        print("📝 Current buffer: $buffer");
        
        // Parse multiple JSON objects that might be concatenated
        while (buffer.isNotEmpty) {
          buffer = buffer.trim();
          if (buffer.isEmpty) break;
          
          // Find the end of the first JSON object
          int braceCount = 0;
          int endIndex = -1;
          bool inString = false;
          bool escapeNext = false;
          
          for (int i = 0; i < buffer.length; i++) {
            final char = buffer[i];
            
            if (escapeNext) {
              escapeNext = false;
              continue;
            }
            
            if (char == '\\') {
              escapeNext = true;
              continue;
            }
            
            if (char == '"') {
              inString = !inString;
              continue;
            }
            
            if (!inString) {
              if (char == '{') {
                braceCount++;
              } else if (char == '}') {
                braceCount--;
                if (braceCount == 0) {
                  endIndex = i;
                  break;
                }
              }
            }
          }
          
          if (endIndex != -1) {
            // Extract the complete JSON object
            final jsonStr = buffer.substring(0, endIndex + 1);
            buffer = buffer.substring(endIndex + 1);
            
            try {
              print("🔄 Processing JSON: $jsonStr");
              final json = jsonDecode(jsonStr);
              final result = ProductSuggestion.fromJson(json);
              print("✅ Successfully parsed: ${result.type} - ${result.message}");
              yield result;
            } catch (parseError) {
              print("❌ Error parsing JSON: $parseError");
              print("❌ JSON content: $jsonStr");
            }
          } else {
            // No complete JSON object found, wait for more data
            break;
          }
        }
      } catch (e) {
        print("❌ Error processing chunk: $e");
      }
    }
    
    // Handle any remaining data in buffer
    if (buffer.trim().isNotEmpty) {
      try {
        print("🔄 Processing final buffer: ${buffer.trim()}");
        final json = jsonDecode(buffer.trim());
        final result = ProductSuggestion.fromJson(json);
        print("✅ Successfully parsed final: ${result.type} - ${result.message}");
        yield result;
      } catch (bufferError) {
        print("❌ Error parsing final buffer: $bufferError");
        print("❌ Buffer content: $buffer");
      }
    }
  }

  @override
  Future<QuizResumeResponse> resumeQuiz(QuizResumeRequest request) async {
    print("🔄 Resuming quiz with data: ${request.toJson()}");
    
    // List of possible endpoints to try
    final endpoints = [
      "/resume_quiz",
      "/quiz_resume", 
      "/submit_quiz_answers"
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
