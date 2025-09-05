
import 'package:advanced_shopping_list_frontend/bloc/product_suggestion/product_suggestion_event.dart';
import 'package:advanced_shopping_list_frontend/bloc/product_suggestion/product_suggestion_state.dart';
import 'package:advanced_shopping_list_frontend/data/api_service.dart';
import 'package:advanced_shopping_list_frontend/data/model/product_suggestion/product_suggestion.dart';
import 'package:animated_quiz_widget/quiz_view.dart' as quiz_widget;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSuggestionBloc extends Bloc<ProductSuggestionEvent, ProductSuggestionState> {
  final ApiService apiService;

  ProductSuggestionBloc({required this.apiService}) : super(const ProductSuggestionInitial()) {
    on<GetProductSuggestionEvent>(_onGetProductSuggestion);
    on<SubmitQuizEvent>(_onSubmitQuiz);
    on<ResetEvent>(_onReset);
  }

  void _onGetProductSuggestion(
    GetProductSuggestionEvent event,
    Emitter<ProductSuggestionState> emit,
  ) async {
    print("🔥 GetProductSuggestionEvent received for user: ${event.userId}");
    emit(const ProductSuggestionLoading(message: "Starting image analysis..."));

    try {
      await emit.forEach<ProductSuggestion>(
        apiService.getProductSuggestion(event.userId, event.imageFile),
        onData: (data) {
          print("📡 Received stream data: type=${data.type}, message=${data.message}, threadId=${data.threadId}");
          print("📡 Quiz data: ${data.quiz}");
          print("📡 Suggestion data: ${data.suggestion}");
          
          if (data.type == "quiz_interrupt" || data.type == "quiz") {
            // Quiz is required
            final quizQuestions = data.quiz?.quiz?.map((item) {
              return quiz_widget.QuizQuestion(
                id: item.question.hashCode.toString(),
                question: item.question,
                options: item.answers,
              );
            }).toList() ?? [];

            print("📡 Quiz questions parsed: ${quizQuestions.length} questions");
            
            if (quizQuestions.isEmpty) {
              print("⚠️ No quiz questions found in data: ${data.quiz}");
              return ProductSuggestionLoading(message: "Processing quiz data...");
            }

            return ProductSuggestionQuizRequired(
              quizQuestions: quizQuestions,
              threadId: data.threadId ?? "",
              message: data.message,
            );
          } else if (data.type == "suggestion" && data.suggestion?.products != null) {
            // Direct suggestions without quiz
            print("📡 Found ${data.suggestion!.products!.length} products");
            return ProductSuggestionSuccess(
              products: data.suggestion!.products!,
              message: data.message,
            );
          } else {
            // Stream update - show the message in loading state
            print("📡 Stream update: ${data.message}");
            return ProductSuggestionLoading(message: data.message);
          }
        },
        onError: (error, stackTrace) {
          print("❌ Stream error: $error");
          return ProductSuggestionError(error: error.toString());
        },
      );
    } catch (e) {
      print("❌ Exception in _onGetProductSuggestion: $e");
      emit(ProductSuggestionError(error: e.toString()));
    }
  }

  void _onSubmitQuiz(
    SubmitQuizEvent event,
    Emitter<ProductSuggestionState> emit,
  ) async {
    emit(const QuizSubmissionLoading());

    try {
      final response = await apiService.resumeQuiz(event.quizRequest);
      
      if (response.success) {
        // Convert QuizResumeProduct to Product
        final products = response.data.products.map((quizProduct) {
          return Product(
            name: quizProduct.name,
            reasonForSuggestion: quizProduct.reasonForSuggestion,
            note: quizProduct.note,
            obviousChoice: quizProduct.obviousChoice,
          );
        }).toList();

        emit(ProductSuggestionSuccess(
          products: products,
          message: "Quiz completed successfully!",
        ));
      } else {
        emit(ProductSuggestionError(
          error: response.error ?? "Unknown error occurred",
        ));
      }
    } catch (e) {
      emit(ProductSuggestionError(error: e.toString()));
    }
  }

  void _onReset(
    ResetEvent event,
    Emitter<ProductSuggestionState> emit,
  ) {
    emit(const ProductSuggestionInitial());
  }
}
