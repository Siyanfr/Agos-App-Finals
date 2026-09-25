import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StorageService {
  Future<String> uploadReportPhoto(Uint8List imageBytes) async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
    final uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'];

    if (cloudName == null || uploadPreset == null) {
      throw Exception(
          'Cloudinary config missing. Check your .env file.');
    }

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'report_photo.jpg',
      ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Cloudinary upload failed: $responseBody');
    }

    final data = jsonDecode(responseBody);
    return data['secure_url'] as String;
  }
}