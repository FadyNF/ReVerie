import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/reverie_ui.dart';
import '../../providers/doctor_dashboard_provider.dart';
import '../../model/doctor_dashboard_models.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DoctorDashboardProvider>();
    final items = p.filteredRequests;

    return Container(
      color: Rv.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Requests",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Rv.text,
                    )),
            const SizedBox(height: 6),
            Text("${p.allCount} pending requests",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Rv.subtext)),

            const SizedBox(height: 14),

            _RequestsFilterRow(
              selected: p.requestsFilter,
              allCount: p.allCount,
              admissionCount: p.admissionCount,
              sessionCount: p.sessionCount,
              onSelect: p.setRequestsFilter,
            ),

            const SizedBox(height: 14),

            ...items.map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _RequestCard(request: r),
                )),
          ],
        ),
      ),
    );
  }
}

class _RequestsFilterRow extends StatelessWidget {
  final RequestsFilter selected;
  final int allCount;
  final int admissionCount;
  final int sessionCount;
  final void Function(RequestsFilter) onSelect;

  const _RequestsFilterRow({
    required this.selected,
    required this.allCount,
    required this.admissionCount,
    required this.sessionCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        _Chip(
          text: "All ($allCount)",
          selected: selected == RequestsFilter.all,
          onTap: () => onSelect(RequestsFilter.all),
        ),
        _Chip(
          text: "Admission ($admissionCount)",
          selected: selected == RequestsFilter.admission,
          onTap: () => onSelect(RequestsFilter.admission),
        ),
        _Chip(
          text: "Session ($sessionCount)",
          selected: selected == RequestsFilter.session,
          onTap: () => onSelect(RequestsFilter.session),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Rv.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: selected ? Rv.primary : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Rv.subtext,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final DoctorRequest request;
  const _RequestCard({required this.request});

  String get _typeLabel => request.type == RequestType.admission ? "Admission Request" : "Session Request";

  @override
  Widget build(BuildContext context) {
    final isPriority = request.priority == PriorityLevel.priority;
    final isSession = request.type == RequestType.session;

    return Container(
      decoration: Rv.cardDeco(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Rv.primary,
                child: Text(request.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.patientName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(text: _typeLabel, bg: Rv.chipBg, fg: Rv.primary),
                        if (isPriority) _Pill(text: "Priority", bg: const Color(0xFFFFF7ED), fg: const Color(0xFFF59E0B)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _MetaRow(icon: Icons.calendar_today_rounded, text: request.dateRangeLabel),
          const SizedBox(height: 10),

          if (isSession && request.sceneTitle != null) ...[
            _MetaRow(icon: Icons.access_time_rounded, text: request.sceneTitle!),
            const SizedBox(height: 10),
          ],
          if (isSession && request.sceneName != null) ...[
            _MetaRow(icon: Icons.image_outlined, text: request.sceneName!),
            const SizedBox(height: 10),
          ],

          Align(
            alignment: Alignment.centerLeft,
            child: Text(request.meta, style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _GhostButton(
                  text: "Decline",
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryButton(
                  text: isSession ? "Approve &\nSchedule" : "Approve",
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Rv.subtext),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700))),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w800)),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _GhostButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F5F9),
          foregroundColor: Rv.subtext,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(16)),
        ),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Rv.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(16)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

