import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.isEnabled = false,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isBtnEnabled = isEnabled
        ? primaryColor
        : primaryColor.withValues(alpha: 0.5);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 1,
          height: 52,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isBtnEnabled,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Align(child: child),
        ),
      ),
    );
  }
}
