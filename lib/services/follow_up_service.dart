import 'package:cloud_firestore/cloud_firestore.dart';

class FollowUpService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitFollowUp({
    required String patientId,
    required String patientName,
    required String doctorName,
    required String subject,
    required String message,
  }) async {
    await _firestore.collection('follow_up_requests').add({
      'patientId': patientId,
      'patientName': patientName,
      'doctorName': doctorName,
      'subject': subject,
      'message': message,
      'status': 'Pending',
      'requestDate': Timestamp.now(),
    });
  }
}