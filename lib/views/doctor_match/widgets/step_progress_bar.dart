import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep; // 1-based
  final int totalSteps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final stepIndex = i + 1;
        final isActive = stepIndex <= currentStep;

        return Expanded(
          child: Container(
            height: 3,
            margin: EdgeInsets.only(right: i == totalSteps - 1 ? 0 : 8),
            decoration: BoxDecoration(
              color: isActive ? AuthUI.primaryBlue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}
