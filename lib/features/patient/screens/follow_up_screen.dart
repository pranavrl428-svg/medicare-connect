import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../services/follow_up_service.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController doctorController =
      TextEditingController(text: "Dr. Rahul Nair");

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FollowUpService _followUpService = FollowUpService();

  bool _isSubmitting = false;

  Future<void> submitFollowUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final user = _auth.currentUser;

    if (user == null) {
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    final userDoc =
        await _firestore.collection('users').doc(user.uid).get();

    final userData = userDoc.data();

    await _followUpService.submitFollowUp(
      patientId: user.uid,
      patientName: userData?['name'] ?? 'Patient',
      doctorName: doctorController.text.trim(),
      subject: subjectController.text.trim(),
      message: messageController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Follow-up request submitted successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    doctorController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Follow-Up Care"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: doctorController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Doctor",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  prefixIcon: Icon(Icons.subject),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a subject";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: "Message",
                  prefixIcon: Icon(Icons.message),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your message";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : submitFollowUp,
                  icon: const Icon(Icons.send),
                  label: _isSubmitting
                      ? const Text("Submitting...")
                      : const Text("Submit Request"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}