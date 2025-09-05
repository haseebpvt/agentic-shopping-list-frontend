import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:camera/camera.dart';

abstract class ApiService {
  Future<ProductSuggestion> getProductSuggestion(
    String userId,
    XFile file,
  );
}

class ApiServiceImpl implements ApiService {
  @override
  Future<ProductSuggestion> getProductSuggestion(
    String userId,
      XFile file,
  ) {
    // TODO: implement getProductSuggestion
    throw UnimplementedError();
  }
}
