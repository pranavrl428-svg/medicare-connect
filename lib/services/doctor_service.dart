import '../models/doctor_model.dart';

class DoctorService {
  static List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Sarah Johnson',
      specialization: 'Cardiologist',
      experience: 12,
      rating: 4.9,
      hospital: 'City Care Clinic',
    ),
    Doctor(
      name: 'Dr. David Wilson',
      specialization: 'Neurologist',
      experience: 9,
      rating: 4.8,
      hospital: 'MediCare Hospital',
    ),
    Doctor(
      name: 'Dr. Emily Brown',
      specialization: 'Orthopedic',
      experience: 15,
      rating: 4.7,
      hospital: 'Health Plus Clinic',
    ),
    Doctor(
      name: 'Dr. Anjali Menon',
      specialization: 'General Physician',
      experience: 8,
      rating: 4.6,
      hospital: 'Health First Clinic',
    ),
  ];
}