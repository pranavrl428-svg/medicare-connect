class Doctor {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final double rating;
  final String hospital;
  final int fee;
  final List<String> availableDays;
  final List<String> timeSlots;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.hospital,
    required this.fee,
    required this.availableDays,
    required this.timeSlots,
  });

  factory Doctor.fromMap(String id, Map<String, dynamic> map) {
    return Doctor(
      id: id,
      name: map['name'] ?? '',
      specialization: map['specialization'] ?? '',
      experience: map['experience'] ?? 0,
      rating: (map['rating'] ?? 0).toDouble(),
      hospital: map['hospital'] ?? '',
      fee: map['fee'] ?? 0,
      availableDays: List<String>.from(map['availableDays'] ?? []),
      timeSlots: List<String>.from(map['timeSlots'] ?? []),
    );
  }
}