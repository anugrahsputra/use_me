// use this for single object response
import 'dart:isolate';

import 'package:use_me/core/core.dart';

class IsolateParser<T> {
  IsolateParser(this.json, this.converter);
  final Map<String, dynamic> json;
  final ResponseConverter<T> converter;

  Future<T> parseInBackground() async {
    final port = ReceivePort();
    await Isolate.spawn<_ParserPayload<T>>(
      _parseAndSend,
      _ParserPayload(json, converter, port.sendPort),
    );

    final message = await port.first;
    if (message is _ParserError) {
      throw UnknownException(message: message.message);
    }
    return message as T;
  }

  static void _parseAndSend<T>(_ParserPayload<T> payload) {
    Object? result;
    try {
      result = payload.converter(payload.json);
    } catch (e) {
      result = _ParserError('$e');
    }
    Isolate.exit(payload.sendPort, result);
  }
}

class _ParserPayload<T> {
  _ParserPayload(this.json, this.converter, this.sendPort);
  final Map<String, dynamic> json;
  final ResponseConverter<T> converter;
  final SendPort sendPort;
}

class _ParserError {
  _ParserError(this.message);
  final String message;
}
