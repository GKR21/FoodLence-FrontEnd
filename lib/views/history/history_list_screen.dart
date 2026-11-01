import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────
// Shared model + verdict config (also used by history_detail_screen.dart)
// ─────────────────────────────────────────────────────────────

enum Verdict { safe, caution, unsafe }

extension VerdictStyle on Verdict {
  String get label => switch (this) {
        Verdict.safe => 'Safe',
        Verdict.caution => 'Caution',
        Verdict.unsafe => 'Unsafe',
      };

  Color get color => switch (this) {
        Verdict.safe => const Color(0xFF16A34A),
        Verdict.caution => const Color(0xFFD97706),
        Verdict.unsafe => const Color(0xFFDC2626),
      };

  Color get bg => switch (this) {
        Verdict.safe => const Color(0xFFDCFCE7),
        Verdict.caution => const Color(0xFFFEF3C7),
        Verdict.unsafe => const Color(0xFFFEE2E2),
      };

  Color get dot => switch (this) {
        Verdict.safe => const Color(0xFF22C55E),
        Verdict.caution => const Color(0xFFF59E0B),
        Verdict.unsafe => const Color(0xFFEF4444),
      };

  String get icon => switch (this) {
        Verdict.safe => '✓',
        Verdict.caution => '⚠',
        Verdict.unsafe => '✕',
      };
}

class ScanItem {
  final String name;
  final String date;
  final Verdict verdict;
  final String img;

  const ScanItem({
    required this.name,
    required this.date,
    required this.verdict,
    required this.img,
  });
}

const List<ScanItem> kHistory = [
  ScanItem(
    name: 'Chocolate Chip Cookies',
    date: 'Today, 10:30 AM',
    verdict: Verdict.caution,
    img:
        'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Greek Yogurt',
    date: 'Yesterday, 3:15 PM',
    verdict: Verdict.unsafe,
    img:
        'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Oat Granola Bar',
    date: '12 Sep 2026',
    verdict: Verdict.safe,
    img:
        'https://images.unsplash.com/photo-1571748982800-fa51082c2224?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Instant Noodles',
    date: '11 Sep 2026',
    verdict: Verdict.caution,
    img:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=80&h=80&fit=crop&auto=format',
  ),
  ScanItem(
    name: 'Almond Milk',
    date: '10 Sep 2026',
    verdict: Verdict.safe,
    img:
        'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=80&h=80&fit=crop&auto=format',
  ),
];

// ─────────────────────────────────────────────────────────────
// History List Screen
// ─────────────────────────────────────────────────────────────

enum HistoryFilter { all, safe, caution, unsafe }

class HistoryListScreen extends StatefulWidget {
  /// Called when a history row is tapped (open the detail screen here).
  final ValueChanged<ScanItem> onItemTap;

  /// Called from the empty state's "Start Scanning" button.
  final VoidCallback onStartScanning;

  /// Your existing bottom navigation bar widget (optional).
  final Widget? bottomNavigationBar;

  const HistoryListScreen({
    super.key,
    required this.onItemTap,
    required this.onStartScanning,
    this.bottomNavigationBar,
  });

  @override
  State<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends State<HistoryListScreen> {
  static const _teal = Color(0xFF16A085);

  HistoryFilter _filter = HistoryFilter.all;
  String _search = '';

  List<ScanItem> get _filtered => kHistory.where((item) {
        if (_filter != HistoryFilter.all && item.verdict.name != _filter.name) {
          return false;
        }
        if (_search.isNotEmpty &&
            !item.name.toLowerCase().contains(_search.toLowerCase())) {
          return false;
        }
        return true;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      bottomNavigationBar: widget.bottomNavigationBar,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: items.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _HistoryTile(
                        item: items[i],
                        onTap: () => widget.onItemTap(items[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan History',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          // Search box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _search = v),
                    cursorColor: _teal,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF111827),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search scans...',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: HistoryFilter.values.map((f) {
              final selected = _filter == f;
              final label = f.name[0].toUpperCase() + f.name.substring(1);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? _teal : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.access_time,
                size: 32,
                color: Color(0xFFD1D5DB),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No scans yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan your first food label to see results here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: widget.onStartScanning,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _teal,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  'Start Scanning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatefulWidget {
  final ScanItem item;
  final VoidCallback onTap;

  const _HistoryTile({required this.item, required this.onTap});

  @override
  State<_HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<_HistoryTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final v = item.verdict;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              // Thumbnail + verdict dot
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.img,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: const Color(0xFFF3F4F6),
                        child: const Icon(Icons.fastfood,
                            color: Color(0xFFD1D5DB)),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: v.dot,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: v.bg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${v.icon} ${v.label}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: v.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right,
                  size: 20, color: Color(0xFFD1D5DB)),
            ],
          ),
        ),
      ),
    );
  }
}

