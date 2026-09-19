import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../theme.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/report_card.dart';
import '../../widgets/stat_summary_card.dart';
import 'report_action_screen.dart';

class AuthorityDashboardScreen extends StatefulWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  State<AuthorityDashboardScreen> createState() =>
      _AuthorityDashboardScreenState();
}

class _AuthorityDashboardScreenState extends State<AuthorityDashboardScreen> {
  String _selectedFilter = 'All';

  // Placeholder data until Firestore is wired in.
  List<Report> get _placeholderReports => [
        Report(
          id: 'RPT-2026-07-8921',
          reporterId: 'citizen1',
          description: 'Vehicle illegally parked beside a fire hydrant.',
          locationName: 'Angeles City, Pampanga',
          timestamp: DateTime(2026, 7, 20, 9, 45),
          status: 'Pending',
        ),
        Report(
          id: 'RPT-2026-07-8922',
          reporterId: 'citizen1',
          description: 'Double parking blocking a full lane.',
          locationName: 'San Fernando, Pampanga',
          timestamp: DateTime(2026, 7, 20, 10, 0),
          status: 'Pending',
        ),
        Report(
          id: 'RPT-2026-07-8923',
          reporterId: 'citizen2',
          description: 'Vehicle parked on the pedestrian crosswalk.',
          locationName: 'Mabalacat, Pampanga',
          timestamp: DateTime(2026, 7, 15, 14, 0),
          status: 'Resolved',
        ),
        Report(
          id: 'RPT-2026-07-8924',
          reporterId: 'citizen2',
          description: 'Vehicle left on the sidewalk overnight.',
          locationName: 'Balibago, Angeles City',
          timestamp: DateTime(2026, 7, 8, 8, 0),
          status: 'Rejected',
        ),
      ];

  List<Report> get _filteredReports {
    final all = _placeholderReports;
    if (_selectedFilter == 'All') return all;
    return all.where((r) => r.status == _selectedFilter).toList();
  }

  Widget _filterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = label),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
        ),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reports = _placeholderReports;
    final pendingCount = reports.where((r) => r.status == 'Pending').length;
    final resolvedCount = reports.where((r) => r.status == 'Resolved').length;

    return Scaffold(
      appBar: NavigationHeader(
        title: 'AGOS AUTHORITY',
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
            Row(
              children: [
                StatSummaryCard(
                  label: 'Total',
                  count: reports.length,
                  icon: Icons.description_outlined,
                ),
                const SizedBox(width: AppSpacing.sm),
                StatSummaryCard(
                  label: 'Pending',
                  count: pendingCount,
                  icon: Icons.hourglass_empty,
                ),
                const SizedBox(width: AppSpacing.sm),
                StatSummaryCard(
                  label: 'Resolved',
                  count: resolvedCount,
                  icon: Icons.check_circle_outline,
                  highlighted: true,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Incoming City Reports',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              'Angeles City Jurisdiction',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('All'),
                  _filterChip('Pending'),
                  _filterChip('Resolved'),
                  _filterChip('Rejected'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._filteredReports.map(
              (report) => ReportCard(
                reportTitle: report.description.split(',').first,
                status: report.status,
                date:
                    '${report.timestamp.month}/${report.timestamp.day}/${report.timestamp.year}',
                location: report.locationName,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ReportActionScreen(report: report),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}