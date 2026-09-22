import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/report_model.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../theme.dart';
import '../../widgets/detail_modal.dart';
import '../../widgets/detail_row.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/report_card.dart';
import '../../widgets/stat_summary_card.dart';
import '../../widgets/status_badge.dart';
import '../login_screen.dart';
import 'submit_report_screen.dart';

class CitizenDashboardScreen extends StatefulWidget {
  const CitizenDashboardScreen({super.key});

  @override
  State<CitizenDashboardScreen> createState() =>
      _CitizenDashboardScreenState();
}

class _CitizenDashboardScreenState extends State<CitizenDashboardScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final appUser = await _authService.getCurrentAppUser();
    if (mounted && appUser != null) {
      setState(() => _fullName = appUser.fullName);
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

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
                  child: report.photoUrl == null || report.photoUrl!.isEmpty
                      ? Container(
                          height: 160,
                          width: double.infinity,
                          color: AppColors.surfaceTint,
                          child: const Icon(Icons.directions_car,
                              size: 48, color: AppColors.primary),
                        )
                      : Image.network(
                          report.photoUrl!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
            if (report.notes != null && report.notes!.isNotEmpty)
              DetailRow(
                icon: Icons.notes,
                label: 'Authority Notes',
                value: report.notes!,
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
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: NavigationHeader(
        title: 'AGOS',
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
          stream: _firestoreService.citizenReports(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final reports = snapshot.data ?? [];
            final pendingCount =
                reports.where((r) => r.status == 'Pending').length;

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(
                  'Good morning, ${_fullName.isEmpty ? '...' : _fullName}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
                const Text(
                  'Your Reports',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (reports.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Text(
                      'No reports yet. Submit your first one above.',
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
                    onTap: () => _showReportDetails(context, report),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}