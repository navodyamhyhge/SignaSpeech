// lib/widgets/bottom_nav_widget.dart
// Shared bottom navigation bar for Home, Detection, and History screens.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import '../core/theme.dart';
import 'package:flutter/material.dart';

class SignaSpeechBottomNav extends StatelessWidget {
  /// 0 = Home, 1 = Translate, 2 = History
  final int currentIndex;

  const SignaSpeechBottomNav({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.detection);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.history);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentIndex == 0,
            onTap: () => _onTap(context, 0),
          ),
          _NavItem(
            icon: Icons.videocam_rounded,
            label: 'Translate',
            isActive: currentIndex == 1,
            onTap: () => _onTap(context, 1),
          ),
          _NavItem(
            icon: Icons.history_rounded,
            label: 'History',
            isActive: currentIndex == 2,
            onTap: () => _onTap(context, 2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryContainer.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primaryContainer : AppColors.outline,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.primaryContainer : AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
