import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpdesk_mobile/features/dashboard/data/services/dashboard_service.dart';
import 'package:helpdesk_mobile/features/notification/data/services/notification_service.dart';
import 'package:helpdesk_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:helpdesk_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:helpdesk_mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:helpdesk_mobile/features/ticket/presentation/pages/create_ticket_page.dart';
import 'package:helpdesk_mobile/features/ticket/presentation/pages/ticket_list_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final DashboardService _dashboardService = DashboardService();
  String _userName = 'User';
  Map<String, int> _stats = {};
  List<dynamic> _recentTickets = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
    notificationService.startPolling();
  }

  @override
  void dispose() {
    notificationService.stopPolling();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? 'User';

      final stats = await _dashboardService.getUserStats();
      final recent = await _dashboardService.getRecentTickets();

      if (!mounted) return;
      setState(() {
        _userName = name;
        _stats = stats;
        _recentTickets = recent;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          ListenableBuilder(
            listenable: notificationService,
            builder: (context, _) {
              final count = notificationService.unreadCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage(role: UserRole.user))),
                    icon: const Icon(Icons.notifications_none_rounded),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '$count',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage(role: UserRole.user))),
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(_error!, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 12),
                          ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        _buildHeroCard(),
                        const SizedBox(height: 24),
                        Text('Statistik Tiket', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 14),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.0,
                          children: [
                            _StatCard(title: 'Total Tiket', value: '${_stats['total'] ?? 0}', icon: Icons.confirmation_number_outlined, bgColor: const Color(0xFFEFF6FF), iconColor: const Color(0xFF2563EB)),
                            _StatCard(title: 'Open', value: '${_stats['open'] ?? 0}', icon: Icons.mark_email_unread_outlined, bgColor: const Color(0xFFFFF7ED), iconColor: const Color(0xFFEA580C)),
                            _StatCard(title: 'Progress', value: '${_stats['progress'] ?? 0}', icon: Icons.timelapse_rounded, bgColor: const Color(0xFFEEF2FF), iconColor: const Color(0xFF4F46E5)),
                            _StatCard(title: 'Closed', value: '${_stats['closed'] ?? 0}', icon: Icons.check_circle_outline_rounded, bgColor: const Color(0xFFECFDF5), iconColor: const Color(0xFF059669)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Quick Action', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionCard(
                                title: 'Buat Tiket', subtitle: 'Laporkan kendala baru', icon: Icons.add_box_outlined,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTicketPage())),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ActionCard(
                                title: 'Lihat Tiket', subtitle: 'Cek semua laporan', icon: Icons.receipt_long_outlined,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TicketListPage(role: UserRole.user, currentUserName: _userName))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text('Aktivitas Terbaru', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 14),
                        ...(_recentTickets.isEmpty
                            ? [const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Belum ada aktivitas', style: TextStyle(color: Colors.grey))))]
                            : _recentTickets.map((t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _TicketTile(
                                    title: t['title'] ?? '',
                                    status: t['status'] ?? '',
                                    statusColor: _statusColor(t['status'] ?? ''),
                                  ),
                                ))),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.18), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back 👋', style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 8),
          Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          const Text('Pantau tiket, status, dan aktivitas terbaru dalam satu layar.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'OPEN': return const Color(0xFFEA580C);
      case 'ASSIGNED': return const Color(0xFF2563EB);
      case 'IN_PROGRESS': return const Color(0xFF4F46E5);
      case 'CLOSED': return const Color(0xFF059669);
      default: return const Color(0xFF6B7280);
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _StatCard({required this.title, required this.value, required this.icon, required this.bgColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 38, width: 38, decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: iconColor, size: 20)),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 4),
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
      ]),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
        ]),
      ),
    );
  }
}

class _TicketTile extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;

  const _TicketTile({required this.title, required this.status, required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Row(children: [
        Container(height: 12, width: 12, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface))),
        const SizedBox(width: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: statusColor.withOpacity(0.10), borderRadius: BorderRadius.circular(999)), child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}
