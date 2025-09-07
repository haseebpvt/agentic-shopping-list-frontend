import 'package:advanced_shopping_list_frontend/core/models/model/product_suggestion/product_suggestion.dart';
import 'package:animated_quiz_widget/quiz_view.dart' as quiz_widget;
import 'package:equatable/equatable.dart';

abstract class ProductSuggestionState extends Equatable {
  const ProductSuggestionState();

  @override
  List<Object?> get props => [];
}

class ProductSuggestionInitial extends ProductSuggestionState {
  const ProductSuggestionInitial();
}

class ProductSuggestionLoading extends ProductSuggestionState {
  final String message;
  
  const ProductSuggestionLoading({this.message = "Processing image..."});

  @override
  List<Object?> get props => [message];
}

class ProductSuggestionQuizRequired extends ProductSuggestionState {
  final List<quiz_widget.QuizQuestion> quizQuestions;
  final String threadId;
  final String message;

  const ProductSuggestionQuizRequired({
    required this.quizQuestions,
    required this.threadId,
    required this.message,
  });

  @override
  List<Object?> get props => [quizQuestions, threadId, message];
}

class ProductSuggestionSuccess extends ProductSuggestionState {
  final List<Product> products;
  final String message;

  const ProductSuggestionSuccess({
    required this.products,
    required this.message,
  });

  @override
  List<Object?> get props => [products, message];
}

class ProductSuggestionError extends ProductSuggestionState {
  final String error;

  const ProductSuggestionError({required this.error});

  @override
  List<Object?> get props => [error];
}

class QuizSubmissionLoading extends ProductSuggestionState {
  const QuizSubmissionLoading();
}
