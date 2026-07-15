class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final String hospital;
  final String appointmentDate;
  final String appointmentTime;
  final String status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.hospital,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'hospital': hospital,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'status': status,
    };
  }

  factory Appointment.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return Appointment(
      id: id,
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? 'Unknown Patient',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      specialization: map['specialization'] ?? '',
      hospital: map['hospital'] ?? '',
      appointmentDate: map['appointmentDate'] ?? '',
      appointmentTime: map['appointmentTime'] ?? '',
      status: map['status'] ?? 'Pending',
    );
  }
}