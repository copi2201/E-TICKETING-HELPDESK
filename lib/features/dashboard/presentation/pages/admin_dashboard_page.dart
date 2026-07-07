import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helpdesk_mobile/features/dashboard/data/services/dashboard_service.dart';
import 'package:helpdesk_mobile/features/notification/data/services/notification_service.dart';
import 'package:helpdesk_mobile/features/notification/presentation/pages/notification_page.dart';
import 'package:helpdesk_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:helpdesk_mobile/features/settings/presentation/pages/settings_page.dart';
import 'package:helpdesk_mobile/features/ticket/presentation/pages/ticket_list_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final DashboardService _dashboardService = DashboardService();
  String _userName = 'Administrator';
  Map<String, dynamic> _stats = {};
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
      final name = prefs.getString('name') ?? 'Administrator';

      final stats = await _dashboardService.getAdminStats();
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
    return Scaffold(
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
                        _buildHeader(),
                        const SizedBox(height: 24),
                        _buildHeroCard(),
                        const SizedBox(height: 28),
                        const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionButton(
                                icon: Icons.confirmation_num_outlined, title: 'Tickets',
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketListPage(role: UserRole.admin))),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionButton(
                                icon: Icons.people_outline, title: 'Users',
                                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Management coming soon'))),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionButton(
                                icon: Icons.person_outline, title: 'Profile',
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage(role: UserRole.admin))),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionButton(
                                icon: Icons.settings_outlined, title: 'Settings',
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text('Ringkasan Sistem', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.15,
                          children: [
                            DashboardCard(title: 'Total User', value: '${_stats['totalUsers'] ?? 0}', icon: Icons.people_alt_outlined, color: const Color(0xFF2563EB)),
                            DashboardCard(title: 'Helpdesk', value: '${_stats['totalHelpdesk'] ?? 0}', icon: Icons.support_agent_outlined, color: const Color(0xFF7C3AED)),
                            DashboardCard(title: 'Open Ticket', value: '${_stats['openTickets'] ?? 0}', icon: Icons.confirmation_num_outlined, color: const Color(0xFFFFA726)),
                            DashboardCard(title: 'Closed', value: '${_stats['closedTickets'] ?? 0}', icon: Icons.check_circle_outline, color: const Color(0xFF10B981)),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const Text('Aktivitas Admin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 14),
                        ...(_recentTickets.isEmpty
                            ? [const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Belum ada aktivitas', style: TextStyle(color: Colors.grey))))]
                            : _recentTickets.map((t) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ActivityTile(
                                    title: t['title'] ?? '',
                                    status: t['status'] ?? '',
                                    color: _statusColor(t['status'] ?? ''),
                                  ),
                                ))),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Selamat Datang 👋', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(_userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
          ],
        ),
        ListenableBuilder(
          listenable: notificationService,
          builder: (context, _) {
            final count = notificationService.unreadCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage(role: UserRole.admin))),
                  child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.notifications_none_rounded)),
                ),
                if (count > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    final total = _stats['totalTickets'] ?? 0;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF2563EB)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ADMIN CONTROL CENTER', style: TextStyle(color: Colors.white70, letterSpacing: 1.2, fontSize: 12)),
          const SizedBox(height: 12),
          Text('$total Tiket\nDalam Sistem', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 12),
          const Text('Kelola pengguna, tiket, dan aktivitas helpdesk secara menyeluruh.', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'OPEN': return const Color(0xFFFFA726);
      case 'ASSIGNED': return const Color(0xFF2563EB);
      case 'IN_PROGRESS': return const Color(0xFF4F46E5);
      case 'CLOSED': return const Color(0xFF10B981);
      default: return const Color(0xFF6B7280);
    }
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({super.key, required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 18, offset: const Offset(0, 8))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final String title;
  final String status;
  final Color color;

  const ActivityTile({super.key, required this.title, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22)),
      child: Row(children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 14),
        Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(.12), borderRadius: BorderRadius.circular(999)), child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12))),
      ]),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionButton({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(22), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 18, offset: const Offset(0, 8))]),
        child: Column(children: [
          Icon(icon, color: const Color(0xFF7C3AED), size: 28),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
