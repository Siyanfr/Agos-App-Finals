import 'package:flutter/material.dart';
import '../theme.dart';

class TextInputField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconTap;
  final bool multiline;

  const TextInputField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingIconTap,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          maxLines: multiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.surface,
            prefixIcon: leadingIcon == null ? null : Icon(leadingIcon),
            suffixIcon: trailingIcon == null
                ? null
                : IconButton(
                    icon: Icon(trailingIcon),
                    onPressed: onTrailingIconTap,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}