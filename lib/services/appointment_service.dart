import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/appointment_model.dart';
import '../models/doctor_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> bookAppointment({
    required Doctor doctor,
    required String appointmentDate,
    required String appointmentTime,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final appointment = Appointment(
      id: '',
      patientId: user.uid,
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialization: doctor.specialization,
      hospital: doctor.hospital,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: 'Upcoming',
    );

    await _firestore.collection('appointments').add(appointment.toMap());
  }

  Stream<List<Appointment>> getMyAppointments() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('appointments')
        .where('patientId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Appointment.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Stream<List<Appointment>> getAllAppointments() {
    return _firestore.collection('appointments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Appointment.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> cancelAppointment(String appointmentId) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'Cancelled',
    });
  }
}