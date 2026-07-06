import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../services/medicine_request_service.dart';

class PrescriptionScreen extends StatelessWidget {
  PrescriptionScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final MedicineRequestService _medicineRequestService =
      MedicineRequestService();

  Future<void> _requestMedicines(
    BuildContext context,
    Map<String, dynamic> prescriptionData,
  ) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();

    await _medicineRequestService.requestMedicine(
      patientId: user.uid,
      patientName: userData?['name'] ?? 'Patient',
      doctorName: prescriptionData['doctorName'] ?? 'Doctor',
      medicines: prescriptionData['medicines'] ?? 'Not added',
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Medicine request submitted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Prescriptions'),
      ),
      body: user == null
          ? const Center(child: Text('User not logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('prescriptions')
                  .where('patientId', isEqualTo: user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No prescriptions found'),
                  );
                }

                final prescriptions = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: prescriptions.length,
                  itemBuilder: (context, index) {
                    final data =
                        prescriptions[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['doctorName'] ?? 'Doctor',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data['date'] ?? '',
                              style: const TextStyle(
                                color: AppColors.textLight,
                              ),
                            ),
                            const Divider(height: 24),

                            _InfoRow(
                              title: 'Diagnosis',
                              value: data['diagnosis'] ?? 'Not added',
                            ),
                            const SizedBox(height: 12),

                            _InfoRow(
                              title: 'Medicines',
                              value: data['medicines'] ?? 'Not added',
                            ),
                            const SizedBox(height: 12),

                            _InfoRow(
                              title: 'Doctor Notes',
                              value: data['notes'] ?? 'Not added',
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _requestMedicines(context, data);
                                },
                                icon: const Icon(Icons.local_pharmacy),
                                label: const Text('Request Medicines'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}