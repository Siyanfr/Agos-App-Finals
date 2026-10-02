import 'package:flutter/material.dart';
import '../theme.dart';

class NavigationHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool showBrandIcon;

  const NavigationHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.showBrandIcon = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showBrandIcon) ...[
            Image.asset(
              'assets/agos_logo.png',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(
            title,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: actions,
    );
  }
}