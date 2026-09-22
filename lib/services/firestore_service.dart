import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Live stream of reports belonging to one citizen.
  Stream<List<Report>> citizenReports(String reporterId) {
    return _firestore
        .collection('reports')
        .where('reporterId', isEqualTo: reporterId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _fromDoc(doc)).toList());
  }

  /// Live stream of every report, for the authority dashboard.
  /// Optionally filtered by status ('All' means no filter).
  Stream<List<Report>> allReports({String statusFilter = 'All'}) {
    Query<Map<String, dynamic>> query =
        _firestore.collection('reports').orderBy('timestamp', descending: true);

    if (statusFilter != 'All') {
      query = query.where('status', isEqualTo: statusFilter);
    }

    return query.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => _fromDoc(doc)).toList());
  }

  Future<void> createReport({
    required String reporterId,
    required String photoUrl,
    required String description,
    required double? latitude,
    required double? longitude,
    required String locationName,
  }) async {
    await _firestore.collection('reports').add({
      'reporterId': reporterId,
      'photoUrl': photoUrl,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'timestamp': Timestamp.now(),
      'status': 'Pending',
    });
  }

  Future<void> updateStatus(String reportId, String newStatus, {String? notes}) async {
    await _firestore.collection('reports').doc(reportId).update({
      'status': newStatus,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
  }

  Report _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Report(
      id: doc.id,
      reporterId: data['reporterId'] as String,
      photoUrl: data['photoUrl'] as String?,
      description: data['description'] as String,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      locationName: data['locationName'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: data['status'] as String,
      notes: data['notes'] as String?,
    );
  }
}