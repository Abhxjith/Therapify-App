class TherapySession {
  final String id;
  final String therapistId;
  final String patientId;
  final DateTime dateTime;
  final int duration; // in minutes
  final String status; // 'scheduled', 'completed', 'cancelled'
  final String? notes;
  final double? rating;

  TherapySession({
    required this.id,
    required this.therapistId,
    required this.patientId,
    required this.dateTime,
    required this.duration,
    required this.status,
    this.notes,
    this.rating,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      id: json['id'] as String,
      therapistId: json['therapistId'] as String,
      patientId: json['patientId'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      duration: json['duration'] as int,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      rating: json['rating'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'therapistId': therapistId,
      'patientId': patientId,
      'dateTime': dateTime.toIso8601String(),
      'duration': duration,
      'status': status,
      'notes': notes,
      'rating': rating,
    };
  }
} 