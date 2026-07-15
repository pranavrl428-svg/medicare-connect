import 'package:flutter/material.dart';

import '../features/authentication/screens/forgot_password_screen.dart';
import '../features/authentication/screens/login_screen.dart';
import '../features/authentication/screens/register_screen.dart';
import '../features/authentication/screens/splash_screen.dart';
import '../features/authentication/screens/welcome_screen.dart';
import '../features/patient/screens/patient_dashboard_screen.dart';
import 'routes.dart';
import 'theme.dart';

final ValueNotifier<ThemeMode> themeNotifier =
    ValueNotifier(ThemeMode.system);

class MediCareConnectApp extends StatelessWidget {
  const MediCareConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentThemeMode, child) {
        return MaterialApp(
          title: 'MediCare Connect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.welcome: (context) => const WelcomeScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
            AppRoutes.forgotPassword: (context) =>
                const ForgotPasswordScreen(),
            AppRoutes.patientDashboard: (context) =>
                const PatientDashboardScreen(),
          },
        );
      },
    );
  }
}