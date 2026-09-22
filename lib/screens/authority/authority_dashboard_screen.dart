import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../theme.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/report_card.dart';
import '../../widgets/stat_summary_card.dart';
import '../login_screen.dart';
import 'report_action_screen.dart';

class AuthorityDashboardScreen extends StatefulWidget {
  const AuthorityDashboardScreen({super.key});

  @override
  State<AuthorityDashboardScreen> createState() =>
      _AuthorityDashboardScreenState();
}

class _AuthorityDashboardScreenState extends State<AuthorityDashboardScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  String _selectedFilter = 'All';

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
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
    return Scaffold(
      appBar: NavigationHeader(
        title: 'AGOS AUTHORITY',
        showBrandIcon: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: GestureDetector(
              onTap: _logout,
              child: const CircleAvatar(
                backgroundColor: AppColors.surfaceTint,
                child: Icon(Icons.person_outline, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<List<Report>>(
          stream: _firestoreService.allReports(statusFilter: _selectedFilter),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final reports = snapshot.data ?? [];
            // Pending/Resolved counts should reflect ALL reports, not just
            // the current filter, so fetch them unfiltered for the stat cards.
            return StreamBuilder<List<Report>>(
              stream: _firestoreService.allReports(),
              builder: (context, allSnapshot) {
                final allReports = allSnapshot.data ?? [];
                final pendingCount =
                    allReports.where((r) => r.status == 'Pending').length;
                final resolvedCount =
                    allReports.where((r) => r.status == 'Resolved').length;

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Row(
                      children: [
                        StatSummaryCard(
                          label: 'Total',
                          count: allReports.length,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    if (reports.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                        child: Text(
                          'No reports match this filter.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ...reports.map(
                      (report) => ReportCard(
                        reportTitle: report.description.split(',').first,
                        status: report.status,
                        date:
                            '${report.timestamp.month}/${report.timestamp.day}/${report.timestamp.year}',
                        location: report.locationName,
                        imageUrl: report.photoUrl,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReportActionScreen(report: report),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}