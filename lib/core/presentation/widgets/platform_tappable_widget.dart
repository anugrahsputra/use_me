import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformTappableWidget extends StatelessWidget {
  const PlatformTappableWidget({
    required this.onTap,
    required this.child,
    super.key,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              onPressed: onTap,
              child: child,
            )
          : InkWell(onTap: onTap, borderRadius: borderRadius, child: child),
    );
  }
}
