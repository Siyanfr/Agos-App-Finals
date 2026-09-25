import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme.dart';
import '../../widgets/image_upload.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_input_field.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({super.key});

  @override
  State<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;
  bool _isDetectingLocation = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  bool _isPickingImage = false;
  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _imagePath = picked.path);
      }
    } finally {
      _isPickingImage = false;
    }
  }

  void _removeImage() {
    setState(() => _imagePath = null);
  }

  Future<void> _autoDetectLocation() async {
    setState(() => _isDetectingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError('Location services are turned off.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permission denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
            'Location permission permanently denied. Enter location manually.');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _locationController.text =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      _showLocationError('Could not fetch location. Enter it manually.');
    } finally {
      setState(() => _isDetectingLocation = false);
    }
  }

  void _showLocationError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submitReport() async {
    if (_imagePath == null || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a photo and a location.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final photoUrl = await StorageService()
          .uploadReportPhoto(File(_imagePath!));

      final uid = FirebaseAuth.instance.currentUser!.uid;

      double? lat;
      double? lng;
      final locationText = _locationController.text;
      if (locationText.contains(',')) {
        final parts = locationText.split(',');
        lat = double.tryParse(parts[0].trim());
        lng = double.tryParse(parts[1].trim());
      }

      await FirestoreService().createReport(
        reporterId: uid,
        photoUrl: photoUrl,
        description: _descriptionController.text,
        latitude: lat,
        longitude: lng,
        locationName: locationText,
      );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavigationHeader(
        title: 'Submit Report',
        showBackButton: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Submit Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Provide the details of the illegally parked vehicle.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.md),
            ImageUploadComponent(
              image: _imagePath,
              onUpload: _pickImage,
              onRemove: _removeImage,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'LOCATION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: AppColors.statusPending,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextInputField(
              label: '',
              hint: 'Enter the location manually',
              controller: _locationController,
              leadingIcon: Icons.location_on_outlined,
              trailingIcon: _isDetectingLocation ? null : Icons.gps_fixed,
              onTrailingIconTap: _isDetectingLocation ? null : _autoDetectLocation,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: AppColors.statusPending,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextInputField(
              label: '',
              hint: 'e.g. Blocking fire hydrant, parked in crosswalk...',
              controller: _descriptionController,
              multiline: true,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Submit Report',
                icon: Icons.send,
                isLoading: _isSubmitting,
                onPressed: _submitReport,
              ),
            ),
          ],
        ),
      ),
    );
  }
}