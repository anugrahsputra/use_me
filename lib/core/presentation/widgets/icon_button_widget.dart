import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.onTap, required this.icon, super.key});

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          border: Border.all(color: AppColors.muted.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Icon(icon, size: 22, color: AppColors.muted),
          ),
        ),
      ),
    );
  }
}
