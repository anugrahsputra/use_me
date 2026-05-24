// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginRequest implements DiagnosticableTreeMixin {

 String get email; String get password;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginRequest'))
    ..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('password', password));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginRequest(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.email,_that.password);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.email,_that.password);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest with DiagnosticableTreeMixin implements LoginRequest {
  const _LoginRequest({required this.email, required this.password});
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginRequest'))
    ..add(DiagnosticsProperty('email', email))..add(DiagnosticsProperty('password', password));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginRequest(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_LoginRequest(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$LoginResponse implements DiagnosticableTreeMixin {

@JsonKey(name: 'id') int? get id;@JsonKey(name: 'token') String get token;@JsonKey(name: '_meta') MetaResponse get meta;
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseCopyWith<LoginResponse> get copyWith => _$LoginResponseCopyWithImpl<LoginResponse>(this as LoginResponse, _$identity);

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginResponse'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('token', token))..add(DiagnosticsProperty('meta', meta));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,meta);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginResponse(id: $id, token: $token, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $LoginResponseCopyWith<$Res>  {
  factory $LoginResponseCopyWith(LoginResponse value, $Res Function(LoginResponse) _then) = _$LoginResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'token') String token,@JsonKey(name: '_meta') MetaResponse meta
});


$MetaResponseCopyWith<$Res> get meta;

}
/// @nodoc
class _$LoginResponseCopyWithImpl<$Res>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._self, this._then);

  final LoginResponse _self;
  final $Res Function(LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? token = null,Object? meta = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaResponse,
  ));
}
/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res> get meta {
  
  return $MetaResponseCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginResponse].
extension LoginResponsePatterns on LoginResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponse value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'token')  String token, @JsonKey(name: '_meta')  MetaResponse meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.id,_that.token,_that.meta);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'token')  String token, @JsonKey(name: '_meta')  MetaResponse meta)  $default,) {final _that = this;
switch (_that) {
case _LoginResponse():
return $default(_that.id,_that.token,_that.meta);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  int? id, @JsonKey(name: 'token')  String token, @JsonKey(name: '_meta')  MetaResponse meta)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponse() when $default != null:
return $default(_that.id,_that.token,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponse with DiagnosticableTreeMixin implements LoginResponse {
  const _LoginResponse({@JsonKey(name: 'id') this.id, @JsonKey(name: 'token') required this.token, @JsonKey(name: '_meta') required this.meta});
  factory _LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

@override@JsonKey(name: 'id') final  int? id;
@override@JsonKey(name: 'token') final  String token;
@override@JsonKey(name: '_meta') final  MetaResponse meta;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseCopyWith<_LoginResponse> get copyWith => __$LoginResponseCopyWithImpl<_LoginResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'LoginResponse'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('token', token))..add(DiagnosticsProperty('meta', meta));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,meta);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'LoginResponse(id: $id, token: $token, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseCopyWith<$Res> implements $LoginResponseCopyWith<$Res> {
  factory _$LoginResponseCopyWith(_LoginResponse value, $Res Function(_LoginResponse) _then) = __$LoginResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') int? id,@JsonKey(name: 'token') String token,@JsonKey(name: '_meta') MetaResponse meta
});


@override $MetaResponseCopyWith<$Res> get meta;

}
/// @nodoc
class __$LoginResponseCopyWithImpl<$Res>
    implements _$LoginResponseCopyWith<$Res> {
  __$LoginResponseCopyWithImpl(this._self, this._then);

  final _LoginResponse _self;
  final $Res Function(_LoginResponse) _then;

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? token = null,Object? meta = null,}) {
  return _then(_LoginResponse(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaResponse,
  ));
}

