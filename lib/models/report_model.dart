class Report {
  final String id;
  final String reporterId;
  final String? photoUrl;
  final String description;
  final double? latitude;
  final double? longitude;
  final String locationName;
  final DateTime timestamp;
  final String status;
  final String? notes;

  Report({
    required this.id,
    required this.reporterId,
    this.photoUrl,
    required this.description,
    this.latitude,
    this.longitude,
    required this.locationName,
    required this.timestamp,
    required this.status,
    this.notes,
  });
}