import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          const SectionTitle(title: "Notification"),

          const SizedBox(height: 12),

          const SettingTile(
            icon: Icons.notifications_active_outlined,
            title: "Push Notification",
            subtitle: "Aktif",
          ),

          const SettingTile(
            icon: Icons.email_outlined,
            title: "Email Notification",
            subtitle: "Aktif",
          ),

          const SizedBox(height: 24),

          const SectionTitle(title: "Application"),

          const SizedBox(height: 12),

          const SettingTile(
            icon: Icons.info_outline,
            title: "Tentang Aplikasi",
            subtitle: "E-Ticketing Helpdesk v1.0.0",
          ),

          const SettingTile(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            subtitle: "Lihat kebijakan privasi",
          ),

          const SettingTile(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            subtitle: "Syarat dan ketentuan",
          ),

          const SizedBox(height: 30),

          Center(
            child: Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        ),
      ),
    );
  }
}