import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc/bloc.dart';
import 'package:use_me/core/core.dart';

void main() {
  group('debounce', () {
    test('returns an EventTransformer', () {
      final transformer = debounce<int>(const Duration(milliseconds: 300));
      expect(transformer, isA<EventTransformer<int>>());
    });

    test('transformer debounces events', () async {
      final transformer = debounce<int>(const Duration(milliseconds: 50));
      final controller = StreamController<int>();
      final events = controller.stream;
      final mapper = (int event) => Stream<int>.value(event * 2);

      final result = transformer(events, mapper).toList();

      controller.add(1);
      await Future.delayed(const Duration(milliseconds: 100));
      await controller.close();

      expect(await result, [2]);
    });
  });
}

