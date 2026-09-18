import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../theme.dart';
import '../../widgets/detail_modal.dart';
import '../../widgets/detail_row.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/report_card.dart';
import '../../widgets/stat_summary_card.dart';
import '../../widgets/status_badge.dart';
import 'submit_report_screen.dart';

class CitizenDashboardScreen extends StatelessWidget {
  const CitizenDashboardScreen({super.key});

  // Placeholder data until Firestore is wired in.
  List<Report> get _placeholderReports => [
        Report(
          id: 'RPT-2026-07-8921',
          reporterId: 'citizen1',
          description:
              'Vehicle is illegally double-parked, obstructing the roadway and impeding the normal flow of traffic.',
          locationName: 'Angeles City, Pampanga',
          timestamp: DateTime(2026, 7, 20, 9, 45),
          status: 'Pending',
        ),
        Report(
          id: 'RPT-2026-07-8922',
          reporterId: 'citizen1',
          description: 'Vehicle blocking fire hydrant access.',
          locationName: 'San Fernando, Pampanga',
          timestamp: DateTime(2026, 7, 20, 10, 0),
          status: 'Pending',
        ),
        Report(
          id: 'RPT-2026-07-8923',
          reporterId: 'citizen1',
          description: 'Vehicle parked directly on the pedestrian crosswalk.',
          locationName: 'Mabalacat, Pampanga',
          timestamp: DateTime(2026, 7, 15, 14, 0),
          status: 'Resolved',
        ),
      ];

  void _showReportDetails(BuildContext context, Report report) {
    showDialog(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (context) => DetailModal(
        title: 'Report Details',
        onClose: () => Navigator.of(context).pop(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.surfaceTint,
                    child: const Icon(Icons.directions_car,
                        size: 48, color: AppColors.primary),
                  ),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: StatusBadge(
                    status: report.status,
                    label: report.status.toUpperCase(),
                    onImage: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'VIOLATION DESCRIPTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: AppColors.statusPending,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(report.description),
            const SizedBox(height: AppSpacing.md),
            DetailRow(
              icon: Icons.location_on_outlined,
              label: 'Location',
              value: report.locationName,
            ),
            DetailRow(
              icon: Icons.access_time,
              label: 'Submitted',
              value:
                  '${report.timestamp.month}/${report.timestamp.day}/${report.timestamp.year}, ${report.timestamp.hour}:${report.timestamp.minute.toString().padLeft(2, '0')}',
            ),
            DetailRow(
              icon: Icons.tag,
              label: 'ID',
              value: report.id,
            ),
          ],
        ),
        actionButton: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            label: 'Close Details',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reports = _placeholderReports;
    final pendingCount = reports.where((r) => r.status == 'Pending').length;

    return Scaffold(
      appBar: NavigationHeader(
        title: 'AGOS',
        showBrandIcon: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: CircleAvatar(
              backgroundColor: AppColors.surfaceTint,
              child: const Icon(Icons.person_outline, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Good morning, Cean',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Here's a quick overview of your reports.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                StatSummaryCard(
                  label: 'Total Reports',
                  count: reports.length,
                  icon: Icons.description_outlined,
                ),
                const SizedBox(width: AppSpacing.sm),
                StatSummaryCard(
                  label: 'Pending',
                  count: pendingCount,
                  icon: Icons.pending_actions,
                  highlighted: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: '+ Submit New Report',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SubmitReportScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Reports',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () => debugPrint('See all tapped'),
                  child: const Text(
                    'See All',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...reports.map(
              (report) => ReportCard(
                reportTitle: report.description.split(',').first,
                status: report.status,
                date:
                    '${report.timestamp.month}/${report.timestamp.day}/${report.timestamp.year}',
                location: report.locationName,
                onTap: () => _showReportDetails(context, report),
              ),
            ),
          ],
        ),
      ),
    );
  }
}