import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:use_me/core/core.dart';

extension DioExceptionX on DioException {
  bool get isConnectionError =>
      type == DioExceptionType.connectionError ||
      type == DioExceptionType.connectionTimeout ||
      (type == DioExceptionType.unknown && error is SocketException);

  DioException withError(Exception exception) =>
      DioException(requestOptions: requestOptions, error: exception);

  DioException? toTyped() {
    final status = response?.statusCode;
    if (response == null) return null;

    final Exception exception = switch (status) {
      400 => BadRequestException(message: serverMessage('BadRequestException')),
      403 => ForbiddenException(message: serverMessage('ForbiddenException')),
      404 => NotFoundException(message: serverMessage('NotFoundException')),
      409 => ConflictException(message: serverMessage('ConflictException')),
      _ => ServerException(message: serverMessage('Server Exception')),
    };
    return withError(exception);
  }

  DioException unauthorized([String? message]) => withError(
    UnauthorizedException(
      message: message ?? serverMessage('UnauthorizedException'),
    ),
  );

  String serverMessage(String fallback) => _bodyString('message') ?? fallback;

  String? _bodyString(String key) {
    var data = response?.data;

    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        return null;
      }
    }

    if (data is Map<String, dynamic>) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value;
    }

    return null;
  }
}
