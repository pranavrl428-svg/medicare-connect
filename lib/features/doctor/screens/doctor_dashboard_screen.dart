import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../models/appointment_model.dart';
import '../../../services/appointment_service.dart';
import '../widgets/doctor_appointment_card.dart';

class DoctorDashboardScreen extends StatelessWidget {
  DoctorDashboardScreen({super.key});

  final AppointmentService _appointmentService = AppointmentService();

  Future<void> _updateStatus(
    BuildContext context,
    Appointment appointment,
    String status,
  ) async {
    try {
      await _appointmentService.updateAppointmentStatus(
        appointmentId: appointment.id,
        status: status,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment $status successfully'),
          backgroundColor: status == 'Rejected'
              ? AppColors.error
              : AppColors.accent,
        ),
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update appointment: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _confirmStatusChange(
    BuildContext context,
    Appointment appointment,
    String status,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('$status Appointment'),
          content: Text(
            'Are you sure you want to mark this appointment as $status?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(status),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    await _updateStatus(
      context,
      appointment,
      status,
    );
  }

  void _openPrescription(
    BuildContext context,
    Appointment appointment,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Prescription form for ${appointment.patientName} will be added next',
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.blue;
      case 'Rejected':
      case 'Cancelled':
        return AppColors.error;
      case 'Completed':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
      ),
      body: StreamBuilder<List<Appointment>>(
        stream: _appointmentService.getAllAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load appointments'),
            );
          }

          final appointments = snapshot.data ?? [];

          final pendingCount = appointments
              .where((appointment) => appointment.status == 'Pending')
              .length;

          final acceptedCount = appointments
              .where((appointment) => appointment.status == 'Accepted')
              .length;

          final completedCount = appointments
              .where((appointment) => appointment.status == 'Completed')
              .length;

          return RefreshIndicator(
            onRefresh: () async {
              await Future<void>.delayed(
                const Duration(milliseconds: 500),
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back 👨‍⚕️',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Dr. Rahul Nair',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage appointments and patient care',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        title: 'Pending',
                        value: pendingCount.toString(),
                        icon: Icons.hourglass_top,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Accepted',
                        value: acceptedCount.toString(),
                        icon: Icons.check_circle,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryCard(
                        title: 'Completed',
                        value: completedCount.toString(),
                        icon: Icons.done_all,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Appointments',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 14),

                if (appointments.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 70,
                            color: AppColors.textLight,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No appointments found',
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...appointments.map(
                    (appointment) => DoctorAppointmentCard(
                      appointment: appointment,
                      onAccept: () {
                        _confirmStatusChange(
                          context,
                          appointment,
                          'Accepted',
                        );
                      },
                      onReject: () {
                        _confirmStatusChange(
                          context,
                          appointment,
                          'Rejected',
                        );
                      },
                      onComplete: () {
                        _confirmStatusChange(
                          context,
                          appointment,
                          'Completed',
                        );
                      },
                      onPrescription: () {
                        _openPrescription(
                          context,
                          appointment,
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 14,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}