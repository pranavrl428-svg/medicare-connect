import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/app.dart';
import '../../../app/theme.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showThemeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentThemeMode, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Choose Appearance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: currentThemeMode,
                      title: const Text('Light Mode'),
                      secondary: const Icon(Icons.light_mode),
                      onChanged: (value) {
                        if (value == null) return;

                        themeNotifier.value = value;
                        Navigator.pop(context);
                      },
                    ),

                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: currentThemeMode,
                      title: const Text('Dark Mode'),
                      secondary: const Icon(Icons.dark_mode),
                      onChanged: (value) {
                        if (value == null) return;

                        themeNotifier.value = value;
                        Navigator.pop(context);
                      },
                    ),

                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: currentThemeMode,
                      title: const Text('System Default'),
                      secondary: const Icon(Icons.settings_brightness),
                      onChanged: (value) {
                        if (value == null) return;

                        themeNotifier.value = value;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _themeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  IconData _themeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: user == null
          ? const Center(
              child: Text('User not logged in'),
            )
          : FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('users').doc(user.uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Failed to load profile'),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('Profile not found'),
                  );
                }

                final data =
                    snapshot.data!.data() as Map<String, dynamic>;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 52,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data['name'] ?? 'Unknown',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data['email'] ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfileScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                        ),
                      ),

                      const SizedBox(height: 24),

                      _ProfileTile(
                        icon: Icons.phone,
                        title: 'Phone',
                        value: data['phone'] ?? 'Not added',
                      ),

                      _ProfileTile(
                        icon: Icons.cake,
                        title: 'Age',
                        value:
                            data['age']?.toString() ?? 'Not added',
                      ),

                      _ProfileTile(
                        icon: Icons.person_outline,
                        title: 'Gender',
                        value: data['gender'] ?? 'Not added',
                      ),

                      _ProfileTile(
                        icon: Icons.bloodtype,
                        title: 'Blood Group',
                        value:
                            data['bloodGroup'] ?? 'Not added',
                      ),

                      const SizedBox(height: 10),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeNotifier,
                        builder: (
                          context,
                          currentThemeMode,
                          child,
                        ) {
                          return Card(
                            elevation: 3,
                            margin:
                                const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(18),
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary
                                    .withOpacity(0.12),
                                child: Icon(
                                  _themeIcon(currentThemeMode),
                                  color: AppColors.primary,
                                ),
                              ),
                              title: const Text(
                                'Appearance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                _themeName(currentThemeMode),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                _showThemeOptions(context);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 160,
          ),
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}