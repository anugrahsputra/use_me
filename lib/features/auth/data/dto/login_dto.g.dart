// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      id: (json['id'] as num?)?.toInt(),
      token: json['token'] as String,
      meta: MetaResponse.fromJson(json['_meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      '_meta': instance.meta,
    };

_MetaResponse _$MetaResponseFromJson(Map<String, dynamic> json) =>
    _MetaResponse(
      poweredBy: json['powered_by'] as String,
      docsUrl: json['docs_url'] as String,
      upgradeUrl: json['upgrade_url'] as String,
      exampleUrl: json['example_url'] as String,
      variant: json['variant'] as String,
      message: json['message'] as String,
      cta: CtaResponse.fromJson(json['cta'] as Map<String, dynamic>),
      context: json['context'] as String,
    );

Map<String, dynamic> _$MetaResponseToJson(_MetaResponse instance) =>
    <String, dynamic>{
      'powered_by': instance.poweredBy,
      'docs_url': instance.docsUrl,
      'upgrade_url': instance.upgradeUrl,
      'example_url': instance.exampleUrl,
      'variant': instance.variant,
      'message': instance.message,
      'cta': instance.cta,
      'context': instance.context,
    };

_CtaResponse _$CtaResponseFromJson(Map<String, dynamic> json) =>
    _CtaResponse(label: json['label'] as String, url: json['url'] as String);

Map<String, dynamic> _$CtaResponseToJson(_CtaResponse instance) =>
    <String, dynamic>{'label': instance.label, 'url': instance.url};
