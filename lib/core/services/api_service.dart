import 'dart:convert';
import 'dart:io';

import 'package:advanced_shopping_list_frontend/core/models/model/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/quiz_resume/quiz_resume.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/shopping_list/shopping_list.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/preference_list/preference_list.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/category/category.dart';
import 'package:advanced_shopping_list_frontend/core/utils/image_compression.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';

abstract class ApiService {
  Stream<ProductSuggestion> getProductSuggestion(String userId, XFile file);

  Future<QuizResumeResponse> resumeQuiz(QuizResumeRequest request);

  Future<ShoppingListResponse> getShoppingList(String userId);

  Future<Map<String, dynamic>> markItemPurchased(String userId, int itemId, bool isPurchased);

  Future<PreferenceListResponse> getPreferenceList(String userId, {String? semanticSearchText});

  Future<Map<String, dynamic>> updatePreference(int itemId, String text);

  Future<Map<String, dynamic>> deletePreference(int itemId);

  Future<Map<String, dynamic>> insertData(String userId, String userText);

  Future<CategoryResponse> getCategories();

  Future<CategoryResponse> identifyCategory(String itemName);
}

class ApiServiceImpl implements ApiService {
  final Dio dio;

  const ApiServiceImpl(this.dio);

  @override
  Stream<ProductSuggestion> getProductSuggestion(
    String userId,
    XFile file,
  ) async* {
    print("🔄 Starting image compression...");
    
    // Compress the image before upload
    File compressedFile;
    try {
      compressedFile = await ImageCompression.compressImage(file);
    } catch (e) {
      print("❌ Image compression failed: $e");
      // Fall back to original file if compression fails
      compressedFile = File(file.path);
    }
    
    String fileName = compressedFile.path.split("/").last;
    FormData formData = FormData.fromMap({
      "user_id": userId,
      "file": await MultipartFile.fromFile(compressedFile.path, filename: fileName),
    });

    print("🌐 Making request to: ${dio.options.baseUrl}/recommend/get_product_recommendation");
    print("📤 Request data: user_id=$userId, file=$fileName");

    final Response response;
    try {
      response = await dio.post(
        "/recommend/get_product_recommendation",
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
              print("🔄 Decoded JSON: $json");
              
              // Handle different response formats from the backend
              final sanitizedJson = <String, dynamic>{
                'type': json['type']?.toString() ?? '',
                'message': json['message']?.toString() ?? '',
                'thread_id': json['thread_id']?.toString(),
                if (json['quiz'] != null) 'quiz': _castToStringDynamic(json['quiz']),
                // Handle both direct products array and nested suggestion structure
                if (json['products'] != null) 'products': _castToStringDynamicList(json['products']),
                // Handle suggestion field from API (always include since model expects it)
                'suggestion': json['suggestion'],
              };
              
              final result = ProductSuggestion.fromJson(sanitizedJson);
              print("✅ Successfully parsed: type='${result.type}', message='${result.message}', threadId=${result.threadId}");
              if (result.quiz != null) {
                print("✅ Quiz data present: ${result.quiz!.quiz?.length ?? 0} questions");
              }
              if (result.products != null) {
                print("✅ Products data present: ${result.products!.length} products");
              }
              yield result;
            } catch (parseError) {
              print("❌ Error parsing JSON: $parseError");
              print("❌ JSON content: $jsonStr");
              // Continue processing instead of stopping the stream
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
        print("🔄 Final decoded JSON: $json");
        
        // Handle different response formats from the backend
        final sanitizedJson = <String, dynamic>{
          'type': json['type']?.toString() ?? '',
          'message': json['message']?.toString() ?? '',
          'thread_id': json['thread_id']?.toString(),
          if (json['quiz'] != null) 'quiz': _castToStringDynamic(json['quiz']),
          // Handle both direct products array and nested suggestion structure
          if (json['products'] != null) 'products': _castToStringDynamicList(json['products']),
          // Handle suggestion field from API (always include since model expects it)
          'suggestion': json['suggestion'],
        };
        
        final result = ProductSuggestion.fromJson(sanitizedJson);
        print("✅ Successfully parsed final: type='${result.type}', message='${result.message}', threadId=${result.threadId}");
        yield result;
      } catch (bufferError) {
        print("❌ Error parsing final buffer: $bufferError");
        print("❌ Buffer content: $buffer");
      }
    }
    
    // Clean up compressed file if it's different from original
    if (compressedFile.path != file.path) {
      try {
        await compressedFile.delete();
        print("🗑️ Cleaned up compressed file: ${compressedFile.path}");
      } catch (e) {
        print("⚠️ Failed to delete compressed file: $e");
      }
    }
  }

