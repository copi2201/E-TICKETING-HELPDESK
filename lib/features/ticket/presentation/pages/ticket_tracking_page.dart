import 'package:flutter/material.dart';

class TicketTrackingPage extends StatelessWidget {
  const TicketTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tracking Tiket',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF2563EB),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TIKET #HD-1024",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Internet Lab Komputer Bermasalah",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Status saat ini: Sedang Diproses oleh Tim Helpdesk.",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Text(
            "Riwayat Perjalanan Tiket",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 20),

          const TimelineItem(
            title: "Tiket Dibuat",
            subtitle: "05 Juli 2026 • 08:30",
            description:
            "Pengguna melaporkan masalah internet pada laboratorium komputer.",
            color: Color(0xFF2563EB),
            isCompleted: true,
          ),

          TimelineItemConnector(),

          const TimelineItem(
            title: "Ditugaskan ke Helpdesk",
            subtitle: "05 Juli 2026 • 09:00",
            description:
            "Admin menugaskan tiket kepada Tim Infrastruktur Jaringan.",
            color: Color(0xFF7C3AED),
            isCompleted: true,
          ),

          TimelineItemConnector(),

          const TimelineItem(
            title: "Sedang Diproses",
            subtitle: "05 Juli 2026 • 10:15",
            description:
            "Tim helpdesk sedang melakukan pengecekan perangkat jaringan.",
            color: Color(0xFFFFA726),
            isCompleted: true,
          ),

          TimelineItemConnector(),

          const TimelineItem(
            title: "Tiket Selesai",
            subtitle: "Menunggu penyelesaian",
            description:
            "Status akan berubah setelah pekerjaan selesai dilakukan.",
            color: Color(0xFF10B981),
            isCompleted: false,
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Kembali"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final bool isCompleted;

  const TimelineItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: isCompleted ? color : Colors.white,
            border: Border.all(
              color: color,
              width: 3,
            ),
            shape: BoxShape.circle,
          ),
          child: isCompleted
              ? const Icon(
            Icons.check,
            size: 12,
            color: Colors.white,
          )
              : null,
        ),

        const SizedBox(width: 16),

        Expanded(
            child: Container(
              padding: const EdgeInsets.all(18),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }
}

class TimelineItemConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        width: 2,
        height: 28,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}