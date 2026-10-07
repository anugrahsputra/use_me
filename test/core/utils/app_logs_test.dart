import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  group('FailureLog', () {
    test('carries the filter key, title and error level', () {
      final log = FailureLog('ServerFailure: boom');

      expect(log.key, FailureLog.logKey);
      expect(log.title, 'failure');
      expect(log.logLevel, LogLevel.error);
      expect(log.message, 'ServerFailure: boom');
    });

    test('keeps the exception and stack trace it was handed', () {
      final exception = Exception('boom');
      final stackTrace = StackTrace.current;

      final log = FailureLog(
        'ServerFailure: boom',
        exception: exception,
        stackTrace: stackTrace,
      );

      expect(log.exception, same(exception));
      expect(log.stackTrace, same(stackTrace));
      expect(log.generateTextMessage(), contains('boom'));
    });

    test('lands in history under its own key', () {
      talker
        ..cleanHistory()
        ..logCustom(FailureLog('x'))
        ..info('unrelated');

      final failures = talker.history
          .where((e) => e.key == FailureLog.logKey)
          .toList();
      expect(failures, hasLength(1));
    });
  });
}
