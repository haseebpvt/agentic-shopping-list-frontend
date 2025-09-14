import 'dart:io';
import 'package:advanced_shopping_list_frontend/core/bloc/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/core/models/model/quiz_resume/quiz_resume.dart';
import '../widgets/suggested_product_view.dart';
import '../widgets/product_details_dialog.dart';
import '../widgets/ai_gradient_widget.dart';
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
  
  // Cache flag to track if we need to rebuild the background image
  bool _backgroundImageCacheInvalid = true;
  
  // Store quiz data to keep it visible
  ProductSuggestionQuizRequired? _quizData;

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
  }

  @override
  void dispose() {
    _statusCardController.dispose();
    _quizCardController.dispose();
    _resultsCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductSuggestionBloc, ProductSuggestionState>(
        listener: (context, state) {
          if (state is ProductSuggestionQuizRequired) {
            // Store quiz data and animate quiz card when quiz is required
            _quizData = state;
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
            // Header background image
            _createBackgroundImage(context),
            
            // Background color for the rest of the screen
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),

            // AI Gradient overlay (only during loading)
            BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
              builder: (context, state) {
                final isLoading = state is ProductSuggestionLoading || state is QuizSubmissionLoading;
                return AIGradientWidget(
                  isVisible: isLoading,
                  heightPercentage: 0.3, // Cover 30% of screen from bottom with nice fade
                );
              },
            ),

            // Progressive card stack from bottom
            _buildProgressiveCards(),
            
            // Back button (placed last to be on top of other elements)
            _buildBackButton(),
          ],
        ),
      ),
    );
  }

  Widget _createBackgroundImage(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.2, // Header takes 20% of screen height
      child: RepaintBoundary(
        child: ShaderMask(
          shaderCallback: (rect) {
            return const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white, // Full opacity at top
                Colors.white, // Keep full opacity for most of the header
                Colors.transparent, // Fade to transparent at bottom of header
              ],
              stops: [0.0, 0.4, 1.0], // Start fading at 40% of header height for smoother transition
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
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
        return Positioned.fill(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Add spacing to push content below the image header
                  SizedBox(height: MediaQuery.of(context).size.height * 0.5),
                  
                  // Status/Progress Card (always visible)
                  SlideTransition(
                    position: _statusCardAnimation,
                    child: _buildStatusCard(state),
                  ),

                  // Quiz Card (visible when quiz data is available)
                  if (_quizData != null) ...[
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
                  
                  // Add bottom padding for better scrolling experience
                  const SizedBox(height: 100),
                ],
              ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Loading animation or status icon positioned above text
            RepaintBoundary(
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        width: 100, // Even bigger size
                        height: 100, // Even bigger size
                        child: Lottie.asset(
                          'assets/ai_loading.json',
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
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
                        size: 48, // Bigger icon size
                      ),
                    ),
            ),
            // Message text below the animation/icon
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(ProductSuggestionState state) {
    // Use stored quiz data if available
    final quizData = _quizData;
    if (quizData == null) return Container();
    
    // If we're in success state but quiz was completed, show a completed state
    if (state is ProductSuggestionSuccess) {
      return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
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
              questions: quizData.quizQuestions,
              onQuizCompleted: (data) {
                final questionAndAnswers = data.map((item) {
                  return "${item.question}: ${item.selectedAnswer}";
                }).toList();

                print("📝 Submitting quiz with ${questionAndAnswers.length} answers");
                print("📝 Thread ID: ${quizData.threadId}");
                context.read<ProductSuggestionBloc>().add(
                  SubmitQuizEvent(
                    quizRequest: QuizResumeRequest(
                      threadId: quizData.threadId,
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            // Product suggestions as column items (no separate scroll)
            ...state.products.map((product) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SuggestedProductView(
                product: product,
                onTap: () => _showProductDetails(context, product),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => ProductDetailsDialog(product: product),
    );
  }
}
