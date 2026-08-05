import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

class PrimaryRecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final double size;

  const PrimaryRecordButton({
    super.key,
    required this.isRecording,
    required this.onTap,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isRecording ? AppColors.micGradient : AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: (isRecording ? AppColors.micRecording : AppColors.primaryAccent).withOpacity(0.5),
              blurRadius: isRecording ? 24 : 16,
              spreadRadius: isRecording ? 6 : 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isRecording ? Icons.stop_rounded : Icons.mic_rounded,
            color: Colors.white,
            size: size * 0.45,
          ),
        ),
      ).animate(
        target: isRecording ? 1 : 0,
      ).scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.1, 1.1),
        duration: 800.ms,
        curve: Curves.easeInOut,
      ),
    );
  }
}
