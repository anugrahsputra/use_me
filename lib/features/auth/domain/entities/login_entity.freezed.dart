// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEntity {

 int get id; String get token; MetaEntity get meta;
/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginEntityCopyWith<LoginEntity> get copyWith => _$LoginEntityCopyWithImpl<LoginEntity>(this as LoginEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,id,token,meta);

@override
String toString() {
  return 'LoginEntity(id: $id, token: $token, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $LoginEntityCopyWith<$Res>  {
  factory $LoginEntityCopyWith(LoginEntity value, $Res Function(LoginEntity) _then) = _$LoginEntityCopyWithImpl;
@useResult
$Res call({
 int id, String token, MetaEntity meta
});


$MetaEntityCopyWith<$Res> get meta;

}
/// @nodoc
class _$LoginEntityCopyWithImpl<$Res>
    implements $LoginEntityCopyWith<$Res> {
  _$LoginEntityCopyWithImpl(this._self, this._then);

  final LoginEntity _self;
  final $Res Function(LoginEntity) _then;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? token = null,Object? meta = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaEntity,
  ));
}
/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaEntityCopyWith<$Res> get meta {
  
  return $MetaEntityCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginEntity].
extension LoginEntityPatterns on LoginEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginEntity value)  $default,){
final _that = this;
switch (_that) {
case _LoginEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String token,  MetaEntity meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String token,  MetaEntity meta)  $default,) {final _that = this;
switch (_that) {
case _LoginEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String token,  MetaEntity meta)?  $default,) {final _that = this;
switch (_that) {
case _LoginEntity() when $default != null:
return $default(_that.id,_that.token,_that.meta);case _:
  return null;

}
}

}

/// @nodoc


class _LoginEntity implements LoginEntity {
  const _LoginEntity({required this.id, required this.token, required this.meta});
  

@override final  int id;
@override final  String token;
@override final  MetaEntity meta;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginEntityCopyWith<_LoginEntity> get copyWith => __$LoginEntityCopyWithImpl<_LoginEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.meta, meta) || other.meta == meta));
}


@override
int get hashCode => Object.hash(runtimeType,id,token,meta);

@override
String toString() {
  return 'LoginEntity(id: $id, token: $token, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$LoginEntityCopyWith<$Res> implements $LoginEntityCopyWith<$Res> {
  factory _$LoginEntityCopyWith(_LoginEntity value, $Res Function(_LoginEntity) _then) = __$LoginEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String token, MetaEntity meta
});


@override $MetaEntityCopyWith<$Res> get meta;

}
/// @nodoc
class __$LoginEntityCopyWithImpl<$Res>
    implements _$LoginEntityCopyWith<$Res> {
  __$LoginEntityCopyWithImpl(this._self, this._then);

  final _LoginEntity _self;
  final $Res Function(_LoginEntity) _then;

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? token = null,Object? meta = null,}) {
  return _then(_LoginEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as MetaEntity,
  ));
}

/// Create a copy of LoginEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaEntityCopyWith<$Res> get meta {
  
  return $MetaEntityCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

/// @nodoc
mixin _$MetaEntity {

 String get poweredBy; String get docsUrl; String get upgradeUrl; String get exampleUrl; String get variant; String get message; CtaEntity get cta; String get context;
/// Create a copy of MetaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetaEntityCopyWith<MetaEntity> get copyWith => _$MetaEntityCopyWithImpl<MetaEntity>(this as MetaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetaEntity&&(identical(other.poweredBy, poweredBy) || other.poweredBy == poweredBy)&&(identical(other.docsUrl, docsUrl) || other.docsUrl == docsUrl)&&(identical(other.upgradeUrl, upgradeUrl) || other.upgradeUrl == upgradeUrl)&&(identical(other.exampleUrl, exampleUrl) || other.exampleUrl == exampleUrl)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.message, message) || other.message == message)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.context, context) || other.context == context));
}


@override
int get hashCode => Object.hash(runtimeType,poweredBy,docsUrl,upgradeUrl,exampleUrl,variant,message,cta,context);

