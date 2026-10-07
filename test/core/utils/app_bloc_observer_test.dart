import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:use_me/core/core.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

class _TestCubit extends Cubit<int> {
  _TestCubit() : super(0);

  void increment() => emit(state + 1);
}

class _TestBloc extends Bloc<int, int> {
  _TestBloc() : super(0) {
    on<int>((event, emit) => emit(event));
  }
}

void main() {
  group('AppBlocObserver', () {
    late AppBlocObserver observer;

    setUp(() {
      observer = AppBlocObserver();
    });

    test('onEvent logs on event', () {
      final bloc = _TestBloc();
      expect(() => observer.onEvent(bloc, 1), returnsNormally);
      bloc.close();
    });

    test('onTransition logs on transition', () {
      final bloc = _TestBloc();
      expect(
        () => observer.onTransition(
          bloc,
          Transition(currentState: 0, nextState: 1, event: 1),
        ),
        returnsNormally,
      );
      bloc.close();
    });

    test('onChange logs on change', () {
      final cubit = _TestCubit();
      expect(
        () => observer.onChange(cubit, Change(currentState: 0, nextState: 1)),
        returnsNormally,
      );
      cubit.close();
    });

    test('onError logs on error', () {
      final cubit = _TestCubit();
      expect(
        () => observer.onError(
          cubit,
          Exception('test error'),
          StackTrace.current,
        ),
        returnsNormally,
      );
      cubit.close();
    });

    test('onClose logs on close', () {
      final cubit = _TestCubit();
      expect(() => observer.onClose(cubit), returnsNormally);
      cubit.close();
    });
  });

  group('AppBlocObserver settings', () {
    test('logs the whole bloc lifecycle by default', () {
      final settings = AppBlocObserver().settings;

      expect(settings.printChanges, isTrue);
      expect(settings.printTransitions, isTrue);
      expect(settings.printCreations, isTrue);
      expect(settings.printClosings, isTrue);
      expect(settings.printEvents, isTrue);
    });

    test('takes settings from the caller when given', () {
      final observer = AppBlocObserver(
        settings: const TalkerBlocLoggerSettings(printChanges: true),
      );

      expect(observer.settings.printChanges, isTrue);
    });

    test('writes into the shared talker', () {
      talker.cleanHistory();
      final bloc = _TestBloc();

      AppBlocObserver().onEvent(bloc, 1);

      expect(talker.history, isNotEmpty);
      bloc.close();
    });
  });
}
