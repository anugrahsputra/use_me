import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

const _fineColor = '\x1B[32m'; // Green
const _infoColor = '\x1B[33m'; // Yellow
const _severeColor = '\x1B[31m'; // Red
const _resetColor = '\x1B[0m'; // ✅ Fix: was '\x1B' (incomplete escape)

abstract class AppLogging {
  static bool isInitialize = false;

  static Future<void> initialize({
    bool showLog = false,
    bool? enableColor,
  }) async {
    if (!AppLogging.isInitialize) {
      Logger.root.level = showLog ? Level.ALL : Level.OFF;

      Logger.root.onRecord.listen((record) {
        final level = record.level;
        final name = record.loggerName;
        final message = record.message;
        final stackTrace = record.stackTrace;
        final error = record.error;

        final bool useColor =
            enableColor ??
            (stdout.supportsAnsiEscapes &&
                !Platform.isIOS &&
                !Platform.isAndroid);

        String levelColor = '';
        String resetColor = '';

        if (useColor) {
          levelColor = switch (level) {
            Level.FINE || Level.FINER || Level.FINEST => _fineColor,
            Level.SEVERE || Level.SHOUT || Level.WARNING => _severeColor,
            Level.INFO || Level.CONFIG => _infoColor,
            _ => '',
          };
          resetColor = _resetColor;
        }

        final formattedMessage =
            '$levelColor[${level.name}][$name] : $message$resetColor';
        final errorString = error != null ? '\n  Error      : $error' : '';
        final stackTraceString = stackTrace != null
            ? '\n  StackTrace : $stackTrace'
            : '';
        final fullMessage = formattedMessage + errorString + stackTraceString;

        // ✅ Prints to terminal (Neovim, CLI, flutter run in terminal)
        // Routes WARNING/SEVERE to stderr, everything else to stdout
        if (level >= Level.WARNING) {
          stderr.writeln(fullMessage);
        } else {
          stdout.writeln(fullMessage);
        }

        debugPrint(fullMessage);

        // ✅ Keep this if you still want VSCode debug console support
        developer.log(fullMessage, name: name);
      });

      AppLogging.isInitialize = true;
    }
  }
}