  @override
  Future<QuizResumeResponse> resumeQuiz(QuizResumeRequest request) async {
    print("🔄 Resuming quiz with data: ${request.toJson()}");
    
    // List of possible endpoints to try
    final endpoints = [
      "/recommend/quiz_resume",
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

  @override
  Future<ShoppingListResponse> getShoppingList(String userId) async {
    print("🔄 Getting shopping list for user: $userId");
    
    try {
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "user_id": userId,
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/shopping_list/get_shopping_list");
      print("📤 Request data: user_id=$userId");

      final response = await dio.get(
        "/shopping_list/get_shopping_list",
        data: formData,
      );
      
      print("✅ Shopping list response: ${response.data}");
      return ShoppingListResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Get shopping list failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> markItemPurchased(String userId, int itemId, bool isPurchased) async {
    print("🔄 Marking item as purchased: userId=$userId, itemId=$itemId, isPurchased=$isPurchased");
    
    try {
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "item_id": itemId.toString(),
        "is_purchased": isPurchased ? "1" : "0",
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/shopping_list/mark_purchased");
      print("📤 Request data: item_id=${itemId.toString()}, is_purchased=${isPurchased ? "1" : "0"}");

      final response = await dio.post(
        "/shopping_list/mark_purchased",
        data: formData,
      );
      
      print("✅ Mark purchased response: ${response.data}");
      return response.data;
    } catch (e) {
      print("❌ Mark item purchased failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<PreferenceListResponse> getPreferenceList(String userId, {String? semanticSearchText}) async {
    print("🔄 Getting preference list for user: $userId${semanticSearchText != null ? ' with search: $semanticSearchText' : ''}");
    
    try {
      // Create form data as per the API specification
      Map<String, dynamic> formDataMap = {
        "user_id": userId,
      };
      
      // Add semantic search text if provided
      if (semanticSearchText != null && semanticSearchText.isNotEmpty) {
        formDataMap["semantic_search_text"] = semanticSearchText;
      }
      
      FormData formData = FormData.fromMap(formDataMap);

      // Note: The preference list API might be on a different server
      // Using the curl example: http://0.0.0.0:8000/get_preference_list
      // We'll use the configured base URL but the endpoint path
      print("🌐 Making request to: ${dio.options.baseUrl}/preference/get_preference_list");
      print("📤 Request data: $formDataMap");

      final response = await dio.get(
        "/preference/get_preference_list",
        data: formData,
      );
      
      print("✅ Preference list response: ${response.data}");
      return PreferenceListResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Get preference list failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updatePreference(int itemId, String text) async {
    print("🔄 Updating preference: itemId=$itemId, text=$text");
    
    try {
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "item_id": itemId,
        "text": text,
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/preference/update");
      print("📤 Request data: item_id=$itemId, text=$text");

      final response = await dio.post(
        "/preference/update",
        data: formData,
      );
      
      print("✅ Update preference response: ${response.data}");
      return response.data;
    } catch (e) {
      print("❌ Update preference failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> deletePreference(int itemId) async {
    print("🔄 Deleting preference: itemId=$itemId");
    
    try {
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "item_id": itemId,
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/preference/delete");
      print("📤 Request data: item_id=$itemId");

      final response = await dio.delete(
        "/preference/delete",
        data: formData,
      );
      
      print("✅ Delete preference response: ${response.data}");
      return response.data;
    } catch (e) {
      print("❌ Delete preference failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> insertData(String userId, String userText) async {
    print("🔄 Inserting data: userId=$userId, userText=$userText");
    
    try {
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "user_id": userId,
        "user_text": userText,
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/extractor/insert_data");
      print("📤 Request data: user_id=$userId, user_text=$userText");

      final response = await dio.post(
        "/extractor/insert_data",
        data: formData,
      );
      
      print("✅ Insert data response: ${response.data}");
      return response.data;
    } catch (e) {
      print("❌ Insert data failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<CategoryResponse> getCategories() async {
    try {
      print("🌐 Making request to: ${dio.options.baseUrl}/category/categories");

      final response = await dio.get("/category/categories");
      
      print("✅ Categories response: ${response.data}");
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Get categories failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  @override
  Future<CategoryResponse> identifyCategory(String itemName) async {
    try {
      print("🔄 Identifying category for item: $itemName");
      
      // Create form data as per the API specification
      FormData formData = FormData.fromMap({
        "item_name": itemName,
      });

      print("🌐 Making request to: ${dio.options.baseUrl}/category/identify");
      print("📤 Request data: item_name=$itemName");

      final response = await dio.get(
        "/category/identify",
        data: formData,
      );
      
      print("✅ Category identification response: ${response.data}");
      return CategoryResponse.fromJson(response.data);
    } catch (e) {
      print("❌ Category identification failed: $e");
      if (e is DioException) {
        print("❌ Error type: ${e.type}");
        print("❌ Error message: ${e.message}");
        print("❌ Response: ${e.response?.data}");
      }
      rethrow;
    }
  }

  // Helper method to cast dynamic map to Map<String, dynamic>
  Map<String, dynamic> _castToStringDynamic(dynamic map) {
    if (map is Map<String, dynamic>) {
      return map;
    } else if (map is Map) {
      return Map<String, dynamic>.from(map);
    } else {
      throw ArgumentError('Cannot cast $map to Map<String, dynamic>');
    }
  }

  // Helper method to cast dynamic list to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _castToStringDynamicList(dynamic list) {
    if (list is List<Map<String, dynamic>>) {
      return list;
    } else if (list is List) {
      return list.map((item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else if (item is Map) {
          return Map<String, dynamic>.from(item);
        } else {
          throw ArgumentError('Cannot cast list item $item to Map<String, dynamic>');
        }
      }).toList();
    } else {
      throw ArgumentError('Cannot cast $list to List<Map<String, dynamic>>');
    }
  }
}
