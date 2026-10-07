import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequest({
  required final String email,
  required final String password,
}) {
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse({
  @JsonKey(name: 'id') final int? id,
  @JsonKey(name: 'token') required final String token,
  @JsonKey(name: '_meta') required final MetaResponse meta,
}) {
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MetaResponse({
  required final String poweredBy,
  required final String docsUrl,
  required final String upgradeUrl,
  required final String exampleUrl,
  required final String variant,
  required final String message,
  required final CtaResponse cta,
  required final String context,
}) {
  factory MetaResponse.fromJson(Map<String, dynamic> json) =>
      _$MetaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MetaResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class CtaResponse({required final String label, required final String url}) {
  factory CtaResponse.fromJson(Map<String, dynamic> json) =>
      _$CtaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CtaResponseToJson(this);
}
