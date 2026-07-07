import 'package:flutter/material.dart';
import 'package:helpdesk_mobile/core/theme/theme_controller.dart';
import 'package:helpdesk_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:helpdesk_mobile/features/notification/data/services/notification_service.dart';

enum UserRole { user, helpdesk, admin }

class ProfilePage extends StatelessWidget {
  final UserRole role;

  const ProfilePage({super.key, required this.role});

  // Data per role, gampang ditambah/diedit
  Map<String, dynamic> get _data {
    switch (role) {
      case UserRole.admin:
        return {
          'name': 'Admin Helpdesk',
          'email': 'admin.helpdesk@kampus.ac.id',
          'divisionLabel': 'Divisi',
          'division': 'IT Support Division',
          'color': const Color(0xFF7C3AED),
        };
      case UserRole.helpdesk:
        return {
          'name': 'Staff Helpdesk',
          'email': 'staff.helpdesk@kampus.ac.id',
          'divisionLabel': 'Divisi',
          'division': 'Helpdesk Support Team',
          'color': const Color(0xFF2563EB),
        };
      case UserRole.user:
        return {
          'name': 'Pengguna',
          'email': 'user@kampus.ac.id',
          'divisionLabel': 'Program Studi',
          'division': 'Teknik Informatika',
          'color': const Color(0xFF1D4ED8),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final Color accent = data['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
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
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: accent,
                  child: const Icon(
                    Icons.person,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data['name'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data['email'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  data['division'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const _SectionTitle(title: 'Account'),
          const SizedBox(height: 10),
          _ProfileTile(
            icon: Icons.badge_outlined,
            title: 'Nama Lengkap',
            subtitle: data['name'] as String,
            accent: accent,
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: data['email'] as String,
            accent: accent,
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.work_outline_rounded,
            title: data['divisionLabel'] as String,
            subtitle: data['division'] as String,
            accent: accent,
            onTap: () {},
          ),
          const SizedBox(height: 22),
          const _SectionTitle(title: 'Preferences'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, mode, _) {
                final isDark = mode == ThemeMode.dark;
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: isDark,
                  onChanged: (value) {
                    themeModeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
                  },
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Aktifkan tema gelap'),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const _SectionTitle(title: 'Session'),
          const SizedBox(height: 10),
          _ProfileTile(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Keluar dari aplikasi',
            iconColor: Colors.red,
            textColor: Colors.red,
            accent: accent,
            onTap: () {
              notificationService.stopPolling();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color accent;
  final Color? iconColor;
  final Color? textColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.accent,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? accent),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: textColor?.withOpacity(0.8)),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: textColor ?? Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}