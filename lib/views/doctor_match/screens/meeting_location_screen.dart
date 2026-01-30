import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';

import 'package:reverie/views/doctor_match/screens/recommended_doctors_screen.dart';
import 'package:reverie/views/doctor_match/models/recommended_doctor.dart';

// will Replace this later with a real implementation (geolocator / method channel).
// For now it returns a dummy location string so the UI flow works.
class LocationService {
  Future<String?> requestAndGetLocationLabel() async {
    // TODO (backend/infra later):
    // - ask permission
    // - get coordinates
    // - reverse geocode to "City, Country"
    await Future.delayed(const Duration(milliseconds: 700));

    // Return null to simulate "permission denied" or failure.
    // return null;

    // if success:
    return 'Cairo, Egypt';
  }
}

class MeetingLocationScreen extends StatefulWidget {
  const MeetingLocationScreen({super.key});

  @override
  State<MeetingLocationScreen> createState() => _MeetingLocationScreenState();
}

class _MeetingLocationScreenState extends State<MeetingLocationScreen> {
  final _cityController = TextEditingController();
  final _locationService = LocationService();

  bool _useMyLocation = false;
  bool _isFetchingLocation = false;

  /// If not null -> we hide the two options and show this instead
  String? _detectedLocationLabel;

  bool get _hasTypedCity => _cityController.text.trim().isNotEmpty;

  bool get _canContinue {
    // Enable only if we have a detected location OR typed city.
    if (_detectedLocationLabel != null) return true;
    return _hasTypedCity;
  }

  @override
  void initState() {
    super.initState();
    _cityController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _onUseMyLocationToggle(bool value) async {
    // If user unchecks, reset location state but keep any typed city.
    if (!value) {
      setState(() {
        _useMyLocation = false;
        _isFetchingLocation = false;
        _detectedLocationLabel = null;
      });
      return;
    }

    // If they check it, we attempt to fetch location and then replace UI.
    setState(() {
      _useMyLocation = true;
      _isFetchingLocation = true;
      _detectedLocationLabel = null;
    });

    final label = await _locationService.requestAndGetLocationLabel();

    if (!mounted) return;

    if (label == null) {
      // Permission denied / failure -> revert toggle and show message
      setState(() {
        _useMyLocation = false;
        _isFetchingLocation = false;
        _detectedLocationLabel = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission denied. Enter city or area instead.',
          ),
        ),
      );
      return;
    }

    // Success: show detected location and hide the two options.
    setState(() {
      _isFetchingLocation = false;
      _detectedLocationLabel = label;
      //clear typed city since location takes over (will remove if we want both)
      _cityController.clear();
    });
  }

  void _clearDetectedLocation() {
    setState(() {
      _detectedLocationLabel = null;
      _useMyLocation = false;
      _isFetchingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Your Doctor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Step 3 of 4
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressBar(currentStep: 3, totalSteps: 4),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Where would you like to meet?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help us find doctors near you',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // If we have detected location -> show only this section
                    if (_detectedLocationLabel != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _detectedLocationLabel!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _clearDetectedLocation,
                              style: TextButton.styleFrom(
                                foregroundColor: AuthUI.primaryBlue,
                              ),
                              child: const Text(
                                'Change',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ] else ...[
                      // Use my location row (mockup style)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _useMyLocation,
                              onChanged: _isFetchingLocation
                                  ? null
                                  : (v) => _onUseMyLocationToggle(v ?? false),
                              activeColor: AuthUI.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _isFetchingLocation
                                    ? 'Detecting location...'
                                    : 'Use my location',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Enter city or area',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                    ],

                    // Info box (same in both states)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF4FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Your location will only be used to find nearby\n'
                        'doctors. You can also choose video sessions.',
                        style: TextStyle(
                          color: AuthUI.primaryBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canContinue
                      ? () {
                          // backend-ready payload:
                          final payload = {
                            'location_source': _detectedLocationLabel != null
                                ? 'gps'
                                : 'manual',
                            'location_label': _detectedLocationLabel,
                            'city_query': _detectedLocationLabel == null
                                ? _cityController.text.trim()
                                : null,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecommendedDoctorsScreen(
                                doctors: const [
                                  RecommendedDoctor(
                                    id: 'd1',
                                    initials: 'DSC',
                                    name: 'Dr. Sarah Chen',
                                    specialty: 'Cognitive Specialist',
                                    clinic: 'Memory Care Center',
                                    rating: 4.9,
                                    reasons: [
                                      'Matches your availability',
                                      'Calm approach',
                                      'Arabic',
                                    ],
                                  ),
                                  RecommendedDoctor(
                                    id: 'd2',
                                    initials: 'DMF',
                                    name: 'Dr. Michael Foster',
                                    specialty: 'Memory Care Specialist',
                                    clinic: 'Sunnyvale Clinic',
                                    rating: 4.8,
                                    reasons: [
                                      'Speaks Arabic',
                                      'Video sessions',
                                      'Nearby',
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AuthUI.primaryBlue,
                    disabledBackgroundColor: AuthUI.primaryBlue.withOpacity(
                      0.35,
                    ),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('See recommended doctors'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