/// Create a copy of LoginResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<$Res> get meta {
  
  return $MetaResponseCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$MetaResponse implements DiagnosticableTreeMixin {

@JsonKey(name: 'powered_by') String get poweredBy;@JsonKey(name: 'docs_url') String get docsUrl;@JsonKey(name: 'upgrade_url') String get upgradeUrl;@JsonKey(name: 'example_url') String get exampleUrl;@JsonKey(name: 'variant') String get variant;@JsonKey(name: 'message') String get message;@JsonKey(name: 'cta') CtaResponse get cta;@JsonKey(name: 'context') String get context;
/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaResponseCopyWith<MetaResponse> get copyWith => _$MetaResponseCopyWithImpl<MetaResponse>(this as MetaResponse, _$identity);

  /// Serializes this MetaResponse to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MetaResponse'))
    ..add(DiagnosticsProperty('poweredBy', poweredBy))..add(DiagnosticsProperty('docsUrl', docsUrl))..add(DiagnosticsProperty('upgradeUrl', upgradeUrl))..add(DiagnosticsProperty('exampleUrl', exampleUrl))..add(DiagnosticsProperty('variant', variant))..add(DiagnosticsProperty('message', message))..add(DiagnosticsProperty('cta', cta))..add(DiagnosticsProperty('context', context));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetaResponse&&(identical(other.poweredBy, poweredBy) || other.poweredBy == poweredBy)&&(identical(other.docsUrl, docsUrl) || other.docsUrl == docsUrl)&&(identical(other.upgradeUrl, upgradeUrl) || other.upgradeUrl == upgradeUrl)&&(identical(other.exampleUrl, exampleUrl) || other.exampleUrl == exampleUrl)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.message, message) || other.message == message)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.context, context) || other.context == context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poweredBy,docsUrl,upgradeUrl,exampleUrl,variant,message,cta,context);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MetaResponse(poweredBy: $poweredBy, docsUrl: $docsUrl, upgradeUrl: $upgradeUrl, exampleUrl: $exampleUrl, variant: $variant, message: $message, cta: $cta, context: $context)';
}


}

/// @nodoc
abstract mixin class $MetaResponseCopyWith<$Res>  {
  factory $MetaResponseCopyWith(MetaResponse value, $Res Function(MetaResponse) _then) = _$MetaResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'powered_by') String poweredBy,@JsonKey(name: 'docs_url') String docsUrl,@JsonKey(name: 'upgrade_url') String upgradeUrl,@JsonKey(name: 'example_url') String exampleUrl,@JsonKey(name: 'variant') String variant,@JsonKey(name: 'message') String message,@JsonKey(name: 'cta') CtaResponse cta,@JsonKey(name: 'context') String context
});


