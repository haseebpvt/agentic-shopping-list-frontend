import 'package:advanced_shopping_list_frontend/core/bloc/product_suggestion/product_suggestion.dart';
import 'photo_processing_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const CameraScreen({super.key, required this.cameras});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isDisposing = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Add a small delay to ensure proper initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isDisposing) {
        _initializeCamera();
      }
    });
  }

  @override
  void dispose() {
    _isDisposing = true;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose().timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        print('Camera disposal timed out, forcing disposal');
      },
    );
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isDisposing || _isCapturing) {
      return;
    }

    switch (state) {
      case AppLifecycleState.paused:
        _pauseCamera();
        break;
      case AppLifecycleState.resumed:
        if (!_isDisposing && !_isCapturing) {
          _initializeCamera();
        }
        break;
      default:
        break;
    }
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty || _isDisposing) return;

    // Dispose existing controller if any
    await _controller?.dispose();
    
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium, // Use medium resolution to reduce buffer usage
      enableAudio: false, // Disable audio to reduce resource usage
      imageFormatGroup: ImageFormatGroup.jpeg, // Use JPEG for smaller file sizes
    );

    try {
      await _controller!.initialize();
      if (mounted && !_isDisposing) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
      if (mounted && !_isDisposing) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pauseCamera() async {
    if (_controller != null && _controller!.value.isInitialized && !_isDisposing && !_isCapturing) {
      try {
        await _controller!.dispose().timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            print('Camera pause disposal timed out');
          },
        );
      } catch (e) {
        print('Error disposing camera: $e');
      }
      if (mounted && !_isDisposing) {
        setState(() {
          _isInitialized = false;
          _controller = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (!_isInitialized || _controller == null) {
      return Scaffold(
        body: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[100],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 64,
                    color: Colors.white24,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Initializing camera...',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: BlocBuilder<ProductSuggestionBloc, ProductSuggestionState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Full screen camera preview without stretching (crops to fit)
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.previewSize?.height ?? 1,
                    height: _controller!.value.previewSize?.width ?? 1,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
              
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
                            if (_isCapturing) return;
                            
                            setState(() {
                              _isCapturing = true;
                            });
                            
                            print("📸 Camera button pressed");
                            
                            try {
                              final file = await _controller!.takePicture();
                              print("📸 Picture taken: ${file.path}");
                              
                              if (!mounted) return;
                              
                              // Force a brief pause to ensure image buffer is properly released
                              await Future.delayed(const Duration(milliseconds: 100));
                              
                              // Get the bloc reference before navigation
                              final bloc = context.read<ProductSuggestionBloc>();
                              
                              // Start processing the image first
                              print("📸 Dispatching GetProductSuggestionEvent");
                              bloc.add(GetProductSuggestionEvent(
                                userId: "8",
                                imageFile: file,
                              ));
                              
                              // Navigate to photo processing screen without disposing camera
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: bloc,
                                    child: PhotoProcessingScreen(
                                      imagePath: file.path,
                                    ),
                                  ),
                                ),
                              );
                              
                              // Camera remains active and ready for next capture
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
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isCapturing = false;
                                });
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
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).textTheme.bodyLarge?.color,
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
