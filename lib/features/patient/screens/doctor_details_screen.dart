import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../models/doctor_model.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Doctor Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: const Icon(
                Icons.person,
                size: 55,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              doctor.specialization,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 20),

            _InfoCard(title: 'Hospital', value: doctor.hospital),
            _InfoCard(title: 'Experience', value: '${doctor.experience} Years'),
            _InfoCard(title: 'Rating', value: doctor.rating.toString()),
            _InfoCard(title: 'Consultation Fee', value: '₹${doctor.fee}'),

            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Days',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: doctor.availableDays
                  .map((day) => Chip(label: Text(day)))
                  .toList(),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Appointment booking screen will be added next
                },
                child: const Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}