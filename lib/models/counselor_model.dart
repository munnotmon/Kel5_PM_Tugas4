class EducationItem {
  final String title;
  final String subtitle;

  EducationItem({required this.title, required this.subtitle});

  factory EducationItem.fromMap(Map<String, dynamic> map) {
    return EducationItem(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
    };
  }
}

class ExperienceItem {
  final String title;
  final String subtitle;

  ExperienceItem({required this.title, required this.subtitle});

  factory ExperienceItem.fromMap(Map<String, dynamic> map) {
    return ExperienceItem(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
    };
  }
}

class Konselor {
  final String name;
  final String specialty;
  final String rating;
  final String experienceYears;
  final String sessions;
  final String about;
  final List<String> specialties;
  final List<EducationItem> educations;
  final List<ExperienceItem> experiences;
  final List<int> practiceDays;
  final List<String> availableTimes;

  Konselor({
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

  factory Konselor.fromMap(Map<String, dynamic> map) {
    return Konselor(
      name: map['name'] ?? '',
      specialty: map['specialty'] ?? '',
      rating: map['rating'] ?? '5.0',
      experienceYears: map['experience_years'] ?? '',
      sessions: map['sessions'] ?? '',
      about: map['about'] ?? '',
      specialties: List<String>.from(map['specialties'] ?? []),
      educations: (map['educations'] as List? ?? [])
          .map((e) => EducationItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      experiences: (map['experiences'] as List? ?? [])
          .map((e) => ExperienceItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      practiceDays: List<int>.from(map['practice_days'] ?? []),
      availableTimes: List<String>.from(map['available_times'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'rating': rating,
      'experience_years': experienceYears,
      'sessions': sessions,
      'about': about,
      'specialties': specialties,
      'educations': educations.map((e) => e.toMap()).toList(),
      'experiences': experiences.map((e) => e.toMap()).toList(),
      'practice_days': practiceDays,
      'available_times': availableTimes,
    };
  }
}
