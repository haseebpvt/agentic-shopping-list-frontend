import 'dart:math' as math;
import 'package:flutter/material.dart';

class AIGradientWidget extends StatefulWidget {
  final bool isVisible;
  final Duration animationDuration;
  final double heightPercentage; // Percentage of screen height from bottom (0.0 to 1.0)
  
  const AIGradientWidget({
    super.key,
    this.isVisible = true,
    this.animationDuration = const Duration(seconds: 3),
    this.heightPercentage = 0.5, // Default to 50% of screen height
  });

  @override
  State<AIGradientWidget> createState() => _AIGradientWidgetState();
}

class _AIGradientWidgetState extends State<AIGradientWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  @override
  void initState() {
    super.initState();
    
    _gradientController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _gradientController,
      curve: Curves.linear,
    ));

    // Start gradient animation on repeat
    if (widget.isVisible) {
      _gradientController.repeat();
    }
  }

  @override
  void didUpdateWidget(AIGradientWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _gradientController.repeat();
      } else {
        _gradientController.stop();
      }
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return Container();

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        final animValue = _gradientAnimation.value;
        
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.of(context).size.height * widget.heightPercentage,
          child: Transform.rotate(
            angle: 0, // Start with no rotation, but we have the structure ready
            child: ShaderMask(
              shaderCallback: (rect) {
                // Adjust fade based on height - extreme fade for small heights
                final fadeStart = widget.heightPercentage > 0.8 
                    ? 0.7  // For very large heights, start fade at 70%
                    : widget.heightPercentage > 0.5
                        ? 0.2 + (widget.heightPercentage * 0.3) // Medium heights: aggressive fade
                        : widget.heightPercentage > 0.3
                            ? 0.1 + (widget.heightPercentage * 0.2) // Small heights: extreme fade
                            : widget.heightPercentage * 0.3; // Tiny heights: fade starts almost at bottom
                
                return LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: const [
                    Colors.white, // Full opacity at bottom
                    Colors.white, // Keep opacity for part of the area
                    Colors.transparent, // Fade to transparent at top
                  ],
                  stops: [0.0, fadeStart, 1.0], // Dynamic fade start
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft, // Left side
                    end: Alignment.centerRight, // Right side
                    stops: const [
                      0.0,
                      0.25,
                      0.5,
                      0.75,
                      1.0,
                    ],
                    colors: [
                    // Left: Red with pulsing intensity
                    Colors.red.withOpacity((0.6 + 0.3 * math.sin(animValue * 2 * math.pi)).clamp(0.3, 0.9)),
                    
                    // Left-center: Blue
                    Colors.blue.withOpacity((0.5 + 0.2 * math.sin(animValue * 2 * math.pi + math.pi/4)).clamp(0.3, 0.7)),
                    
                    // Center: Green
                    Colors.green.withOpacity((0.4 + 0.2 * math.sin(animValue * 2 * math.pi + math.pi/2)).clamp(0.2, 0.6)),
                    
                    // Right-center: Purple/Violet
                    Colors.purple.withOpacity((0.3 + 0.15 * math.sin(animValue * 2 * math.pi + 3*math.pi/4)).clamp(0.15, 0.45)),
                    
                    // Right: Transparent (fade out)
                    Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
