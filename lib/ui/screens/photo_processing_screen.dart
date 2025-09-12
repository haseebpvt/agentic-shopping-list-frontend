import 'dart:io';
import 'package:advanced_shopping_list_frontend/core/bloc/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/quiz_resume/quiz_resume.dart';
import '../widgets/suggested_product_view.dart';
import 'package:animated_quiz_widget/quiz_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PhotoProcessingScreen extends StatefulWidget {
  final String imagePath;
  
  const PhotoProcessingScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<PhotoProcessingScreen> createState() => _PhotoProcessingScreenState();
}

class _PhotoProcessingScreenState extends State<PhotoProcessingScreen>
    with TickerProviderStateMixin {
  late AnimationController _statusCardController;
  late AnimationController _quizCardController;
  late AnimationController _resultsCardController;
  
  late Animation<Offset> _statusCardAnimation;
  late Animation<Offset> _quizCardAnimation;
  late Animation<Offset> _resultsCardAnimation;
  
  // Cache the image widget to prevent repeated file reads
  Widget? _cachedBackgroundImage;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _statusCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _quizCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _resultsCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create slide-up animations
    _statusCardAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _statusCardController,
      curve: Curves.easeOutQuart,
    ));

    _quizCardAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _quizCardController,
      curve: Curves.easeOutQuart,
    ));

    _resultsCardAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _resultsCardController,
      curve: Curves.easeOutQuart,
    ));

    // Start with status card animation
    _statusCardController.forward();
    
    // Pre-create and cache the background image widget
    _cachedBackgroundImage = _createBackgroundImage();
  }

  @override
  void dispose() {
    _statusCardController.dispose();
    _quizCardController.dispose();
    _resultsCardController.dispose();
    // Clear the cached image widget
    _cachedBackgroundImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductSuggestionBloc, ProductSuggestionState>(
        listener: (context, state) {
          if (state is ProductSuggestionQuizRequired) {
            // Animate quiz card when quiz is required
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _quizCardController.forward();
              }
            });
          } else if (state is ProductSuggestionSuccess) {
            // Animate results card when results are ready
            // Keep quiz card visible if it was already shown
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                _resultsCardController.forward();
              }
            });
          }
        },
        child: Stack(
          children: [
            // Full screen background image (cached)
            _cachedBackgroundImage ?? Container(),
            
            // Dark overlay for better card visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
            ),

            // Back button
            _buildBackButton(),

            // Progressive card stack from bottom
            _buildProgressiveCards(),
          ],
        ),
      ),
    );
  }

  Widget _createBackgroundImage() {
    return Positioned.fill(
      child: RepaintBoundary(
        child: Image.file(
          File(widget.imagePath),
          fit: BoxFit.cover,
          // Add cacheWidth and cacheHeight to optimize memory usage and prevent buffer overflow
          cacheWidth: 1080, // Reduced from 1920 to further optimize memory
          cacheHeight: 720, // Reduced from 1080 to further optimize memory
          filterQuality: FilterQuality.medium, // Balance quality and performance
          errorBuilder: (context, error, stackTrace) {
            print('Error loading background image: $error');
            return Container(
              color: Colors.grey[100],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 50,
      left: 16,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Reset the bloc state and navigate back
            context.read<ProductSuggestionBloc>().add(const ResetEvent());
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressiveCards() {
    return BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
      buildWhen: (previous, current) {
        // Only rebuild when the state type changes or when transitioning to/from certain states
        if (previous.runtimeType != current.runtimeType) return true;
        if (current is ProductSuggestionLoading && previous is ProductSuggestionLoading) {
          // For loading states, only rebuild if the message changes significantly
          // to avoid constant rebuilds during streaming updates
          return current.message != previous.message;
        }
        return true;
      },
      builder: (context, state) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status/Progress Card (always visible)
                SlideTransition(
                  position: _statusCardAnimation,
                  child: _buildStatusCard(state),
                ),

                // Quiz Card (visible when quiz is required or completed)
                if (state is ProductSuggestionQuizRequired || 
                    (state is ProductSuggestionSuccess && _quizCardController.isCompleted)) ...[
                  const SizedBox(height: 12),
                  SlideTransition(
                    position: _quizCardAnimation,
                    child: _buildQuizCard(state),
                  ),
                ],

                // Results Card (visible when results are available)
                if (state is ProductSuggestionSuccess) ...[
                  const SizedBox(height: 12),
                  SlideTransition(
                    position: _resultsCardAnimation,
                    child: _buildResultsCard(state),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(ProductSuggestionState state) {
    String message = "Processing your image...";
    bool isLoading = false;
    
    if (state is ProductSuggestionLoading) {
      message = state.message;
      isLoading = true;
    } else if (state is QuizSubmissionLoading) {
      message = "Processing quiz answers...";
      isLoading = true;
    } else if (state is ProductSuggestionQuizRequired) {
      message = "Please answer the questions below";
      isLoading = false;
    } else if (state is ProductSuggestionSuccess) {
      message = "Analysis complete! Check your results below.";
      isLoading = false;
    } else if (state is ProductSuggestionError) {
      message = "Error: ${state.error}";
      isLoading = false;
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            // Use repaint boundary to isolate loading indicator animation
            RepaintBoundary(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 32,
                        height: 32,
                        child: Lottie.asset(
                          'assets/ai_loading.json',
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Icon(
                        state is ProductSuggestionError 
                            ? Icons.error_outline 
                            : state is ProductSuggestionSuccess
                                ? Icons.check_circle_outline
                                : Icons.help_outline,
                        color: state is ProductSuggestionError 
                            ? Colors.red 
                            : state is ProductSuggestionSuccess
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
            ),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(ProductSuggestionState state) {
    // For ProductSuggestionSuccess state, we need to get the quiz data from the previous state
    // This is a simplified approach - in a real app you might want to store this data separately
    if (state is! ProductSuggestionQuizRequired) {
      // If we're in success state but quiz was completed, show a completed state
      return Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Quiz Completed",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Thank you for providing additional information. Your responses have been processed.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: QuizWidget(
              questions: (state as ProductSuggestionQuizRequired).quizQuestions,
              onQuizCompleted: (data) {
                final questionAndAnswers = data.map((item) {
                  return "${item.question}: ${item.selectedAnswer}";
                }).toList();

                print("📝 Submitting quiz with ${questionAndAnswers.length} answers");
                print("📝 Thread ID: ${(state as ProductSuggestionQuizRequired).threadId}");
                context.read<ProductSuggestionBloc>().add(
                  SubmitQuizEvent(
                    quizRequest: QuizResumeRequest(
                      threadId: (state as ProductSuggestionQuizRequired).threadId,
                      questionAndAnswers: questionAndAnswers,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard(ProductSuggestionSuccess state) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Suggested Products (${state.products.length})",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<ProductSuggestionBloc>().add(const ResetEvent());
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.home_outlined),
                    tooltip: "Back to Home",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
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
}
