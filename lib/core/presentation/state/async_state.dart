import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:use_me/core/core.dart';

part 'async_state.freezed.dart';

@freezed
sealed class AsyncState<T> with _$AsyncState<T> {
  const factory AsyncState.initial() = AsyncStateInitial<T>;
  const factory AsyncState.loading() = AsyncStateLoading<T>;
  const factory AsyncState.success(T data) = AsyncStateSuccess<T>;
  const factory AsyncState.failure(Failure failure) = AsyncStateFailure<T>;
}
