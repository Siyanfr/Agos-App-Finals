import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme.dart';

class ImageUploadComponent extends StatelessWidget {
  final String? image; // file path (mobile) or blob URL (web)
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  const ImageUploadComponent({
    super.key,
    this.image,
    required this.onUpload,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: kIsWeb
                ? Image.network(
                    image!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(image!),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: CircleAvatar(
              backgroundColor: AppColors.surface,
              child: IconButton(
                icon: const Icon(Icons.close, color: AppColors.error),
                onPressed: onRemove,
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onUpload,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.surfaceTint, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.camera_alt, color: AppColors.onPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Take a photo or choose from gallery',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}