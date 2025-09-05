import 'package:advanced_shopping_list_frontend/data/model/quiz_resume/quiz_resume.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class ProductSuggestionEvent extends Equatable {
  const ProductSuggestionEvent();

  @override
  List<Object?> get props => [];
}

class GetProductSuggestionEvent extends ProductSuggestionEvent {
  final String userId;
  final XFile imageFile;

  const GetProductSuggestionEvent({
    required this.userId,
    required this.imageFile,
  });

  @override
  List<Object?> get props => [userId, imageFile];
}

class SubmitQuizEvent extends ProductSuggestionEvent {
  final QuizResumeRequest quizRequest;

  const SubmitQuizEvent({required this.quizRequest});

  @override
  List<Object?> get props => [quizRequest];
}

class ResetEvent extends ProductSuggestionEvent {
  const ResetEvent();
}
