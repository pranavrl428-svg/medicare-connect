import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../models/appointment_model.dart';
import '../../../services/appointment_service.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  AppointmentHistoryScreen({super.key});

  final AppointmentService _appointmentService = AppointmentService();

  Future<void> _cancelAppointment(
    BuildContext context,
    String appointmentId,
  ) async {
    await _appointmentService.cancelAppointment(appointmentId);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointment cancelled'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Color _statusColor(String status) {
    if (status == 'Cancelled') return AppColors.error;
    if (status == 'Completed') return Colors.green;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Appointment History'),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: _appointmentService.getMyAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load appointments'));
          }

          final appointments = snapshot.data ?? [];

          if (appointments.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final isCancelled = appointment.status == 'Cancelled';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                _statusColor(appointment.status),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              appointment.doctorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _statusColor(appointment.status)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              appointment.status,
                              style: TextStyle(
                                color: _statusColor(appointment.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _AppointmentInfo(
                        icon: Icons.medical_services,
                        text: appointment.specialization,
                      ),
                      const SizedBox(height: 8),
                      _AppointmentInfo(
                        icon: Icons.business,
                        text: appointment.hospital,
                      ),
                      const SizedBox(height: 8),
                      _AppointmentInfo(
                        icon: Icons.access_time,
                        text:
                            '${appointment.appointmentDate} • ${appointment.appointmentTime}',
                      ),

                      if (!isCancelled) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _cancelAppointment(context, appointment.id);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel Appointment'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ),
                      ],
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

class _AppointmentInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AppointmentInfo({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textLight),
          ),
        ),
      ],
    );
  }
}