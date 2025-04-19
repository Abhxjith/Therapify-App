class SessionReport {
  final String date;
  final String summary;
  final int sessionNumber;
  final int duration; // in minutes
  final List<String> topics;
  final String therapist;

  SessionReport({
    required this.date,
    required this.summary,
    required this.sessionNumber,
    required this.duration,
    required this.topics,
    required this.therapist,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'summary': summary,
    'sessionNumber': sessionNumber,
    'duration': duration,
    'topics': topics,
    'therapist': therapist,
  };

  factory SessionReport.fromJson(Map<String, dynamic> json) => SessionReport(
    date: json['date'],
    summary: json['summary'],
    sessionNumber: json['sessionNumber'],
    duration: json['duration'],
    topics: List<String>.from(json['topics']),
    therapist: json['therapist'],
  );
} 