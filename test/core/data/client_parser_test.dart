import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:use_me/core/core.dart';

import '../../helper/mocks.dart';

void main() {
  late MockClient mockClient;
  late ResponseConverter<Map<String, dynamic>> converter;

  setUp(() {
    mockClient = MockClient();
    converter = (json) => json;
  });

  group('ClientParser.getParsed', () {
    test('returns parsed response without isolate', () async {
      when(
        mockClient.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1, 'name': 'test'},
          statusCode: 200,
        ),
      );

      final result = await mockClient.getParsed(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result, {'id': 1, 'name': 'test'});
    });

    test('returns parsed response with isolate', () async {
      when(
        mockClient.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1, 'name': 'test'},
          statusCode: 200,
        ),
      );

      final result = await mockClient.getParsed(
        '/test',
        converter: converter,
        useIsolate: true,
      );

      expect(result, {'id': 1, 'name': 'test'});
    });

    test('throws on invalid response format', () async {
      when(
        mockClient.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: 'not a map',
          statusCode: 200,
        ),
      );

      expect(
        () => mockClient.getParsed(
          '/test',
          converter: converter,
          useIsolate: false,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ClientParser.postParsed', () {
    test('returns parsed response', () async {
      when(
        mockClient.post(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 201,
        ),
      );

      final result = await mockClient.postParsed(
        '/test',
        converter: converter,
        data: {'key': 'value'},
        useIsolate: false,
      );

      expect(result, {'id': 1});
    });

    test('returns parsed response with isolate', () async {
      when(
        mockClient.post(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 201,
        ),
      );

      final result = await mockClient.postParsed(
        '/test',
        converter: converter,
        data: {'key': 'value'},
        useIsolate: true,
      );

      expect(result, {'id': 1});
    });

    test('throws on invalid response format', () async {
      when(
        mockClient.post(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: 'not a map',
          statusCode: 201,
        ),
      );

      expect(
        () => mockClient.postParsed(
          '/test',
          converter: converter,
          data: {},
          useIsolate: false,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ClientParser.getParsedSafe', () {
    test('returns Right on success', () async {
      when(
        mockClient.get(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 200,
        ),
      );

      final result = await mockClient.getParsedSafe(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result.isRight(), isTrue);
    });
  });

  group('ClientParser.postParsedSafe', () {
    test('returns Right on success', () async {
      when(
        mockClient.post(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 201,
        ),
      );

      final result = await mockClient.postParsedSafe(
        '/test',
        converter: converter,
        data: {},
        useIsolate: false,
      );

      expect(result.isRight(), isTrue);
    });
  });

  group('ClientParser.putParsedSafe', () {
    test('returns Right on success', () async {
      when(
        mockClient.put(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 200,
        ),
      );

      final result = await mockClient.putParsedSafe(
        '/test',
        converter: converter,
        data: {},
        useIsolate: false,
      );

      expect(result.getOrElse(() => {}), {'id': 1});
    });

    test('returns Left when the interceptor rejects', () async {
      when(
        mockClient.put(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/test'),
          error: ConflictException(message: 'already exists'),
        ),
      );

      final result = await mockClient.putParsedSafe(
        '/test',
        converter: converter,
        data: {},
        useIsolate: false,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('ClientParser.patchParsedSafe', () {
    test('returns Right on success', () async {
      when(
        mockClient.patch(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: {'id': 1},
          statusCode: 200,
        ),
      );

      final result = await mockClient.patchParsedSafe(
        '/test',
        converter: converter,
        data: {},
        useIsolate: false,
      );

      expect(result.getOrElse(() => {}), {'id': 1});
    });
  });

  group('ClientParser.deleteParsedSafe', () {
    void stubDelete(dynamic data, int statusCode) {
      when(
        mockClient.delete(
          '/test',
          queryParameters: anyNamed('queryParameters'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/test'),
          data: data,
          statusCode: statusCode,
        ),
      );
    }

    test('returns Right(null) for a 204 with no body', () async {
      stubDelete(null, 204);

      final result = await mockClient.deleteParsedSafe(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result, Right<Failure, Map<String, dynamic>?>(null));
    });

    test('returns Right(null) for a zero-length body', () async {
      stubDelete('', 200);

      final result = await mockClient.deleteParsedSafe(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result, Right<Failure, Map<String, dynamic>?>(null));
    });

    test('returns Right(null) when no converter is given', () async {
      stubDelete({'id': 1}, 200);

      final result = await mockClient.deleteParsedSafe('/test');

      expect(result, Right<Failure, Never?>(null));
    });

    test('parses the body when a converter is given', () async {
      stubDelete({'id': 1}, 200);

      final result = await mockClient.deleteParsedSafe(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result.getOrElse(() => null), {'id': 1});
    });

    test('throws on a non-map body', () async {
      stubDelete('unexpected', 200);

      expect(
        () => mockClient.deleteParsedSafe(
          '/test',
          converter: converter,
          useIsolate: false,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
