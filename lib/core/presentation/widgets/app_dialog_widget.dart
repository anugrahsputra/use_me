import 'package:flutter/material.dart';
import 'package:use_me/core/presentation/theme/theme.dart';

abstract final class AppDialog {
  static Future<void> showError(BuildContext context, String message) =>
      noticeDialog(context, title: 'Oops!', message: message);

  static Future<void> showSuccess(BuildContext context, String message) =>
      noticeDialog(context, title: 'Success!', message: message);

  static Future<void> noticeDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionMsg,
    VoidCallback? onAction,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAction ?? () => Navigator.of(dialogContext).pop(),
              child: Text(actionMsg ?? 'OK'),
            ),
          ),
        ],
      ),
    );
  }

  // onYes doesn't close the dialog. The caller pops it, so it can keep the
  // dialog up while async work runs.
  static Future<void> confirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required VoidCallback onYes,
    String? confirmMsg,
    String? cancelMsg,
    VoidCallback? onNo,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AppDialogBody(
        title: title,
        message: message,
        actions: [
          Expanded(
            child: OutlinedButton(
              onPressed: onNo ?? () => Navigator.of(dialogContext).pop(),
              child: Text(cancelMsg ?? 'Cancel'),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: onYes,
              child: Text(confirmMsg ?? 'Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppDialogBody extends StatelessWidget {
  const _AppDialogBody({
    required this.title,
    required this.message,
    required this.actions,
  });

  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(children: actions),
          ],
        ),
      ),
    );
  }
}
