import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool showInfoButton;
  final VoidCallback? onInfoTap;
  final List<Widget>? extraActions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackTap,
    this.showInfoButton = false,
    this.onInfoTap,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 22,
              ),
              onPressed: onBackTap ?? () => Get.back(),
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.nunito(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border.withOpacity(0.8)),
      ),
      actions: [
        if (showInfoButton)
          IconButton(
            icon: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
            onPressed: onInfoTap,
          ),
        if (extraActions != null) ...extraActions!,
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
