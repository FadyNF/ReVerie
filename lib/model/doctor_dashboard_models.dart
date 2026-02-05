enum RequestType { admission, session }
enum PriorityLevel { normal, priority }
enum PatientStatus { active, inactive }

class TodayScheduleItem {
  final String timeLabel;
  final String patientName;
  final String subtitle;
  const TodayScheduleItem({
    required this.timeLabel,
    required this.patientName,
    required this.subtitle,
  });
}

class DoctorRequest {
  final String id;
  final String patientName;
  final String initials;
  final RequestType type;
  final PriorityLevel priority;
  final String dateRangeLabel;
  final String meta;
  final String? sceneTitle;
  final String? sceneName;

  const DoctorRequest({
    required this.id,
    required this.patientName,
    required this.initials,
    required this.type,
    required this.priority,
    required this.dateRangeLabel,
    required this.meta,
    this.sceneTitle,
    this.sceneName,
  });
}

class PatientCardModel {
  final String id;
  final String name;
  final String initials;
  final PatientStatus status;
  final String lastSessionLabel;
  final int totalSessions;

  const PatientCardModel({
    required this.id,
    required this.name,
    required this.initials,
    required this.status,
    required this.lastSessionLabel,
    required this.totalSessions,
  });
}
