import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';

import '../../helper/mocks.dart';

void main() {
  late MockDio mockDio;
  late MockInternetConnectionChecker mockChecker;
  late ClientRequestRetrier retrier;

  setUp(() {
    mockDio = MockDio();
    mockChecker = MockInternetConnectionChecker();
    retrier = ClientRequestRetrier(
      dio: mockDio,
      internetConnectionChecker: mockChecker,
    );
  });

  group('ClientRequestRetrier', () {
    test('retries request after connection is restored', () async {
      final statusController = StreamController<InternetConnectionStatus>();
      when(mockChecker.onStatusChange).thenAnswer((_) => statusController.stream);

      when(mockDio.request<dynamic>(
        any,
        data: anyNamed('data'),
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: anyNamed('cancelToken'),
        onReceiveProgress: anyNamed('onReceiveProgress'),
        onSendProgress: anyNamed('onSendProgress'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: 'retried',
      ));

      final options = RequestOptions(path: '/test');
      final future = retrier.retryRequest<dynamic>(options);

      statusController.add(InternetConnectionStatus.connected);
      await statusController.close();

      final result = await future;
      expect(result.statusCode, 200);
      expect(result.data, 'retried');
      verify(mockDio.request(
        '/test',
        data: null,
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
        cancelToken: null,
        onReceiveProgress: null,
        onSendProgress: null,
      )).called(1);
    });
  });
}
