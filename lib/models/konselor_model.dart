class KonselorModel {
  final String name;
  final String specialty;
  final String rating;
  final String experienceYears;
  final String sessions;
  final String about;
  final List<String> specialties;
  final List<Map<String, String>> educations;
  final List<Map<String, String>> experiences;
  final List<int> practiceDays;
  final List<String> availableTimes;

  KonselorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.experienceYears,
    required this.sessions,
    required this.about,
    required this.specialties,
    required this.educations,
    required this.experiences,
    required this.practiceDays,
    required this.availableTimes,
  });

  factory KonselorModel.fromJson(Map<String, dynamic> json) {
    return KonselorModel(
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      rating: json['rating'] ?? '',
      experienceYears: json['experience_years'] ?? '',
      sessions: json['sessions'] ?? '',
      about: json['about'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      educations: (json['educations'] as List? ?? []).map((e) => {
        'title': e['title'].toString(),
        'subtitle': e['subtitle'].toString(),
      }).toList(),
      experiences: (json['experiences'] as List? ?? []).map((e) => {
        'title': e['title'].toString(),
        'subtitle': e['subtitle'].toString(),
      }).toList(),
      practiceDays: List<int>.from(json['practice_days'] ?? []),
      availableTimes: List<String>.from(json['available_times'] ?? []),
    );
  }
}
