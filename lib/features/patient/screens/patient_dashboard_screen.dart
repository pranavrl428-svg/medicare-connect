import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../services/auth_service.dart';
import 'doctor_list_screen.dart';

class PatientDashboardScreen extends StatelessWidget {
  PatientDashboardScreen({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await _authService.logoutUser();

              if (!context.mounted) return;

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, Pranav 👋',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'How can we help you today?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 24),

            _DashboardCard(
              icon: Icons.calendar_month,
              title: 'Book Appointment',
              subtitle: 'Find doctors and schedule your visit',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                   builder: (context) => DoctorListScreen(),
                  ),
                );
              },
            ),
            _DashboardCard(
              icon: Icons.history,
              title: 'Appointment History',
              subtitle: 'View your past and upcoming appointments',
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.medical_information,
              title: 'Prescriptions',
              subtitle: 'View prescriptions uploaded by doctors',
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.chat_bubble_outline,
              title: 'Follow-Up Care',
              subtitle: 'Send follow-up questions after consultation',
              onTap: () {},
            ),
            _DashboardCard(
              icon: Icons.local_pharmacy,
              title: 'Medicine Request',
              subtitle: 'Request medicines based on prescription',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}