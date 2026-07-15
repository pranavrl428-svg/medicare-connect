import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../models/appointment_model.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final Appointment appointment;

  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;
  final VoidCallback? onPrescription;

  const DoctorAppointmentCard({
    super.key,
    required this.appointment,
    this.onAccept,
    this.onReject,
    this.onComplete,
    this.onPrescription,
  });

  Color _statusColor() {
    switch (appointment.status) {
      case "Accepted":
        return Colors.blue;

      case "Rejected":
        return Colors.red;

      case "Completed":
        return Colors.green;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      AppColors.primary.withOpacity(.12),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.patientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        appointment.specialization,
                        style: const TextStyle(
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                Chip(
                  label: Text(
                    appointment.status,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: _statusColor(),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 8),
                Text(appointment.appointmentDate),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(appointment.appointmentTime),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.local_hospital),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.hospital,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            if (appointment.status == "Pending")
              Row(
                children: [

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onAccept,
                      icon: const Icon(Icons.check),
                      label: const Text("Accept"),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: onReject,
                      icon: const Icon(Icons.close),
                      label: const Text("Reject"),
                    ),
                  ),
                ],
              ),

            if (appointment.status == "Accepted")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.done_all),
                  label: const Text(
                    "Mark Completed",
                  ),
                ),
              ),

            if (appointment.status == "Completed")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPrescription,
                  icon: const Icon(Icons.medical_services),
                  label: const Text(
                    "Add Prescription",
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}