import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:use_me/core/core.dart';

typedef ResponseConverter<T> = T Function(Map<String, dynamic> json);

extension ClientParser on Client {
  Future<T> getParsed<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useIsolate = true,
  }) async {
    final response = await get(
      url,
      queryParameters: queryParameters,
      options: options,
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    return useIsolate
        ? await IsolateParser<T>(data, converter).parseInBackground()
        : converter(data);
  }

  Future<T> postParsed<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) async {
    final response = await post(
      url,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    return useIsolate
        ? await IsolateParser<T>(responseData, converter).parseInBackground()
        : converter(responseData);
  }

  Future<T> putParsed<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) async {
    final response = await put(
      url,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    return useIsolate
        ? await IsolateParser<T>(responseData, converter).parseInBackground()
        : converter(responseData);
  }

  Future<T> patchParsed<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) async {
    final response = await patch(
      url,
      queryParameters: queryParameters,
      data: data,
      options: options,
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    return useIsolate
        ? await IsolateParser<T>(responseData, converter).parseInBackground()
        : converter(responseData);
  }

  Future<T?> deleteParsed<T>(
    String url, {
    ResponseConverter<T>? converter,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useIsolate = true,
  }) async {
    final response = await delete(
      url,
      queryParameters: queryParameters,
      options: options,
    );

    final responseData = response.data;

    if (converter == null || responseData == null || responseData == '') {
      return null;
    }

    if (responseData is! Map<String, dynamic>) {
      throw Exception('Invalid response format');
    }

    return useIsolate
        ? await IsolateParser<T>(responseData, converter).parseInBackground()
        : converter(responseData);
  }

  Future<Either<Failure, T>> getParsedSafe<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useIsolate = true,
  }) {
    return safeCall(
      () => getParsed<T>(
        url,
        converter: converter,
        queryParameters: queryParameters,
        options: options,
        useIsolate: useIsolate,
      ),
    );
  }

  Future<Either<Failure, T>> postParsedSafe<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) {
    return safeCall(
      () => postParsed<T>(
        url,
        converter: converter,
        queryParameters: queryParameters,
        data: data,
        options: options,
        useIsolate: useIsolate,
      ),
    );
  }

  Future<Either<Failure, T>> putParsedSafe<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) {
    return safeCall(
      () => putParsed<T>(
        url,
        converter: converter,
        queryParameters: queryParameters,
        data: data,
        options: options,
        useIsolate: useIsolate,
      ),
    );
  }

  Future<Either<Failure, T>> patchParsedSafe<T>(
    String url, {
    required ResponseConverter<T> converter,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    bool useIsolate = true,
  }) {
    return safeCall(
      () => patchParsed<T>(
        url,
        converter: converter,
        queryParameters: queryParameters,
        data: data,
        options: options,
        useIsolate: useIsolate,
      ),
    );
  }

  Future<Either<Failure, T?>> deleteParsedSafe<T>(
    String url, {
    ResponseConverter<T>? converter,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useIsolate = true,
  }) {
    return safeCall(
      () => deleteParsed<T>(
        url,
        converter: converter,
        queryParameters: queryParameters,
        options: options,
        useIsolate: useIsolate,
      ),
    );
  }
}
