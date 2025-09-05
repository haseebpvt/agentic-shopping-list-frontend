import 'package:advanced_shopping_list_frontend/bloc/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/data/model/quiz_resume/quiz_resume.dart';
import 'package:advanced_shopping_list_frontend/suggested_product_view.dart';
import 'package:animated_quiz_widget/quiz_view.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/api_service.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const CameraApp());
}

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ProductSuggestionBloc(
          apiService: ApiServiceImpl(
            Dio(BaseOptions(baseUrl: "http://10.0.2.2:8000")),
          ),
        ),
        child: const CameraScreen(),
      ),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
        builder: (context, state) {
          print("🎨 UI State changed to: ${state.runtimeType}");
          return Column(
            children: [
              // Camera Section
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: SizedBox(
                      height: 300,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CameraPreview(controller),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: state is ProductSuggestionLoading ||
                            state is QuizSubmissionLoading
                        ? null
                        : () async {
                            print("📸 Camera button pressed");
                            final file = await controller.takePicture();
                            print("📸 Picture taken: ${file.path}");
                            if (!mounted) return;
                            print("📸 Dispatching GetProductSuggestionEvent");
                            context
                                .read<ProductSuggestionBloc>()
                                .add(GetProductSuggestionEvent(
                                  userId: "8",
                                  imageFile: file,
                                ));
                          },
                    icon: const Icon(Icons.camera),
                  ),
                ],
              ),

              // Status/Message Section
              _buildStatusSection(state),

              // Quiz Section
              if (state is ProductSuggestionQuizRequired)
                _buildQuizSection(context, state),

              // Products List Section
              if (state is ProductSuggestionSuccess)
                _buildProductsList(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusSection(ProductSuggestionState state) {
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

  Widget _buildProductsList(ProductSuggestionSuccess state) {
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
}
