import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:advanced_shopping_list_frontend/core/services/speech_to_text_service.dart';
import 'package:advanced_shopping_list_frontend/core/core.dart';

class VoiceRecordingWidget extends StatefulWidget {
  final String userId;
  final VoidCallback? onClose;

  const VoiceRecordingWidget({
    super.key,
    required this.userId,
    this.onClose,
  });

  @override
  State<VoiceRecordingWidget> createState() => _VoiceRecordingWidgetState();
}

class _VoiceRecordingWidgetState extends State<VoiceRecordingWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;
  
  late SpeechToTextService _speechService;
  bool _isRecording = false;
  bool _isProcessing = false;
  String _status = 'Tap to start recording';

  @override
  void initState() {
    super.initState();
    
    // Initialize speech service with OpenAI API key
    _speechService = SpeechToTextService(ApiConstants.openAiApiKey);
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isProcessing) return;

    if (!_isRecording) {
      await _startRecording();
    } else {
      await _stopRecording();
    }
  }

  Future<void> _startRecording() async {
    setState(() {
      _status = 'Checking permissions...';
    });

    final hasPermission = await _speechService.hasPermission();
    if (!hasPermission) {
      final granted = await _speechService.requestPermission();
      if (!granted) {
        setState(() {
          _status = 'Microphone permission required';
        });
        return;
      }
    }

    setState(() {
      _status = 'Starting recording...';
    });

    final started = await _speechService.startRecording();
    if (started) {
      setState(() {
        _isRecording = true;
        _status = 'Recording... Tap to stop';
      });
      
      // Start animations
      _pulseController.repeat(reverse: true);
      _waveController.repeat(reverse: true);
    } else {
      setState(() {
        _status = 'Failed to start recording';
      });
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isProcessing = true;
      _status = 'Processing...';
    });

    // Stop animations
    _pulseController.stop();
    _waveController.stop();

    final audioPath = await _speechService.stopRecording();
    
    if (audioPath != null) {
      setState(() {
        _status = 'Transcribing...';
      });

      final transcription = await _speechService.transcribeAudio(audioPath);
      
      if (transcription != null && transcription.isNotEmpty) {
        setState(() {
          _status = 'Sending to AI...';
        });

        // Send transcription to the same API used by AI suggestions
        context.read<ShoppingListBloc>().add(
          InsertData(userId: widget.userId, userText: transcription),
        );

        setState(() {
          _status = 'Done! Added: "$transcription"';
        });

        // Close the widget after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            widget.onClose?.call();
          }
        });
      } else {
        setState(() {
          _status = 'Failed to transcribe audio';
        });
      }
    } else {
      setState(() {
        _status = 'Failed to save recording';
      });
    }

    setState(() {
      _isRecording = false;
      _isProcessing = false;
    });
  }

  Widget _buildMicrophoneButton() {
    return GestureDetector(
      onTap: _toggleRecording,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isRecording ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording 
                    ? Colors.red 
                    : _isProcessing 
                        ? Colors.orange 
                        : Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording ? Colors.red : Theme.of(context).primaryColor)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: _isRecording ? 10 : 5,
                  ),
                ],
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white,
                      size: 40,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWaveAnimation() {
    if (!_isRecording) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 60),
          painter: WavePainter(_waveAnimation.value),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            'Voice Input',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Wave animation
          _buildWaveAnimation(),
          if (_isRecording) const SizedBox(height: 20),
          
          // Microphone button
          _buildMicrophoneButton(),
          const SizedBox(height: 20),
          
          // Status text
          Text(
            _status,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Close button
          if (!_isRecording && !_isProcessing)
            TextButton(
              onPressed: widget.onClose,
              child: const Text('Close'),
            ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 4;

    path.moveTo(0, size.height / 2);

    for (double i = 0; i <= size.width; i++) {
      final y = size.height / 2 + 
          waveHeight * 
          math.sin(i / waveLength * 2 * math.pi) * 
          math.sin(animationValue * 2 * math.pi);
      path.lineTo(i, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

