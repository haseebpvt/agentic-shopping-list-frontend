import 'package:flutter/material.dart';
import '../widgets/ai_gradient_widget.dart';

// TODO: This is a temporary test screen for gradient development
// Remove this screen and revert main.dart when gradient is finalized
class GradientTestScreen extends StatefulWidget {
  const GradientTestScreen({super.key});

  @override
  State<GradientTestScreen> createState() => _GradientTestScreenState();
}

class _GradientTestScreenState extends State<GradientTestScreen> {
  bool _isGradientVisible = true;
  Duration _animationDuration = const Duration(seconds: 3);
  double _heightPercentage = 0.5; // Default 50%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI Gradient Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // AI Gradient
          AIGradientWidget(
            isVisible: _isGradientVisible,
            animationDuration: _animationDuration,
            heightPercentage: _heightPercentage,
          ),
          
          // Controls
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Card(
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gradient Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Toggle visibility
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Show Gradient:'),
                        Switch(
                          value: _isGradientVisible,
                          onChanged: (value) {
                            setState(() {
                              _isGradientVisible = value;
                            });
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Animation speed
                    const Text('Animation Speed:'),
                    Slider(
                      value: _animationDuration.inMilliseconds.toDouble(),
                      min: 500,
                      max: 10000,
                      divisions: 19,
                      label: '${(_animationDuration.inMilliseconds / 1000).toStringAsFixed(1)}s',
                      onChanged: (value) {
                        setState(() {
                          _animationDuration = Duration(milliseconds: value.round());
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Height percentage
                    const Text('Height from Bottom:'),
                    Slider(
                      value: _heightPercentage,
                      min: 0.1,
                      max: 1.0,
                      divisions: 18,
                      label: '${(_heightPercentage * 100).round()}%',
                      onChanged: (value) {
                        setState(() {
                          _heightPercentage = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Preset buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _animationDuration = const Duration(seconds: 1);
                            });
                          },
                          child: const Text('Fast'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _animationDuration = const Duration(seconds: 3);
                            });
                          },
                          child: const Text('Normal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _animationDuration = const Duration(seconds: 6);
                            });
                          },
                          child: const Text('Slow'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Sample content to test visibility
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Sample Content Card',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This card helps test how the gradient looks with content on top.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Sample Button'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
