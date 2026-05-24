import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';

import '../../helper/mocks.dart';

void main() {
  late MockDio mockDio;
  late ClientImpl client;

  setUp(() {
    mockDio = MockDio();
    client = ClientImpl(dio: mockDio);
  });

  group('ClientImpl.get', () {
    test('delegates to dio.get', () async {
      when(mockDio.get<dynamic>(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
      ));

      await client.get('/test');

      verify(mockDio.get(
        '/test',
        queryParameters: null,
        options: null,
        cancelToken: null,
        onReceiveProgress: null,
      )).called(1);
    });
  });

  group('ClientImpl.post', () {
    test('delegates to dio.post with data', () async {
      when(mockDio.post<dynamic>(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
        onSendProgress: anyNamed('onSendProgress'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 201,
      ));

      await client.post('/test', data: {'key': 'value'});

      verify(mockDio.post(
        '/test',
        queryParameters: null,
        data: {'key': 'value'},
        options: null,
        cancelToken: null,
        onReceiveProgress: null,
        onSendProgress: null,
      )).called(1);
    });

    test('converts Map data to FormData for multipart', () async {
      when(mockDio.post<dynamic>(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
        onSendProgress: anyNamed('onSendProgress'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 201,
      ));

      await client.post(
        '/upload',
        data: {'file': 'data'},
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      final captured = verify(mockDio.post(
        any,
        data: captureAnyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
        onSendProgress: anyNamed('onSendProgress'),
      )).captured.first;
      expect(captured, isA<FormData>());
    });
  });

  group('ClientImpl.put', () {
    test('delegates to dio.put', () async {
      when(mockDio.put<dynamic>(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
      ));

      await client.put('/test', data: {'key': 'value'});

      verify(mockDio.put(
        '/test',
        queryParameters: null,
        data: {'key': 'value'},
        options: null,
      )).called(1);
    });

    test('converts Map data to FormData for multipart', () async {
      when(mockDio.put<dynamic>(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
      ));

      await client.put(
        '/upload',
        data: {'file': 'data'},
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      final captured = verify(mockDio.put(
        any,
        data: captureAnyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).captured.first;
      expect(captured, isA<FormData>());
    });
  });

  group('ClientImpl.delete', () {
    test('delegates to dio.delete', () async {
      when(mockDio.delete<dynamic>(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 204,
      ));

      await client.delete('/test');

      verify(mockDio.delete(
        '/test',
        queryParameters: null,
        options: null,
        cancelToken: null,
      )).called(1);
    });
  });
}
