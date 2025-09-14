import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:advanced_shopping_list_frontend/core/services/speech_to_text_service.dart';
import 'package:advanced_shopping_list_frontend/core/core.dart';

enum MicState {
  inactive,
  loading,
  active,
}

class InlineVoiceRecordingWidget extends StatefulWidget {
  final String userId;
  final double size;

  const InlineVoiceRecordingWidget({
    super.key,
    required this.userId,
    this.size = 56.0,
  });

  @override
  State<InlineVoiceRecordingWidget> createState() => _InlineVoiceRecordingWidgetState();
}

class _InlineVoiceRecordingWidgetState extends State<InlineVoiceRecordingWidget>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  late SpeechToTextService _speechService;
  MicState _currentState = MicState.inactive;
  bool _isProcessing = false;
  String _currentTranscript = '';
  StreamSubscription<String>? _transcriptSubscription;

  @override
  void initState() {
    super.initState();

    // Initialize speech service with OpenAI API key
    _speechService = SpeechToTextService(ApiConstants.openAiApiKey);

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.value = 1.0; // Start with full opacity for inactive state
  }

  @override
  void dispose() {
    _transcriptSubscription?.cancel();
    _fadeController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _changeState(MicState newState) async {
    if (_currentState == newState) return;

    // Fade out current state
    await _fadeController.reverse();
    
    // Change state
    setState(() {
      _currentState = newState;
    });

    // Fade in new state
    await _fadeController.forward();
  }

  Future<void> _onMicTap() async {
    if (_isProcessing) return;

    switch (_currentState) {
      case MicState.inactive:
        await _startRecording();
        break;
      case MicState.active:
        await _stopRecording();
        break;
      case MicState.loading:
        // Do nothing while loading
        break;
    }
  }

  Future<void> _startRecording() async {
    // Change to loading state
    await _changeState(MicState.loading);
    
    setState(() {
      _isProcessing = true;
    });

    // Check permissions
    final hasPermission = await _speechService.hasPermission();
    if (!hasPermission) {
      final granted = await _speechService.requestPermission();
      if (!granted) {
        await _changeState(MicState.inactive);
        setState(() {
          _isProcessing = false;
        });
        
        // Show snackbar for permission error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Microphone permission required'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    try {
      // Start streaming transcription
      final transcriptStream = _speechService.startStreamingTranscription();

      // Listen to real-time progress updates
      _transcriptSubscription = transcriptStream.listen(
        (message) {
          setState(() {
            if (!message.startsWith('🎤')) {
              // This is an actual transcript
              _currentTranscript = message;
            }
          });
        },
        onError: (error) {
          print("❌ Transcript stream error: $error");
          _handleRecordingError('Recording error occurred');
        },
      );

      // Change to active state after everything is set up
      await _changeState(MicState.active);
      
      setState(() {
        _isProcessing = false;
        _currentTranscript = '';
      });

    } catch (e) {
      await _changeState(MicState.inactive);
      setState(() {
        _isProcessing = false;
      });
      _handleRecordingError('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    // Change to loading state
    await _changeState(MicState.loading);
    
    setState(() {
      _isProcessing = true;
    });

    // Stop streaming transcription
    _speechService.stopStreamingTranscription();
    await _transcriptSubscription?.cancel();
    _transcriptSubscription = null;

    // Stop the actual recording
    final audioPath = await _speechService.stopRecording();

    // Use the current transcript from streaming
    final finalTranscript = _currentTranscript.trim();

    if (finalTranscript.isNotEmpty) {
      print("🚀 Final transcript being sent to AI: $finalTranscript");

      // Send transcription to the same API used by AI suggestions
      if (mounted) {
        context.read<ShoppingListBloc>().add(
          InsertData(userId: widget.userId, userText: finalTranscript),
        );

        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voice input processed: "$finalTranscript"'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else if (audioPath != null) {
      // Use fast transcription since no streaming transcript available
      print("🚀 Performing fast transcription on completed recording");
      final transcription = await _speechService.transcribeAudio(audioPath);

      if (transcription != null && transcription.isNotEmpty) {
        print("🚀 Fast transcription result: $transcription");

        if (mounted) {
          context.read<ShoppingListBloc>().add(
            InsertData(userId: widget.userId, userText: transcription),
          );

          // Show success snackbar
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Voice input processed: "$transcription"'),
          //     backgroundColor: Colors.green,
          //     duration: const Duration(seconds: 3),
          //   ),
          // );
        }
      } else {
        _handleRecordingError('Failed to transcribe audio');
      }
    } else {
      _handleRecordingError('No audio recorded');
    }

    // Return to inactive state
    await _changeState(MicState.inactive);
    setState(() {
      _isProcessing = false;
      _currentTranscript = '';
    });
  }

  void _handleRecordingError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildLottieAnimation() {
    String assetPath;
    switch (_currentState) {
      case MicState.inactive:
        assetPath = 'assets/mic_inactive.json';
        break;
      case MicState.loading:
        assetPath = 'assets/mic_blank.json';
        break;
      case MicState.active:
        assetPath = 'assets/mic_active.json';
        break;
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Lottie.asset(
              assetPath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.contain,
              repeat: _currentState == MicState.active,
            ),
          ),
          // Show smaller circular loading indicator when in loading state
          if (_currentState == MicState.loading)
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: widget.size * 0.2, // Even smaller for internal loading
                height: widget.size * 0.2,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListBloc, ShoppingListState>(
      builder: (context, state) {
        final isInserting = state is ShoppingListInserting;
        
        return GestureDetector(
          onTap: isInserting ? null : _onMicTap,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildLottieAnimation(),
                // Show API loading overlay when inserting
                if (isInserting)
                  Center(
                    child: SizedBox(
                      width: widget.size * 0.25, // Smaller loading indicator
                      height: widget.size * 0.25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
