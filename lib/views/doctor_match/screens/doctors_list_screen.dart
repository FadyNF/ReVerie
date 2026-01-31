import 'package:flutter/material.dart';
import 'package:reverie/views/auth/auth_ui.dart';
import 'package:reverie/views/doctor_match/models/doctor_profile_model.dart';
import 'package:reverie/views/doctor_match/screens/doctor_profile_screen.dart';

class FindDoctorScreen extends StatefulWidget {
  /// Backend later:
  /// - pass fetched list, or
  /// - fetch inside via repository/provider
  final List<DoctorProfileModel> allDoctors;

  const FindDoctorScreen({super.key, required this.allDoctors});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  final _search = TextEditingController();

  bool filterAvailableNow = false;
  bool filterArabic = false;
  bool filterVideo = false;
  bool filterNearby = false;

  SortMode sortMode = SortMode.none;

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<DoctorProfileModel> get _filtered {
    final q = _search.text.trim().toLowerCase();

    var list = widget.allDoctors.where((d) {
      final matchesQuery =
          q.isEmpty ||
          d.name.toLowerCase().contains(q) ||
          d.clinic.toLowerCase().contains(q) ||
          d.specialty.toLowerCase().contains(q);

      if (!matchesQuery) return false;

      // These are frontend-only flags (backend later)
      if (filterAvailableNow && !_isAvailableNow(d)) return false;
      if (filterArabic &&
          !d.languages.map((e) => e.toLowerCase()).contains('arabic'))
        return false;
      if (filterVideo && !_supportsVideo(d)) return false;
      if (filterNearby && !_isNearby(d)) return false;

      return true;
    }).toList();

    // Sorting
    switch (sortMode) {
      case SortMode.ratingHigh:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortMode.ratingLow:
        list.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case SortMode.none:
        break;
    }

    return list;
  }

  // ---- Dummy flags for now (replace with backend fields later) ----
  bool _isAvailableNow(DoctorProfileModel d) {
    // Dummy logic: if availability map not empty => "available"
    return d.availability.isNotEmpty;
  }

  bool _supportsVideo(DoctorProfileModel d) {
    // Dummy logic: if tags contains "Video"
    return d.tags.map((e) => e.toLowerCase()).contains('video');
  }

  bool _isNearby(DoctorProfileModel d) {
    // Needs location later; for now fake it
    return d.tags.map((e) => e.toLowerCase()).contains('nearby');
  }
  // ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find a Doctor',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: _SearchBar(controller: _search),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _SmallAction(
                    icon: Icons.tune_rounded,
                    label: 'Filter',
                    onTap: _openFilterSheet,
                  ),
                  const SizedBox(width: 10),
                  _SmallAction(
                    icon: Icons.swap_vert_rounded,
                    label: 'Sort',
                    onTap: _openSortSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ToggleChip(
                      label: 'Available now',
                      selected: filterAvailableNow,
                      onTap: () => setState(
                        () => filterAvailableNow = !filterAvailableNow,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _ToggleChip(
                      label: 'Arabic',
                      selected: filterArabic,
                      onTap: () => setState(() => filterArabic = !filterArabic),
                    ),
                    const SizedBox(width: 10),
                    _ToggleChip(
                      label: 'Video',
                      selected: filterVideo,
                      onTap: () => setState(() => filterVideo = !filterVideo),
                    ),
                    const SizedBox(width: 10),
                    _ToggleChip(
                      label: 'Nearby',
                      selected: filterNearby,
                      onTap: () => setState(() => filterNearby = !filterNearby),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final d = list[i];
                  return _DoctorRowCard(
                    doctor: d,
                    onViewProfile: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorProfileScreen(doctor: d),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              const SizedBox(height: 12),
              _SortTile(
                title: 'None',
                selected: sortMode == SortMode.none,
                onTap: () => setState(() => sortMode = SortMode.none),
              ),
              _SortTile(
                title: 'Rating: High to Low',
                selected: sortMode == SortMode.ratingHigh,
                onTap: () => setState(() => sortMode = SortMode.ratingHigh),
              ),
              _SortTile(
                title: 'Rating: Low to High',
                selected: sortMode == SortMode.ratingLow,
                onTap: () => setState(() => sortMode = SortMode.ratingLow),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AuthUI.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _SwitchRow(
                    title: 'Available now',
                    value: filterAvailableNow,
                    onChanged: (v) => setLocal(() => filterAvailableNow = v),
                  ),
                  _SwitchRow(
                    title: 'Arabic',
                    value: filterArabic,
                    onChanged: (v) => setLocal(() => filterArabic = v),
                  ),
                  _SwitchRow(
                    title: 'Video',
                    value: filterVideo,
                    onChanged: (v) => setLocal(() => filterVideo = v),
                  ),
                  _SwitchRow(
                    title: 'Nearby',
                    value: filterNearby,
                    onChanged: (v) => setLocal(() => filterNearby = v),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setLocal(() {
                              filterAvailableNow = false;
                              filterArabic = false;
                              filterVideo = false;
                              filterNearby = false;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey.shade800,
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {}); // apply filters to list
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AuthUI.primaryBlue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

enum SortMode { none, ratingHigh, ratingLow }

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by name, clinic, specialty...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SmallAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade700),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AuthUI.primaryBlue.withOpacity(0.12) : Colors.white;
    final border = selected ? AuthUI.primaryBlue : Colors.transparent;
    final text = selected ? AuthUI.primaryBlue : Colors.grey.shade800;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: text,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}

class _DoctorRowCard extends StatelessWidget {
  final DoctorProfileModel doctor;
  final VoidCallback onViewProfile;

  const _DoctorRowCard({required this.doctor, required this.onViewProfile});

  @override
  Widget build(BuildContext context) {
    final available = doctor.availability.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AuthUI.primaryBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              doctor.initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doctor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onViewProfile,
                      child: const Text(
                        'View Profile',
                        style: TextStyle(
                          color: AuthUI.primaryBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.specialty,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.clinic,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: available
                          ? const Color(0xFF3BB273)
                          : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      available ? 'Available' : 'Unavailable',
                      style: TextStyle(
                        color: available
                            ? const Color(0xFF3BB273)
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: Color(0xFFF4B000),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SortTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SortTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AuthUI.primaryBlue)
          : const Icon(Icons.circle_outlined, color: Colors.grey),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      value: value,
      onChanged: onChanged,
      activeColor: AuthUI.primaryBlue,
    );
  }
}
