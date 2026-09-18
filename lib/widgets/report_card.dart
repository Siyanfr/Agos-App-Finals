import 'package:flutter/material.dart';
import '../theme.dart';
import 'status_badge.dart';

class ReportCard extends StatelessWidget {
  final String reportTitle;
  final String status;
  final String date;
  final String location;
  final String? imageUrl;
  final VoidCallback onTap;

  const ReportCard({
    super.key,
    required this.reportTitle,
    required this.status,
    required this.date,
    required this.location,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: imageUrl == null
                  ? Container(
                      width: 56,
                      height: 56,
                      color: AppColors.surfaceTint,
                      child: const Icon(Icons.directions_car,
                          color: AppColors.primary),
                    )
                  : Image.network(
                      imageUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reportTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    location,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            StatusBadge(status: status, label: status.toUpperCase()),
          ],
        ),
      ),
    );
  }
}