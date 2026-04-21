import 'package:flutter/material.dart';
import 'package:helpdesk_mobile/core/theme/theme_controller.dart';
import 'package:helpdesk_mobile/features/auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFF1D4ED8),
                  child: Icon(
                    Icons.person,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'Admin Helpdesk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'admin.helpdesk@kampus.ac.id',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'IT Support Division',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
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
            subtitle: 'Admin Helpdesk',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'admin.helpdesk@kampus.ac.id',
            onTap: () {},
          ),
          _ProfileTile(
            icon: Icons.work_outline_rounded,
            title: 'Divisi',
            subtitle: 'IT Support Division',
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
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
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
        leading: Icon(
          icon,
          color: iconColor ?? const Color(0xFF1D4ED8),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: textColor?.withOpacity(0.8),
          ),
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