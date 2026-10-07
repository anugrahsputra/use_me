import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:use_me/core/core.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerOverlay extends StatelessWidget {
  const TalkerOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return Stack(
      children: [
        child,
        Positioned(
          right: 12,
          bottom: MediaQuery.sizeOf(context).height * 0.2,
          child: SafeArea(
            child: Opacity(
              opacity: 0.8,
              child: FloatingActionButton.small(
                heroTag: 'talker-overlay',
                onPressed: () => _openLogs(context),
                child: const Icon(Icons.bug_report_outlined),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openLogs(BuildContext context) {
    final navigator = router.routerDelegate.navigatorKey.currentState;
    if (navigator == null || _isOpen) return;
    _isOpen = true;
    navigator
        .push(
          MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/talker'),
            builder: (_) => TalkerScreen(talker: talker),
          ),
        )
        .whenComplete(() => _isOpen = false);
  }
}

bool _isOpen = false;