$CtaResponseCopyWith<$Res> get cta;

}
/// @nodoc
class _$MetaResponseCopyWithImpl<$Res>
    implements $MetaResponseCopyWith<$Res> {
  _$MetaResponseCopyWithImpl(this._self, this._then);

  final MetaResponse _self;
  final $Res Function(MetaResponse) _then;

/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? poweredBy = null,Object? docsUrl = null,Object? upgradeUrl = null,Object? exampleUrl = null,Object? variant = null,Object? message = null,Object? cta = null,Object? context = null,}) {
  return _then(_self.copyWith(
poweredBy: null == poweredBy ? _self.poweredBy : poweredBy // ignore: cast_nullable_to_non_nullable
as String,docsUrl: null == docsUrl ? _self.docsUrl : docsUrl // ignore: cast_nullable_to_non_nullable
as String,upgradeUrl: null == upgradeUrl ? _self.upgradeUrl : upgradeUrl // ignore: cast_nullable_to_non_nullable
as String,exampleUrl: null == exampleUrl ? _self.exampleUrl : exampleUrl // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cta: null == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as CtaResponse,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CtaResponseCopyWith<$Res> get cta {
  
  return $CtaResponseCopyWith<$Res>(_self.cta, (value) {
    return _then(_self.copyWith(cta: value));
  });
}
}


/// Adds pattern-matching-related methods to [MetaResponse].
extension MetaResponsePatterns on MetaResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetaResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetaResponse value)  $default,){
final _that = this;
switch (_that) {
case _MetaResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MetaResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'powered_by')  String poweredBy, @JsonKey(name: 'docs_url')  String docsUrl, @JsonKey(name: 'upgrade_url')  String upgradeUrl, @JsonKey(name: 'example_url')  String exampleUrl, @JsonKey(name: 'variant')  String variant, @JsonKey(name: 'message')  String message, @JsonKey(name: 'cta')  CtaResponse cta, @JsonKey(name: 'context')  String context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetaResponse() when $default != null:
return $default(_that.poweredBy,_that.docsUrl,_that.upgradeUrl,_that.exampleUrl,_that.variant,_that.message,_that.cta,_that.context);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'powered_by')  String poweredBy, @JsonKey(name: 'docs_url')  String docsUrl, @JsonKey(name: 'upgrade_url')  String upgradeUrl, @JsonKey(name: 'example_url')  String exampleUrl, @JsonKey(name: 'variant')  String variant, @JsonKey(name: 'message')  String message, @JsonKey(name: 'cta')  CtaResponse cta, @JsonKey(name: 'context')  String context)  $default,) {final _that = this;
switch (_that) {
case _MetaResponse():
return $default(_that.poweredBy,_that.docsUrl,_that.upgradeUrl,_that.exampleUrl,_that.variant,_that.message,_that.cta,_that.context);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'powered_by')  String poweredBy, @JsonKey(name: 'docs_url')  String docsUrl, @JsonKey(name: 'upgrade_url')  String upgradeUrl, @JsonKey(name: 'example_url')  String exampleUrl, @JsonKey(name: 'variant')  String variant, @JsonKey(name: 'message')  String message, @JsonKey(name: 'cta')  CtaResponse cta, @JsonKey(name: 'context')  String context)?  $default,) {final _that = this;
switch (_that) {
case _MetaResponse() when $default != null:
return $default(_that.poweredBy,_that.docsUrl,_that.upgradeUrl,_that.exampleUrl,_that.variant,_that.message,_that.cta,_that.context);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetaResponse with DiagnosticableTreeMixin implements MetaResponse {
  const _MetaResponse({@JsonKey(name: 'powered_by') required this.poweredBy, @JsonKey(name: 'docs_url') required this.docsUrl, @JsonKey(name: 'upgrade_url') required this.upgradeUrl, @JsonKey(name: 'example_url') required this.exampleUrl, @JsonKey(name: 'variant') required this.variant, @JsonKey(name: 'message') required this.message, @JsonKey(name: 'cta') required this.cta, @JsonKey(name: 'context') required this.context});
  factory _MetaResponse.fromJson(Map<String, dynamic> json) => _$MetaResponseFromJson(json);

@override@JsonKey(name: 'powered_by') final  String poweredBy;
@override@JsonKey(name: 'docs_url') final  String docsUrl;
@override@JsonKey(name: 'upgrade_url') final  String upgradeUrl;
@override@JsonKey(name: 'example_url') final  String exampleUrl;
@override@JsonKey(name: 'variant') final  String variant;
@override@JsonKey(name: 'message') final  String message;
@override@JsonKey(name: 'cta') final  CtaResponse cta;
@override@JsonKey(name: 'context') final  String context;

/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetaResponseCopyWith<_MetaResponse> get copyWith => __$MetaResponseCopyWithImpl<_MetaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetaResponseToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'MetaResponse'))
    ..add(DiagnosticsProperty('poweredBy', poweredBy))..add(DiagnosticsProperty('docsUrl', docsUrl))..add(DiagnosticsProperty('upgradeUrl', upgradeUrl))..add(DiagnosticsProperty('exampleUrl', exampleUrl))..add(DiagnosticsProperty('variant', variant))..add(DiagnosticsProperty('message', message))..add(DiagnosticsProperty('cta', cta))..add(DiagnosticsProperty('context', context));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetaResponse&&(identical(other.poweredBy, poweredBy) || other.poweredBy == poweredBy)&&(identical(other.docsUrl, docsUrl) || other.docsUrl == docsUrl)&&(identical(other.upgradeUrl, upgradeUrl) || other.upgradeUrl == upgradeUrl)&&(identical(other.exampleUrl, exampleUrl) || other.exampleUrl == exampleUrl)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.message, message) || other.message == message)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.context, context) || other.context == context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poweredBy,docsUrl,upgradeUrl,exampleUrl,variant,message,cta,context);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'MetaResponse(poweredBy: $poweredBy, docsUrl: $docsUrl, upgradeUrl: $upgradeUrl, exampleUrl: $exampleUrl, variant: $variant, message: $message, cta: $cta, context: $context)';
}


}

