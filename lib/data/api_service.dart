import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';

abstract class ApiService {
  Future<ProductSuggestion> getProductSuggestion(
    String userId,
    String filePath,
  );
}

class ApiServiceImpl implements ApiService {
  @override
  Future<ProductSuggestion> getProductSuggestion(
    String userId,
    String filePath,
  ) {
    // TODO: implement getProductSuggestion
    throw UnimplementedError();
  }
}
