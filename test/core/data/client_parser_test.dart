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
      when(mockClient.get(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1, 'name': 'test'},
        statusCode: 200,
      ));

      final result = await mockClient.getParsed(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result, {'id': 1, 'name': 'test'});
    });

    test('returns parsed response with isolate', () async {
      when(mockClient.get(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1, 'name': 'test'},
        statusCode: 200,
      ));

      final result = await mockClient.getParsed(
        '/test',
        converter: converter,
        useIsolate: true,
      );

      expect(result, {'id': 1, 'name': 'test'});
    });

    test('throws on invalid response format', () async {
      when(mockClient.get(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: 'not a map',
        statusCode: 200,
      ));

      expect(
        () => mockClient.getParsed('/test', converter: converter, useIsolate: false),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ClientParser.getParsedList', () {
    test('returns parsed list without isolate', () async {
      when(mockClient.get(
        '/list',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/list'),
        data: [
          {'id': 1},
          {'id': 2},
        ],
        statusCode: 200,
      ));

      final result = await mockClient.getParsedList(
        '/list',
        converter: converter,
        useIsolate: false,
      );

      expect(result, [
        {'id': 1},
        {'id': 2},
      ]);
    });

    test('returns parsed list with isolate', () async {
      when(mockClient.get(
        '/list',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/list'),
        data: [
          {'id': 1},
          {'id': 2},
        ],
        statusCode: 200,
      ));

      final result = await mockClient.getParsedList(
        '/list',
        converter: converter,
        useIsolate: true,
      );

      expect(result, [
        {'id': 1},
        {'id': 2},
      ]);
    });

    test('throws when response is not a list', () async {
      when(mockClient.get(
        '/list',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/list'),
        data: 'not a list',
        statusCode: 200,
      ));

      expect(
        () => mockClient.getParsedList('/list', converter: converter, useIsolate: false),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ClientParser.postParsed', () {
    test('returns parsed response', () async {
      when(mockClient.post(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1},
        statusCode: 201,
      ));

      final result = await mockClient.postParsed(
        '/test',
        converter: converter,
        data: {'key': 'value'},
        useIsolate: false,
      );

      expect(result, {'id': 1});
    });

    test('returns parsed response with isolate', () async {
      when(mockClient.post(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1},
        statusCode: 201,
      ));

      final result = await mockClient.postParsed(
        '/test',
        converter: converter,
        data: {'key': 'value'},
        useIsolate: true,
      );

      expect(result, {'id': 1});
    });

    test('throws on invalid response format', () async {
      when(mockClient.post(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: 'not a map',
        statusCode: 201,
      ));

      expect(
        () => mockClient.postParsed('/test', converter: converter, data: {}, useIsolate: false),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ClientParser.getParsedSafe', () {
    test('returns Right on success', () async {
      when(mockClient.get(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1},
        statusCode: 200,
      ));

      final result = await mockClient.getParsedSafe(
        '/test',
        converter: converter,
        useIsolate: false,
      );

      expect(result.isRight(), isTrue);
    });
  });

  group('ClientParser.getParsedListSafe', () {
    test('returns Right on success', () async {
      when(mockClient.get(
        '/list',
        queryParameters: anyNamed('queryParameters'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/list'),
        data: [{'id': 1}],
        statusCode: 200,
      ));

      final result = await mockClient.getParsedListSafe(
        '/list',
        converter: converter,
        useIsolate: false,
      );

      expect(result.isRight(), isTrue);
    });
  });

  group('ClientParser.postParsedSafe', () {
    test('returns Right on success', () async {
      when(mockClient.post(
        '/test',
        queryParameters: anyNamed('queryParameters'),
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: '/test'),
        data: {'id': 1},
        statusCode: 201,
      ));

      final result = await mockClient.postParsedSafe(
        '/test',
        converter: converter,
        data: {},
        useIsolate: false,
      );

      expect(result.isRight(), isTrue);
    });
  });
}
