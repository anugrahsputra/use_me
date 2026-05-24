import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_entity.freezed.dart';

@freezed
abstract class LoginEntity with _$LoginEntity {
  const factory LoginEntity({
    required int id,
    required String token,
    required MetaEntity meta,
  }) = _LoginEntity;
}

@freezed
abstract class MetaEntity with _$MetaEntity {
  const factory MetaEntity({
    required String poweredBy,
    required String docsUrl,
    required String upgradeUrl,
    required String exampleUrl,
    required String variant,
    required String message,
    required CtaEntity cta,
    required String context,
  }) = _MetaEntity;
}

@freezed
abstract class CtaEntity with _$CtaEntity {
  const factory CtaEntity({required String label, required String url}) =
      _CtaEntity;
}
