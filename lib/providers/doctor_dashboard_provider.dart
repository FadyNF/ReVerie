import 'package:flutter/material.dart';
import '../model/doctor_dashboard_models.dart';

enum RequestsFilter { all, admission, session }
enum PatientsFilter { all, active, inactive }

class DoctorDashboardProvider extends ChangeNotifier {
  // later: pull from auth/profile
  String doctorDisplayName = "Dr. Chen";

  int pendingRequests = 5;
  int admissionRequests = 3;
  int sessionRequests = 2;
  int activePatients = 18;
  int todaysSessionsCount = 3;

  final List<TodayScheduleItem> todaysSchedule = const [
    TodayScheduleItem(timeLabel: "10:00 AM", patientName: "Sarah Johnson", subtitle: "VR Session"),
    TodayScheduleItem(timeLabel: "2:00 PM", patientName: "Michael Davis", subtitle: "VR Session"),
    TodayScheduleItem(timeLabel: "4:30 PM", patientName: "Emma Wilson", subtitle: "Follow-up"),
  ];

  // Requests
  RequestsFilter requestsFilter = RequestsFilter.all;

  final List<DoctorRequest> _allRequests = const [
    DoctorRequest(
      id: "r1",
      patientName: "Emily Martinez",
      initials: "EM",
      type: RequestType.admission,
      priority: PriorityLevel.priority,
      dateRangeLabel: "Jan 28 - Feb 3, 2026",
      meta: "Priority access via Doctor OTP • Assessment skipped",
    ),
    DoctorRequest(
      id: "r2",
      patientName: "Sophia Lee",
      initials: "SL",
      type: RequestType.admission,
      priority: PriorityLevel.priority,
      dateRangeLabel: "Jan 26 - Feb 1, 2026",
      meta: "Priority access via Doctor OTP • Assessment skipped",
    ),
    DoctorRequest(
      id: "r3",
      patientName: "James Anderson",
      initials: "JA",
      type: RequestType.session,
      priority: PriorityLevel.normal,
      dateRangeLabel: "Jan 27 - Jan 29, 2026",
      sceneTitle: "Beach Sunset Meditation",
      sceneName: "Scene: Peaceful Beach",
      meta: "Standard request • Assessment completed",
    ),
    DoctorRequest(
      id: "r4",
      patientName: "Michael Brown",
      initials: "MB",
      type: RequestType.session,
      priority: PriorityLevel.normal,
      dateRangeLabel: "Jan 28 - Jan 30, 2026",
      sceneTitle: "Forest Walk Experience",
      sceneName: "Scene: Tranquil Forest",
      meta: "Standard request • Assessment completed",
    ),
    DoctorRequest(
      id: "r5",
      patientName: "Olivia Davis",
      initials: "OD",
      type: RequestType.admission,
      priority: PriorityLevel.normal,
      dateRangeLabel: "Feb 1 - Feb 7, 2026",
      meta: "Standard request • Assessment completed",
    ),
  ];

  List<DoctorRequest> get filteredRequests {
    switch (requestsFilter) {
      case RequestsFilter.admission:
        return _allRequests.where((r) => r.type == RequestType.admission).toList();
      case RequestsFilter.session:
        return _allRequests.where((r) => r.type == RequestType.session).toList();
      case RequestsFilter.all:
      default:
        return _allRequests;
    }
  }

  void setRequestsFilter(RequestsFilter f) {
    requestsFilter = f;
    notifyListeners();
  }

  int get allCount => _allRequests.length;
  int get admissionCount => _allRequests.where((r) => r.type == RequestType.admission).length;
  int get sessionCount => _allRequests.where((r) => r.type == RequestType.session).length;

  // Patients
  PatientsFilter patientsFilter = PatientsFilter.all;
  String patientsSearchQuery = "";

  final List<PatientCardModel> _allPatients = const [
    PatientCardModel(
      id: "p1",
      name: "Sarah Johnson",
      initials: "SJ",
      status: PatientStatus.active,
      lastSessionLabel: "Jan 24, 2026",
      totalSessions: 12,
    ),
    PatientCardModel(
      id: "p2",
      name: "Michael Davis",
      initials: "MD",
      status: PatientStatus.active,
      lastSessionLabel: "Jan 23, 2026",
      totalSessions: 8,
    ),
    PatientCardModel(
      id: "p3",
      name: "Emma Wilson",
      initials: "EW",
      status: PatientStatus.active,
      lastSessionLabel: "Jan 22, 2026",
      totalSessions: 15,
    ),
    PatientCardModel(
      id: "p4",
      name: "David Martinez",
      initials: "DM",
      status: PatientStatus.inactive,
      lastSessionLabel: "Jan 15, 2026",
      totalSessions: 5,
    ),
    PatientCardModel(
      id: "p5",
      name: "Olivia Davis",
      initials: "OD",
      status: PatientStatus.active,
      lastSessionLabel: "Jan 20, 2026",
      totalSessions: 6,
    ),
  ];

  List<PatientCardModel> get filteredPatients {
    Iterable<PatientCardModel> items = _allPatients;

    if (patientsFilter == PatientsFilter.active) {
      items = items.where((p) => p.status == PatientStatus.active);
    } else if (patientsFilter == PatientsFilter.inactive) {
      items = items.where((p) => p.status == PatientStatus.inactive);
    }

    final q = patientsSearchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      items = items.where((p) => p.name.toLowerCase().contains(q));
    }
    return items.toList();
  }

  void setPatientsFilter(PatientsFilter f) {
    patientsFilter = f;
    notifyListeners();
  }

  void setPatientsSearch(String q) {
    patientsSearchQuery = q;
    notifyListeners();
  }

  int get patientsAllCount => _allPatients.length;
  int get patientsActiveCount => _allPatients.where((p) => p.status == PatientStatus.active).length;
  int get patientsInactiveCount => _allPatients.where((p) => p.status == PatientStatus.inactive).length;

  // Stubs for later
  Future<void> approveRequest(String requestId) async {}
  Future<void> declineRequest(String requestId) async {}
}