/// @nodoc
abstract mixin class _$MetaResponseCopyWith<$Res> implements $MetaResponseCopyWith<$Res> {
  factory _$MetaResponseCopyWith(_MetaResponse value, $Res Function(_MetaResponse) _then) = __$MetaResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'powered_by') String poweredBy,@JsonKey(name: 'docs_url') String docsUrl,@JsonKey(name: 'upgrade_url') String upgradeUrl,@JsonKey(name: 'example_url') String exampleUrl,@JsonKey(name: 'variant') String variant,@JsonKey(name: 'message') String message,@JsonKey(name: 'cta') CtaResponse cta,@JsonKey(name: 'context') String context
});


@override $CtaResponseCopyWith<$Res> get cta;

}
/// @nodoc
class __$MetaResponseCopyWithImpl<$Res>
    implements _$MetaResponseCopyWith<$Res> {
  __$MetaResponseCopyWithImpl(this._self, this._then);

  final _MetaResponse _self;
  final $Res Function(_MetaResponse) _then;

/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? poweredBy = null,Object? docsUrl = null,Object? upgradeUrl = null,Object? exampleUrl = null,Object? variant = null,Object? message = null,Object? cta = null,Object? context = null,}) {
  return _then(_MetaResponse(
poweredBy: null == poweredBy ? _self.poweredBy : poweredBy // ignore: cast_nullable_to_non_nullable
as String,docsUrl: null == docsUrl ? _self.docsUrl : docsUrl // ignore: cast_nullable_to_non_nullable
as String,upgradeUrl: null == upgradeUrl ? _self.upgradeUrl : upgradeUrl // ignore: cast_nullable_to_non_nullable
as String,exampleUrl: null == exampleUrl ? _self.exampleUrl : exampleUrl // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cta: null == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as CtaResponse,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MetaResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CtaResponseCopyWith<$Res> get cta {
  
  return $CtaResponseCopyWith<$Res>(_self.cta, (value) {
    return _then(_self.copyWith(cta: value));
  });
}
}


/// @nodoc
mixin _$CtaResponse implements DiagnosticableTreeMixin {

 String get label; String get url;
/// Create a copy of CtaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CtaResponseCopyWith<CtaResponse> get copyWith => _$CtaResponseCopyWithImpl<CtaResponse>(this as CtaResponse, _$identity);

  /// Serializes this CtaResponse to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CtaResponse'))
    ..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('url', url));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CtaResponse&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CtaResponse(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $CtaResponseCopyWith<$Res>  {
  factory $CtaResponseCopyWith(CtaResponse value, $Res Function(CtaResponse) _then) = _$CtaResponseCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$CtaResponseCopyWithImpl<$Res>
    implements $CtaResponseCopyWith<$Res> {
  _$CtaResponseCopyWithImpl(this._self, this._then);

  final CtaResponse _self;
  final $Res Function(CtaResponse) _then;

/// Create a copy of CtaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CtaResponse].
extension CtaResponsePatterns on CtaResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CtaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CtaResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CtaResponse value)  $default,){
final _that = this;
switch (_that) {
case _CtaResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CtaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CtaResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CtaResponse() when $default != null:
return $default(_that.label,_that.url);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String url)  $default,) {final _that = this;
switch (_that) {
case _CtaResponse():
return $default(_that.label,_that.url);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String url)?  $default,) {final _that = this;
switch (_that) {
case _CtaResponse() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CtaResponse with DiagnosticableTreeMixin implements CtaResponse {
  const _CtaResponse({required this.label, required this.url});
  factory _CtaResponse.fromJson(Map<String, dynamic> json) => _$CtaResponseFromJson(json);

@override final  String label;
@override final  String url;

/// Create a copy of CtaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CtaResponseCopyWith<_CtaResponse> get copyWith => __$CtaResponseCopyWithImpl<_CtaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CtaResponseToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CtaResponse'))
    ..add(DiagnosticsProperty('label', label))..add(DiagnosticsProperty('url', url));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CtaResponse&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CtaResponse(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$CtaResponseCopyWith<$Res> implements $CtaResponseCopyWith<$Res> {
  factory _$CtaResponseCopyWith(_CtaResponse value, $Res Function(_CtaResponse) _then) = __$CtaResponseCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$CtaResponseCopyWithImpl<$Res>
    implements _$CtaResponseCopyWith<$Res> {
  __$CtaResponseCopyWithImpl(this._self, this._then);

  final _CtaResponse _self;
  final $Res Function(_CtaResponse) _then;

/// Create a copy of CtaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_CtaResponse(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