@override
String toString() {
  return 'MetaEntity(poweredBy: $poweredBy, docsUrl: $docsUrl, upgradeUrl: $upgradeUrl, exampleUrl: $exampleUrl, variant: $variant, message: $message, cta: $cta, context: $context)';
}


}

/// @nodoc
abstract mixin class $MetaEntityCopyWith<$Res>  {
  factory $MetaEntityCopyWith(MetaEntity value, $Res Function(MetaEntity) _then) = _$MetaEntityCopyWithImpl;
@useResult
$Res call({
 String poweredBy, String docsUrl, String upgradeUrl, String exampleUrl, String variant, String message, CtaEntity cta, String context
});


$CtaEntityCopyWith<$Res> get cta;

}
/// @nodoc
class _$MetaEntityCopyWithImpl<$Res>
    implements $MetaEntityCopyWith<$Res> {
  _$MetaEntityCopyWithImpl(this._self, this._then);

  final MetaEntity _self;
  final $Res Function(MetaEntity) _then;

/// Create a copy of MetaEntity
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
as CtaEntity,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MetaEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CtaEntityCopyWith<$Res> get cta {
  
  return $CtaEntityCopyWith<$Res>(_self.cta, (value) {
    return _then(_self.copyWith(cta: value));
  });
}
}


/// Adds pattern-matching-related methods to [MetaEntity].
extension MetaEntityPatterns on MetaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetaEntity value)  $default,){
final _that = this;
switch (_that) {
case _MetaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MetaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String poweredBy,  String docsUrl,  String upgradeUrl,  String exampleUrl,  String variant,  String message,  CtaEntity cta,  String context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetaEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String poweredBy,  String docsUrl,  String upgradeUrl,  String exampleUrl,  String variant,  String message,  CtaEntity cta,  String context)  $default,) {final _that = this;
switch (_that) {
case _MetaEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String poweredBy,  String docsUrl,  String upgradeUrl,  String exampleUrl,  String variant,  String message,  CtaEntity cta,  String context)?  $default,) {final _that = this;
switch (_that) {
case _MetaEntity() when $default != null:
return $default(_that.poweredBy,_that.docsUrl,_that.upgradeUrl,_that.exampleUrl,_that.variant,_that.message,_that.cta,_that.context);case _:
  return null;

}
}

}

/// @nodoc


class _MetaEntity implements MetaEntity {
  const _MetaEntity({required this.poweredBy, required this.docsUrl, required this.upgradeUrl, required this.exampleUrl, required this.variant, required this.message, required this.cta, required this.context});
  

@override final  String poweredBy;
@override final  String docsUrl;
@override final  String upgradeUrl;
@override final  String exampleUrl;
@override final  String variant;
@override final  String message;
@override final  CtaEntity cta;
@override final  String context;

/// Create a copy of MetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetaEntityCopyWith<_MetaEntity> get copyWith => __$MetaEntityCopyWithImpl<_MetaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetaEntity&&(identical(other.poweredBy, poweredBy) || other.poweredBy == poweredBy)&&(identical(other.docsUrl, docsUrl) || other.docsUrl == docsUrl)&&(identical(other.upgradeUrl, upgradeUrl) || other.upgradeUrl == upgradeUrl)&&(identical(other.exampleUrl, exampleUrl) || other.exampleUrl == exampleUrl)&&(identical(other.variant, variant) || other.variant == variant)&&(identical(other.message, message) || other.message == message)&&(identical(other.cta, cta) || other.cta == cta)&&(identical(other.context, context) || other.context == context));
}


@override
int get hashCode => Object.hash(runtimeType,poweredBy,docsUrl,upgradeUrl,exampleUrl,variant,message,cta,context);

@override
String toString() {
  return 'MetaEntity(poweredBy: $poweredBy, docsUrl: $docsUrl, upgradeUrl: $upgradeUrl, exampleUrl: $exampleUrl, variant: $variant, message: $message, cta: $cta, context: $context)';
}


}

