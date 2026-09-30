import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../theme.dart';
import '../../widgets/image_upload.dart';
import '../../widgets/navigation_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/text_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import 'dart:typed_data';

class SubmitReportScreen extends StatefulWidget {
  const SubmitReportScreen({super.key});

  @override
  State<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends State<SubmitReportScreen> {
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _imagePath;
  Uint8List? _imageBytes;
  double? _latitude;
  double? _longitude;
  bool _isDetectingLocation = false;
  bool _isSubmitting = false;
  bool _isPickingImage = false;

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imagePath = picked.path;
          _imageBytes = bytes;
        });
      }
    } finally {
      _isPickingImage = false;
    }
  }

  void _removeImage() {
    setState(() {
      _imagePath = null;
      _imageBytes = null;
    });
  }

  /// Turns coordinates into a readable address using OpenStreetMap's free
  /// Nominatim API. Returns null on any failure so the caller can fall back
  /// to showing raw coordinates instead.
  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json&lat=$lat&lon=$lng&zoom=16&addressdetails=1',
      );

      final response = await http.get(
        uri,
        headers: {
          // Nominatim's usage policy asks apps to identify themselves.
          // Browsers block overriding this header on web, so this only
          // takes effect on Android/iOS/desktop.
          'User-Agent': 'AGOS-FlutterApp (github.com/Siyanfr/Agos-App-Finals)',
        },
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final address = data['address'] as Map<String, dynamic>?;

      if (address != null) {
        final locality = address['city'] ??
            address['town'] ??
            address['municipality'] ??
            address['suburb'] ??
            address['village'];
        final region = address['state'] ?? address['region'];

        if (locality != null && region != null) {
          return '$locality, $region';
        }
      }

      return data['display_name'] as String?;
    } catch (_) {
      return null;
    }
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

      // Store the real coordinates regardless of whether the address lookup
      // below succeeds, so the report's actual location is never lost.
      _latitude = position.latitude;
      _longitude = position.longitude;

      final placeName = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _locationController.text = placeName ??
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
    if (_imageBytes == null || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a photo and a location.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final photoUrl = await StorageService().uploadReportPhoto(_imageBytes!);

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirestoreService().createReport(
        reporterId: uid,
        photoUrl: photoUrl,
        description: _descriptionController.text,
        latitude: _latitude,
        longitude: _longitude,
        locationName: _locationController.text,
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
              onTrailingIconTap:
                  _isDetectingLocation ? null : _autoDetectLocation,
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