import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AudioWaveformVisualizer extends StatefulWidget {
  final bool isRecording;
  const AudioWaveformVisualizer({super.key, required this.isRecording});

  @override
  State<AudioWaveformVisualizer> createState() => _AudioWaveformVisualizerState();
}

class _AudioWaveformVisualizerState extends State<AudioWaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAlignment.center,
          children: List.generate(24, (index) {
            final double baseHeight = widget.isRecording
                ? sin((index + _controller.value * 10)) * 25 + 30
                : 6.0;
            final double height = (baseHeight + _random.nextDouble() * 8).clamp(4.0, 55.0);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3.5,
              height: height,
              decoration: BoxDecoration(
                color: widget.isRecording ? AppColors.micRecording : AppColors.primaryGlow.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
