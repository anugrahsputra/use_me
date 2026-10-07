import 'package:talker_flutter/talker_flutter.dart';

class FailureLog extends TalkerLog {
  FailureLog(super.message, {super.exception, super.stackTrace})
    : super(key: logKey, title: 'failure', logLevel: LogLevel.error);

  static const logKey = 'failure';

  @override
  AnsiPen get pen => AnsiPen()..red();
}
