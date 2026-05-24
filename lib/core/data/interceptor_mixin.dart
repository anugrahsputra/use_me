import 'dart:io';

import 'package:dio/dio.dart';

mixin InterceptorMixin on Interceptor {
  bool isConnectionError(DioException err) {
    return (err.type == DioExceptionType.unknown &&
            err.error != null &&
            err.error is SocketException) ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout;
  }
}
