import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

class DividerWithTextWidget extends StatelessWidget {
  const DividerWithTextWidget({this.isVertical = false, this.text, super.key});

  final bool isVertical;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final label = text;
    if (isVertical) return const VerticalDivider();
    if (label == null) return const Divider();

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.muted, thickness: 0.5)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: Divider(color: AppColors.muted, thickness: 0.5)),
      ],
    );
  }
}