/// @nodoc
abstract mixin class _$MetaEntityCopyWith<$Res> implements $MetaEntityCopyWith<$Res> {
  factory _$MetaEntityCopyWith(_MetaEntity value, $Res Function(_MetaEntity) _then) = __$MetaEntityCopyWithImpl;
@override @useResult
$Res call({
 String poweredBy, String docsUrl, String upgradeUrl, String exampleUrl, String variant, String message, CtaEntity cta, String context
});


@override $CtaEntityCopyWith<$Res> get cta;

}
/// @nodoc
class __$MetaEntityCopyWithImpl<$Res>
    implements _$MetaEntityCopyWith<$Res> {
  __$MetaEntityCopyWithImpl(this._self, this._then);

  final _MetaEntity _self;
  final $Res Function(_MetaEntity) _then;

/// Create a copy of MetaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? poweredBy = null,Object? docsUrl = null,Object? upgradeUrl = null,Object? exampleUrl = null,Object? variant = null,Object? message = null,Object? cta = null,Object? context = null,}) {
  return _then(_MetaEntity(
poweredBy: null == poweredBy ? _self.poweredBy : poweredBy // ignore: cast_nullable_to_non_nullable
as String,docsUrl: null == docsUrl ? _self.docsUrl : docsUrl // ignore: cast_nullable_to_non_nullable
as String,upgradeUrl: null == upgradeUrl ? _self.upgradeUrl : upgradeUrl // ignore: cast_nullable_to_non_nullable
as String,exampleUrl: null == exampleUrl ? _self.exampleUrl : exampleUrl // ignore: cast_nullable_to_non_nullable
as String,variant: null == variant ? _self.variant : variant // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,cta: null == cta ? _self.cta : cta // ignore: cast_nullable_to_non_nullable
as CtaEntity,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MetaEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CtaEntityCopyWith<$Res> get cta {
  
  return $CtaEntityCopyWith<$Res>(_self.cta, (value) {
    return _then(_self.copyWith(cta: value));
  });
}
}

/// @nodoc
mixin _$CtaEntity {

 String get label; String get url;
/// Create a copy of CtaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CtaEntityCopyWith<CtaEntity> get copyWith => _$CtaEntityCopyWithImpl<CtaEntity>(this as CtaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CtaEntity&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'CtaEntity(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $CtaEntityCopyWith<$Res>  {
  factory $CtaEntityCopyWith(CtaEntity value, $Res Function(CtaEntity) _then) = _$CtaEntityCopyWithImpl;
@useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class _$CtaEntityCopyWithImpl<$Res>
    implements $CtaEntityCopyWith<$Res> {
  _$CtaEntityCopyWithImpl(this._self, this._then);

  final CtaEntity _self;
  final $Res Function(CtaEntity) _then;

/// Create a copy of CtaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CtaEntity].
extension CtaEntityPatterns on CtaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CtaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CtaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CtaEntity value)  $default,){
final _that = this;
switch (_that) {
case _CtaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CtaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CtaEntity() when $default != null:
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
case _CtaEntity() when $default != null:
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
case _CtaEntity():
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
case _CtaEntity() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _CtaEntity implements CtaEntity {
  const _CtaEntity({required this.label, required this.url});
  

@override final  String label;
@override final  String url;

/// Create a copy of CtaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CtaEntityCopyWith<_CtaEntity> get copyWith => __$CtaEntityCopyWithImpl<_CtaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CtaEntity&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'CtaEntity(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$CtaEntityCopyWith<$Res> implements $CtaEntityCopyWith<$Res> {
  factory _$CtaEntityCopyWith(_CtaEntity value, $Res Function(_CtaEntity) _then) = __$CtaEntityCopyWithImpl;
@override @useResult
$Res call({
 String label, String url
});




}
/// @nodoc
class __$CtaEntityCopyWithImpl<$Res>
    implements _$CtaEntityCopyWith<$Res> {
  __$CtaEntityCopyWithImpl(this._self, this._then);

  final _CtaEntity _self;
  final $Res Function(_CtaEntity) _then;

/// Create a copy of CtaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = null,}) {
  return _then(_CtaEntity(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
