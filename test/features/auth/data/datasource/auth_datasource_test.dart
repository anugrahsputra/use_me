import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/features/auth/auth.dart';
import 'package:use_me/features/auth/data/data.dart';

import '../../../../helper/mocks.dart';

void main() {
  late MockClient mockClient;
  late AuthDatasourceImpl datasource;

  setUp(() {
    mockClient = MockClient();
    datasource = AuthDatasourceImpl(client: mockClient);
  });

  group('login', () {
    test('returns LoginResponse on success', () async {
      when(
        mockClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
          onSendProgress: anyNamed('onSendProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/login'),
          data: {
            'id': 1,
            'token': 'abc',
            '_meta': {
              'powered_by': 'Flutter',
              'docs_url': 'https://docs.com',
              'upgrade_url': 'https://upgrade.com',
              'example_url': 'https://example.com',
              'variant': 'v1',
              'message': 'Welcome',
              'cta': {'label': 'Go', 'url': 'https://example.com'},
              'context': 'login',
            },
          },
          statusCode: 200,
        ),
      );

      final req = LoginRequest(email: 'a@b.com', password: 'secret');
      final result = await datasource.login(req);

      expect(result.isRight(), isTrue);
      final loginResponse = result.getOrElse(() => throw 'unexpected');
      expect(loginResponse.token, 'abc');
    });

    test('returns Failure on network error', () async {
      when(
        mockClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
          onSendProgress: anyNamed('onSendProgress'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.connectionError,
        ),
      );

      final req = LoginRequest(email: 'a@b.com', password: 'secret');
      final result = await datasource.login(req);

      expect(result.isLeft(), isTrue);
    });
  });

  group('logout', () {
    test('returns Unit on success', () async {
      when(
        mockClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
          onSendProgress: anyNamed('onSendProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/logout'),
          data: <String, dynamic>{},
          statusCode: 200,
        ),
      );

      final result = await datasource.logout();
      expect(result.isRight(), isTrue);
    });

    test('returns Failure on network error', () async {
      when(
        mockClient.post(
          any,
          data: anyNamed('data'),
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
          cancelToken: anyNamed('cancelToken'),
          onReceiveProgress: anyNamed('onReceiveProgress'),
          onSendProgress: anyNamed('onSendProgress'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/logout'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await datasource.logout();
      expect(result.isLeft(), isTrue);
    });
  });
}
