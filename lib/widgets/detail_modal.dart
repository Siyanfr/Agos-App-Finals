import 'package:flutter/material.dart';
import '../theme.dart';

class DetailModal extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final Widget child;
  final Widget? actionButton;

  const DetailModal({
    super.key,
    required this.title,
    required this.onClose,
    required this.child,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            child,
            if (actionButton != null) ...[
              const SizedBox(height: AppSpacing.md),
              actionButton!,
            ],
          ],
        ),
      ),
    );
  }
}