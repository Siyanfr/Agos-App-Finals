import 'package:flutter/material.dart';
import '../theme.dart';

class StatSummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool highlighted;

  const StatSummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: highlighted ? AppColors.secondary.withOpacity(0.15) : AppColors.surfaceTint,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: highlighted ? AppColors.secondary : AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '$count',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              label.toUpperCase(),
              style: const TextStyle(fontSize: 11, color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}