//demo for backend 
class DoctorMatchRequest {
  final Set<String> preferences; // screen 3
  final Set<String> timeOfDay;   // screen 4
  final Set<String> days;        // screen 4
  final String? location;        // screen 5 city or detected

  DoctorMatchRequest({
    required this.preferences,
    required this.timeOfDay,
    required this.days,
    required this.location,
  });
}
