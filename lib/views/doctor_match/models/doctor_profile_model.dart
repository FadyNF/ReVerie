import 'recommended_doctor.dart';

class DoctorProfileModel {
  final String id;
  final String initials;
  final String name;
  final String specialty;
  final String clinic;
  final double rating;

  final int reviews;
  final int yearsExperience;
  final int patients;

  final String about;
  final List<EducationItem> education;
  final List<String> languages;
  final Map<String, String> availability;
  final List<String> tags;

  const DoctorProfileModel({
    required this.id,
    required this.initials,
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    this.reviews = 0,
    this.yearsExperience = 0,
    this.patients = 0,
    this.about = '',
    this.education = const [],
    this.languages = const [],
    this.availability = const {},
    this.tags = const [],
  });

  static DoctorProfileModel fromRecommendedDoctor(RecommendedDoctor d) {
    return DoctorProfileModel(
      id: d.id,
      initials: d.initials,
      name: d.name,
      specialty: d.specialty,
      clinic: d.clinic,
      rating: d.rating,
      // tags will come from backend later (or keep empty now)
      tags: const [],
    );
  }

  static DoctorProfileModel dummySarah() {
    return const DoctorProfileModel(
      id: "doc_sarah_chen",
      initials: "DSC",
      name: "Dr. Sarah Chen",
      specialty: "Cognitive Specialist",
      clinic: "Memory Care Center",
      rating: 4.9,
      reviews: 127,
      yearsExperience: 15,
      patients: 2500,
      about:
          "Dr. Sarah Chen is a board-certified cognitive specialist with over 15 years of experience in memory care and cognitive health. She specializes in early detection and treatment of memory disorders.",
      education: [
        EducationItem(title: "MD", subtitle: "Harvard Medical School", year: "2009"),
        EducationItem(
          title: "Fellowship in Cognitive Neurology",
          subtitle: "Johns Hopkins",
          year: "2012",
        ),
      ],
      languages: ["English", "Mandarin", "Cantonese"],
      availability: {
        "Monday": "9:00 AM - 5:00 PM",
        "Wednesday": "9:00 AM - 5:00 PM",
        "Friday": "9:00 AM - 3:00 PM",
      },
      tags: ["Calm approach", "Speaks Arabic"],
    );
  }
}

class EducationItem {
  final String title;
  final String subtitle;
  final String year;

  const EducationItem({
    required this.title,
    required this.subtitle,
    required this.year,
  });
}
