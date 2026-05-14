// lib/widgets/app_bar_widget.dart
// Shared top AppBar used across Home, Detection, Result, and History screens.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_theme.dart';
import 'package:flutter/material.dart';

class SignaSpeechAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showMenuIcon;
  final VoidCallback? onMenuTap;

  const SignaSpeechAppBar({
    super.key,
    this.title,
    this.actions,
    this.showMenuIcon = true,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.92),
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      // Subtle bottom border
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.outlineVariant.withOpacity(0.4), height: 1),
      ),
      leading: showMenuIcon
          ? IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.primaryContainer),
        onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
      )
          : null,
      title: Text(
        title ?? 'SignaSpeech',
        style: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
          letterSpacing: -0.5,
        ),
      ),
      actions: actions ??
          [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined,
                  color: AppColors.primaryContainer),
              onPressed: () {},
            ),
          ],
    );
  }
}
