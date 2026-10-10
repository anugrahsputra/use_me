import 'package:flutter/material.dart';

class OutlinedButtonWidget extends StatelessWidget {
  const OutlinedButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.isEnabled = true,
    this.fillColor,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final borderColor = isEnabled
        ? scheme.outline
        : scheme.outline.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: 52,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: fillColor ?? scheme.surface,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Align(child: child),
        ),
      ),
    );
  }
}
