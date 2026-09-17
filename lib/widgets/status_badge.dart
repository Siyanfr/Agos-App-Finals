import 'package:flutter/material.dart';
import '../theme.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final String label;
  final bool onImage;

  const StatusBadge({
    super.key,
    required this.status,
    required this.label,
    this.onImage = false,
  });

  Color _textColor() {
    if (status == 'Pending') {
      return AppColors.statusPending;
    }
    if (status == 'Resolved') {
      return AppColors.statusResolved;
    }
    return AppColors.statusRejected;
  }

  Color _bgColor() {
    if (onImage) {
      return AppColors.surface;
    }
    if (status == 'Pending') {
      return AppColors.statusPendingBg;
    }
    if (status == 'Resolved') {
      return AppColors.statusResolved.withOpacity(0.12);
    }
    return AppColors.statusRejected.withOpacity(0.12);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _bgColor(),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _textColor(),
        ),
      ),
    );
  }
}