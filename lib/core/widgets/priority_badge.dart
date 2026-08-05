import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/brain_item.dart';

class PriorityBadge extends StatelessWidget {
  final PriorityLevel priority;

  const PriorityBadge({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String label;

    switch (priority) {
      case PriorityLevel.high:
        badgeColor = AppColors.priorityHigh;
        label = 'HIGH';
        break;
      case PriorityLevel.medium:
        badgeColor = AppColors.priorityMedium;
        label = 'MED';
        break;
      case PriorityLevel.low:
        badgeColor = AppColors.priorityLow;
        label = 'LOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withOpacity(0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
