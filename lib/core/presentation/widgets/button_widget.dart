import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/widgets/platform_tappable_widget.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.isEnabled = true,
    this.width,
    this.height,
    this.color,
  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? Theme.of(context).colorScheme.primary;
    final isBtnEnabled = isEnabled
        ? primaryColor
        : primaryColor.withValues(alpha: 0.5);
    final radius = BorderRadius.circular(16);

    return PlatformTappableWidget(
      onTap: onTap,
      borderRadius: radius,
      child: Ink(
        width: width ?? double.infinity,
        height: height ?? 52,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: isBtnEnabled, borderRadius: radius),
        child: Align(child: child),
      ),
    );
  }
}
