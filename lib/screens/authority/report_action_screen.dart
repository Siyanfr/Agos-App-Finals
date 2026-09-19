import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../theme.dart';
import '../../widgets/detail_row.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/photo_evidence_viewer.dart';
import '../../widgets/primary_button.dart';

class ReportActionScreen extends StatefulWidget {
  final Report report;

  const ReportActionScreen({super.key, required this.report});

  @override
  State<ReportActionScreen> createState() => _ReportActionScreenState();
}

class _ReportActionScreenState extends State<ReportActionScreen> {
  late String _selectedStatus;
  final _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.status;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateStatus() {
    setState(() => _isSaving = true);
    // Firestore .update({'status': _selectedStatus, ...}) goes here once wired in.
    debugPrint(
        'Updating ${widget.report.id} to $_selectedStatus with notes: ${_notesController.text}');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Scaffold(
      appBar: const NavigationHeader(
        title: 'Report Action',
        showBackButton: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PhotoEvidenceViewer(
              images: const [],
              mapThumbnailUrl: 'placeholder',
              status: report.status,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Report #${report.id}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${report.timestamp.month}/${report.timestamp.day}/${report.timestamp.year} • ${report.timestamp.hour}:${report.timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),
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
            const SizedBox(height: AppSpacing.md),
            const Text(
              'UPDATE REPORT STATUS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Pending', label: Text('Pending')),
                ButtonSegment(value: 'Resolved', label: Text('Resolved')),
                ButtonSegment(value: 'Rejected', label: Text('Rejected')),
              ],
              selected: {_selectedStatus},
              onSelectionChanged: (newSelection) {
                setState(() => _selectedStatus = newSelection.first);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Authority Notes',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter resolution details or reason for rejection...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Update & Save Status',
                icon: Icons.check_circle_outline,
                isLoading: _isSaving,
                onPressed: _updateStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}