import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final bool showBackButton;
  final Widget? title;
  final Color? backButtonColor;

  const CustomAppBar({
    super.key,
    this.backgroundColor,
    this.showBackButton = false,
    this.title,
    this.backButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: 0,
      titleSpacing: 16,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: backButtonColor ?? AppColors.primaryText, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: title ?? const AppLogo(size: 28),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
