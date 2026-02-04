import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/reverie_ui.dart';
import '../../providers/doctor_dashboard_provider.dart';
import '../../model/doctor_dashboard_models.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<DoctorDashboardProvider>();
    final items = p.filteredPatients;

    return Container(
      color: Rv.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patients",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Rv.text,
                    )),
            const SizedBox(height: 6),
            Text("${p.patientsAllCount} patients under your care",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Rv.subtext)),

            const SizedBox(height: 14),

            _SearchBar(
              onChanged: p.setPatientsSearch,
            ),

            const SizedBox(height: 12),

            _PatientsFilterRow(
              selected: p.patientsFilter,
              allCount: p.patientsAllCount,
              activeCount: p.patientsActiveCount,
              inactiveCount: p.patientsInactiveCount,
              onSelect: p.setPatientsFilter,
            ),

            const SizedBox(height: 14),

            ...items.map((patient) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _PatientCard(patient: patient),
                )),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Rv.cardDeco(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search_rounded),
          hintText: "Search patients...",
        ),
      ),
    );
  }
}

class _PatientsFilterRow extends StatelessWidget {
  final PatientsFilter selected;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final void Function(PatientsFilter) onSelect;

  const _PatientsFilterRow({
    required this.selected,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        _Chip(
          text: "All ($allCount)",
          selected: selected == PatientsFilter.all,
          onTap: () => onSelect(PatientsFilter.all),
        ),
        _Chip(
          text: "Active ($activeCount)",
          selected: selected == PatientsFilter.active,
          onTap: () => onSelect(PatientsFilter.active),
        ),
        _Chip(
          text: "Inactive ($inactiveCount)",
          selected: selected == PatientsFilter.inactive,
          onTap: () => onSelect(PatientsFilter.inactive),
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

class _PatientCard extends StatelessWidget {
  final PatientCardModel patient;
  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final isActive = patient.status == PatientStatus.active;

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
                child: Text(patient.initials,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patient.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFECFDF3) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isActive ? "Active" : "Inactive",
                        style: TextStyle(
                          color: isActive ? const Color(0xFF16A34A) : Rv.subtext,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded),
                onPressed: () => _showPatientMenu(context, patient),
              )
            ],
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("Last session: ${patient.lastSessionLabel}",
                style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Total sessions: ${patient.totalSessions}",
                style: TextStyle(color: Rv.subtext, fontWeight: FontWeight.w600)),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _LightButton(
                  text: "View\nProfile",
                  icon: Icons.remove_red_eye_outlined,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrimaryButton(
                  text: "Schedule",
                  icon: Icons.calendar_month_rounded,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPatientMenu(BuildContext context, PatientCardModel p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: Rv.radius(20)),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              _SheetItem(text: "View Sessions", onTap: () => Navigator.pop(context)),
              _SheetItem(text: "Edit Notes", onTap: () => Navigator.pop(context)),
              const SizedBox(height: 4),
              _SheetItem(
                text: "Remove Patient",
                isDanger: true,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SheetItem extends StatelessWidget {
  final String text;
  final bool isDanger;
  final VoidCallback onTap;

  const _SheetItem({required this.text, required this.onTap, this.isDanger = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: isDanger ? const Color(0xFFEF4444) : Rv.text,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _LightButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _LightButton({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Rv.subtext),
        label: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Rv.text, fontWeight: FontWeight.w900)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF1F5F9),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(16)),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _PrimaryButton({required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Rv.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: Rv.radius(16)),
        ),
      ),
    );
  }
}
