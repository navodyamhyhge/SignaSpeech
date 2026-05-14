// lib/widgets/app_drawer.dart
// Side drawer shown when the user taps the hamburger menu icon.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../core/theme.dart';
import '../services/auth_service.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;

  const AppDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── User Profile Header ─────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                        style: GoogleFonts.lexend(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: GoogleFonts.lexend(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userEmail,
                          style: GoogleFonts.publicSans(
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Divider(color: AppColors.outlineVariant),
              const SizedBox(height: 8),

              // ── Navigation items ────────────────────────────────────────
              _DrawerItem(
                icon: Icons.home_rounded,
                label: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              _DrawerItem(
                icon: Icons.videocam_rounded,
                label: 'Live Translation',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.detection);
                },
              ),
              _DrawerItem(
                icon: Icons.history_rounded,
                label: 'Translation History',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.history);
                },
              ),
              _DrawerItem(
                icon: Icons.translate_rounded,
                label: 'Language Settings',
                onTap: () => Navigator.pop(context),
              ),
              _DrawerItem(
                icon: Icons.help_outline_rounded,
                label: 'Help Center',
                onTap: () => Navigator.pop(context),
              ),

              const Spacer(),
              const Divider(color: AppColors.outlineVariant),

              // ── Logout ──────────────────────────────────────────────────
              _DrawerItem(
                icon: Icons.logout_rounded,
                label: 'Logout',
                iconColor: AppColors.error,
                textColor: AppColors.error,
                onTap: () async {
                  Navigator.pop(context);
                  await AuthService().signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? AppColors.onSurfaceVariant, size: 22),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor ?? AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
