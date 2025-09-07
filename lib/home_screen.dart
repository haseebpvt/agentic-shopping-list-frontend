import 'package:advanced_shopping_list_frontend/bloc/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/data/model/quiz_resume/quiz_resume.dart';
import 'package:advanced_shopping_list_frontend/suggested_product_view.dart';
import 'package:animated_quiz_widget/quiz_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
        builder: (context, state) {
          print("🎨 UI State changed to: ${state.runtimeType}");
          return Column(
            children: [
              // Welcome Section
              _buildWelcomeSection(context),

              // Status/Message Section
              _buildStatusSection(context, state),

              // Quiz Section
              if (state is ProductSuggestionQuizRequired)
                _buildQuizSection(context, state),

              // Products List Section
              if (state is ProductSuggestionSuccess)
                _buildProductsList(context, state),

              // Empty state or instructions
              if (state is ProductSuggestionInitial)
                _buildInstructionsSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40), // Status bar spacing
          Text(
            "Smart Shopping List",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Swipe right to scan products with your camera →",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, ProductSuggestionState state) {
    String message = "Ready to take a picture";
    
    if (state is ProductSuggestionLoading) {
      message = state.message; // Show the streaming message
    } else if (state is QuizSubmissionLoading) {
      message = "Processing quiz answers...";
    } else if (state is ProductSuggestionQuizRequired) {
      message = state.message;
    } else if (state is ProductSuggestionSuccess) {
      message = state.message;
    } else if (state is ProductSuggestionError) {
      message = "Error: ${state.error}";
    } else if (state is ProductSuggestionInitial) {
      message = "Swipe right to access the camera and start scanning products";
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (state is ProductSuggestionLoading || state is QuizSubmissionLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizSection(BuildContext context, ProductSuggestionQuizRequired state) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: QuizWidget(
          questions: state.quizQuestions,
          onQuizCompleted: (data) {
            final questionAndAnswers = data.map((item) {
              return "${item.question}: ${item.selectedAnswer}";
            }).toList();

            print("📝 Submitting quiz with ${questionAndAnswers.length} answers");
            print("📝 Thread ID: ${state.threadId}");
            context.read<ProductSuggestionBloc>().add(
                  SubmitQuizEvent(
                    quizRequest: QuizResumeRequest(
                      threadId: state.threadId,
                      questionAndAnswers: questionAndAnswers,
                    ),
                  ),
                );
          },
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context, ProductSuggestionSuccess state) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Suggested Products (${state.products.length})",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<ProductSuggestionBloc>().add(const ResetEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: "Take another picture",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: SuggestedProductView(product: product),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsSection(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 80,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
              const SizedBox(height: 24),
              Text(
                "Welcome to Smart Shopping!",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Swipe right to access the camera and start scanning products. Our AI will analyze your images and suggest the best products for your shopping list.",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.swipe, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Swipe Right",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
