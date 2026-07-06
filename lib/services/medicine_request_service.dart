import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineRequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestMedicine({
    required String patientId,
    required String patientName,
    required String doctorName,
    required String medicines,
  }) async {
    await _firestore.collection('medicine_requests').add({
      'patientId': patientId,
      'patientName': patientName,
      'doctorName': doctorName,
      'medicines': medicines,
      'status': 'Pending',
      'requestDate': Timestamp.now(),
    });
  }
}