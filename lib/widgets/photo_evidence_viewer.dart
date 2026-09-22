import 'package:flutter/material.dart';
import '../theme.dart';
import 'status_badge.dart';

class PhotoEvidenceViewer extends StatelessWidget {
  final List<String> images;
  final String? mapThumbnailUrl;
  final String status;

  const PhotoEvidenceViewer({
    super.key,
    required this.images,
    this.mapThumbnailUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Container(
                width: double.infinity,
                height: 220,
                color: AppColors.surfaceTint,
                child: const Icon(Icons.directions_car,
                    size: 56, color: AppColors.primary),
              ),
            ),
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: StatusBadge(
                status: status,
                label: status.toUpperCase(),
                onImage: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}