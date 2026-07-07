import 'package:flutter/material.dart';
import 'package:helpdesk_mobile/features/ticket/data/models/ticket_model.dart';

class TicketTimeline extends StatelessWidget {
  final List<TicketHistory> histories;

  const TicketTimeline({
    super.key,
    required this.histories,
  });

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return const Color(0xFFEA580C);

      case 'ASSIGNED':
        return const Color(0xFF0EA5E9);

      case 'IN_PROGRESS':
        return const Color(0xFF4F46E5);

      case 'CLOSED':
        return const Color(0xFF059669);

      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return Icons.add_circle_outline_rounded;

      case 'ASSIGNED':
        return Icons.person_add_alt_1_rounded;

      case 'IN_PROGRESS':
        return Icons.timelapse_rounded;

      case 'CLOSED':
        return Icons.check_circle_rounded;

      default:
        return Icons.circle_outlined;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return 'Tiket Dibuat';

      case 'ASSIGNED':
        return 'Ditugaskan';

      case 'IN_PROGRESS':
        return 'Sedang Dikerjakan';

      case 'CLOSED':
        return 'Selesai';

      default:
        return status;
    }
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) return value;

    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day $month $year • $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    if (histories.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Belum ada riwayat',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.5),
            ),
          ),
        ),
      );
    }

    final sortedHistories = [...histories]
      ..sort((a, b) {
        final da = DateTime.tryParse(a.createdAt);
        final db = DateTime.tryParse(b.createdAt);

        if (da == null || db == null) return 0;

        return da.compareTo(db);
      });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Riwayat Tiket',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(
            sortedHistories.length,
                (index) {
              final history = sortedHistories[index];
              final isLast = index == sortedHistories.length - 1;

              return _TimelineEntry(
                color: _getStatusColor(history.status),
                icon: _getStatusIcon(history.status),
                title: _getStatusLabel(history.status),
                subtitle: 'oleh ${history.changedBy}',
                date: _formatDate(history.createdAt),
                note: history.note,
                isLast: isLast,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final String date;
  final String? note;
  final bool isLast;

  const _TimelineEntry({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.date,
    this.note,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.60),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.45),
                    ),
                  ),
                  if (note != null && note!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        note!,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.70),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}