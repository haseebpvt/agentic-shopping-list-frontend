import 'package:advanced_shopping_list_frontend/bloc/product_suggestion/product_suggestion.dart';
import 'package:advanced_shopping_list_frontend/photo_processing_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraScreen extends StatefulWidget {
  final CameraController controller;
  
  const CameraScreen({super.key, required this.controller});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Full screen camera preview
              CameraPreview(widget.controller),
              
              // Back button
              Positioned(
                top: 50,
                left: 16,
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // This will be handled by the PageView
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Status indicator
              if (state is ProductSuggestionLoading || state is QuizSubmissionLoading)
                Positioned(
                  top: 100,
                  left: 16,
                  right: 16,
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              state is ProductSuggestionLoading 
                                  ? state.message 
                                  : "Processing quiz answers...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Camera capture button
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: state is ProductSuggestionLoading ||
                            state is QuizSubmissionLoading
                        ? null
                        : () async {
                            print("📸 Camera button pressed");
                            
                            try {
                              final file = await widget.controller.takePicture();
                              print("📸 Picture taken: ${file.path}");
                              
                              if (!mounted) return;
                              
                              // Get the bloc reference before navigation
                              final bloc = context.read<ProductSuggestionBloc>();
                              
                              // Navigate to photo processing screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: bloc,
                                    child: PhotoProcessingScreen(
                                      imagePath: file.path,
                                    ),
                                  ),
                                ),
                              );
                              
                              // Start processing the image
                              print("📸 Dispatching GetProductSuggestionEvent");
                              bloc.add(GetProductSuggestionEvent(
                                userId: "8",
                                imageFile: file,
                              ));
                            } catch (e) {
                              print("📸 Error taking picture: $e");
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Failed to take picture: $e"),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state is ProductSuggestionLoading ||
                                state is QuizSubmissionLoading
                            ? Colors.grey
                            : Colors.white,
                        border: Border.all(
                          color: Colors.black.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: state is ProductSuggestionLoading ||
                                state is QuizSubmissionLoading
                            ? Colors.grey[600]
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              // Instruction text
              Positioned(
                bottom: 140,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Point camera at products and tap to capture",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
