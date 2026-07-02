import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/doctor_model.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Doctor>> getDoctors() {
    return _firestore.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Doctor.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}