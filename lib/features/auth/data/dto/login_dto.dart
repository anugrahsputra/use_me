import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: '_meta') required MetaResponse meta,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class MetaResponse with _$MetaResponse {
  const factory MetaResponse({
    @JsonKey(name: 'powered_by') required String poweredBy,
    @JsonKey(name: 'docs_url') required String docsUrl,
    @JsonKey(name: 'upgrade_url') required String upgradeUrl,
    @JsonKey(name: 'example_url') required String exampleUrl,
    @JsonKey(name: 'variant') required String variant,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'cta') required CtaResponse cta,
    @JsonKey(name: 'context') required String context,
  }) = _MetaResponse;

  factory MetaResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaResponseFromJson(json);
}

@freezed
abstract class CtaResponse with _$CtaResponse {
  const factory CtaResponse({required String label, required String url}) =
      _CtaResponse;

  factory CtaResponse.fromJson(Map<String, dynamic> json) =>
      _$CtaResponseFromJson(json);
}
