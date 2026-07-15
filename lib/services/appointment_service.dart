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

    final userDocument =
        await _firestore.collection('users').doc(user.uid).get();

    if (!userDocument.exists) {
      throw Exception('Patient profile not found');
    }

    final userData = userDocument.data()!;
    final patientName = userData['name']?.toString().trim();

    final appointment = Appointment(
      id: '',
      patientId: user.uid,
      patientName: patientName == null || patientName.isEmpty
          ? 'Patient'
          : patientName,
      doctorId: doctor.id,
      doctorName: doctor.name,
      specialization: doctor.specialization,
      hospital: doctor.hospital,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      status: 'Pending',
    );

    await _firestore
        .collection('appointments')
        .add(appointment.toMap());
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
      return snapshot.docs.map((document) {
        return Appointment.fromMap(
          document.id,
          document.data(),
        );
      }).toList();
    });
  }

  Stream<List<Appointment>> getAllAppointments() {
    return _firestore
        .collection('appointments')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return Appointment.fromMap(
          document.id,
          document.data(),
        );
      }).toList();
    });
  }

  Stream<List<Appointment>> getDoctorAppointments(
    String doctorId,
  ) {
    return _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return Appointment.fromMap(
          document.id,
          document.data(),
        );
      }).toList();
    });
  }

  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    await _firestore
        .collection('appointments')
        .doc(appointmentId)
        .update({
      'status': status,
    });
  }

  Future<void> cancelAppointment(
    String appointmentId,
  ) async {
    await updateAppointmentStatus(
      appointmentId: appointmentId,
      status: 'Cancelled',
    );
  }
}