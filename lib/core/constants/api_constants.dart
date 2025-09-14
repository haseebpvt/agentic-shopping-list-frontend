import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // OpenAI API Configuration - loaded from environment variables
  static String get openAiApiKey {
    final key = dotenv.env['OPENAI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'OPENAI_API_KEY not found in environment variables. '
        'Please copy env.example to .env and add your OpenAI API key.'
      );
    }
    return key;
  }
  
  // Backend API URL - can be overridden via environment
  static String get baseUrl {
    return dotenv.env['BACKEND_API_URL'] ?? "https://shoppinglistagent.shop/api";
  }
}
