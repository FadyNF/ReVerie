class RecommendedDoctor {
  final String id; // backend id later
  final String initials;
  final String name;
  final String specialty;
  final String clinic;
  final double rating;
  final List<String> reasons;

  const RecommendedDoctor({
    required this.id,
    required this.initials,
    required this.name,
    required this.specialty,
    required this.clinic,
    required this.rating,
    required this.reasons,
  });
}
//fetched later from database