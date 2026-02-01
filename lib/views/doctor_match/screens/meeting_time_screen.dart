import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/widgets/step_progress_bar.dart';

import 'package:reverie/views/doctor_match/screens/meeting_location_screen.dart';

class _Choice {
  final String id; // backend id
  final String label; // UI label
  const _Choice(this.id, this.label);
}

class MeetingTimeScreen extends StatefulWidget {
  const MeetingTimeScreen({super.key});

  @override
  State<MeetingTimeScreen> createState() => _MeetingTimeScreenState();
}

class _MeetingTimeScreenState extends State<MeetingTimeScreen> {
  // Single-choice (required)
  String? _selectedTimeOfDayId;

  // Multi-choice (required at least one)
  final Set<String> _selectedDayIds = {};

  final List<_Choice> _timeOfDay = const [
    _Choice('morning', 'Morning'),
    _Choice('afternoon', 'Afternoon'),
    _Choice('evening', 'Evening'),
  ];

  final List<_Choice> _daysOfWeek = const [
    _Choice('mon', 'Mon'),
    _Choice('tue', 'Tue'),
    _Choice('wed', 'Wed'),
    _Choice('thu', 'Thu'),
    _Choice('fri', 'Fri'),
    _Choice('sat', 'Sat'),
    _Choice('sun', 'Sun'),
  ];

  bool get _canContinue =>
      _selectedTimeOfDayId != null && _selectedDayIds.isNotEmpty;

  void _selectTimeOfDay(String id) {
    setState(() => _selectedTimeOfDayId = id);
  }

  void _toggleDay(String id) {
    setState(() {
      if (_selectedDayIds.contains(id)) {
        _selectedDayIds.remove(id);
      } else {
        _selectedDayIds.add(id);
      }
    });
  }

  Widget _pill({
    required bool selected,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AuthUI.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AuthUI.primaryBlue : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _dayBox({
    required bool selected,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AuthUI.primaryBlue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
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
            // Step 2 of 4
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StepProgressBar(currentStep: 2, totalSteps: 4),
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
                      'When would you like to meet?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select your preferred times',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Time of day',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _timeOfDay.map((t) {
                        final selected = _selectedTimeOfDayId == t.id;
                        return _pill(
                          selected: selected,
                          label: t.label,
                          onTap: () => _selectTimeOfDay(t.id),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Days of week',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.2,
                      children: _daysOfWeek.map((d) {
                        final selected = _selectedDayIds.contains(d.id);
                        return _dayBox(
                          selected: selected,
                          label: d.label,
                          onTap: () => _toggleDay(d.id),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            // Continue button (disabled until both groups have at least 1 selected)
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
                            'time_of_day': _selectedTimeOfDayId, // String
                            'days': _selectedDayIds.toList(), // List<String>
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MeetingLocationScreen(),
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
                      borderRadius: BorderRadius.circular(18),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
