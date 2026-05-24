// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 HomeTab get currentTab; Map<HomeTab, Widget> get pages; Map<HomeTab, int> get badges; bool get isLoading;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.currentTab, currentTab) || other.currentTab == currentTab)&&const DeepCollectionEquality().equals(other.pages, pages)&&const DeepCollectionEquality().equals(other.badges, badges)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentTab,const DeepCollectionEquality().hash(pages),const DeepCollectionEquality().hash(badges),isLoading);

@override
String toString() {
  return 'HomeState(currentTab: $currentTab, pages: $pages, badges: $badges, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 HomeTab currentTab, Map<HomeTab, Widget> pages, Map<HomeTab, int> badges, bool isLoading
});


$HomeTabCopyWith<$Res> get currentTab;

}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentTab = null,Object? pages = null,Object? badges = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
currentTab: null == currentTab ? _self.currentTab : currentTab // ignore: cast_nullable_to_non_nullable
as HomeTab,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as Map<HomeTab, Widget>,badges: null == badges ? _self.badges : badges // ignore: cast_nullable_to_non_nullable
as Map<HomeTab, int>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeTabCopyWith<$Res> get currentTab {
  
  return $HomeTabCopyWith<$Res>(_self.currentTab, (value) {
    return _then(_self.copyWith(currentTab: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeState value)  $default,){
final _that = this;
switch (_that) {
case _HomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeState value)?  $default,){
final _that = this;
switch (_that) {
case _HomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeTab currentTab,  Map<HomeTab, Widget> pages,  Map<HomeTab, int> badges,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentTab,_that.pages,_that.badges,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeTab currentTab,  Map<HomeTab, Widget> pages,  Map<HomeTab, int> badges,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _HomeState():
return $default(_that.currentTab,_that.pages,_that.badges,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeTab currentTab,  Map<HomeTab, Widget> pages,  Map<HomeTab, int> badges,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _HomeState() when $default != null:
return $default(_that.currentTab,_that.pages,_that.badges,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _HomeState extends HomeState {
  const _HomeState({this.currentTab = const HomeTab.home(), final  Map<HomeTab, Widget> pages = const {}, final  Map<HomeTab, int> badges = const {}, this.isLoading = false}): _pages = pages,_badges = badges,super._();
  

@override@JsonKey() final  HomeTab currentTab;
 final  Map<HomeTab, Widget> _pages;
@override@JsonKey() Map<HomeTab, Widget> get pages {
  if (_pages is EqualUnmodifiableMapView) return _pages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_pages);
}

 final  Map<HomeTab, int> _badges;
@override@JsonKey() Map<HomeTab, int> get badges {
  if (_badges is EqualUnmodifiableMapView) return _badges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_badges);
}

@override@JsonKey() final  bool isLoading;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeStateCopyWith<_HomeState> get copyWith => __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeState&&(identical(other.currentTab, currentTab) || other.currentTab == currentTab)&&const DeepCollectionEquality().equals(other._pages, _pages)&&const DeepCollectionEquality().equals(other._badges, _badges)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,currentTab,const DeepCollectionEquality().hash(_pages),const DeepCollectionEquality().hash(_badges),isLoading);

@override
String toString() {
  return 'HomeState(currentTab: $currentTab, pages: $pages, badges: $badges, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(_HomeState value, $Res Function(_HomeState) _then) = __$HomeStateCopyWithImpl;
@override @useResult
$Res call({
 HomeTab currentTab, Map<HomeTab, Widget> pages, Map<HomeTab, int> badges, bool isLoading
});


@override $HomeTabCopyWith<$Res> get currentTab;

}
/// @nodoc
class __$HomeStateCopyWithImpl<$Res>
    implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTab = null,Object? pages = null,Object? badges = null,Object? isLoading = null,}) {
  return _then(_HomeState(
currentTab: null == currentTab ? _self.currentTab : currentTab // ignore: cast_nullable_to_non_nullable
as HomeTab,pages: null == pages ? _self._pages : pages // ignore: cast_nullable_to_non_nullable
as Map<HomeTab, Widget>,badges: null == badges ? _self._badges : badges // ignore: cast_nullable_to_non_nullable
as Map<HomeTab, int>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HomeTabCopyWith<$Res> get currentTab {
  
  return $HomeTabCopyWith<$Res>(_self.currentTab, (value) {
    return _then(_self.copyWith(currentTab: value));
  });
}
}

/// @nodoc
mixin _$HomeTab {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeTab);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeTab()';
}


}

/// @nodoc
class $HomeTabCopyWith<$Res>  {
$HomeTabCopyWith(HomeTab _, $Res Function(HomeTab) __);
}


/// Adds pattern-matching-related methods to [HomeTab].
extension HomeTabPatterns on HomeTab {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _HomeTab value)?  home,TResult Function( _SearchTab value)?  search,TResult Function( _FavoriteTab value)?  favorite,TResult Function( _ProfileTab value)?  profile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeTab() when home != null:
return home(_that);case _SearchTab() when search != null:
return search(_that);case _FavoriteTab() when favorite != null:
return favorite(_that);case _ProfileTab() when profile != null:
return profile(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _HomeTab value)  home,required TResult Function( _SearchTab value)  search,required TResult Function( _FavoriteTab value)  favorite,required TResult Function( _ProfileTab value)  profile,}){
final _that = this;
switch (_that) {
case _HomeTab():
return home(_that);case _SearchTab():
return search(_that);case _FavoriteTab():
return favorite(_that);case _ProfileTab():
return profile(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _HomeTab value)?  home,TResult? Function( _SearchTab value)?  search,TResult? Function( _FavoriteTab value)?  favorite,TResult? Function( _ProfileTab value)?  profile,}){
final _that = this;
switch (_that) {
case _HomeTab() when home != null:
return home(_that);case _SearchTab() when search != null:
return search(_that);case _FavoriteTab() when favorite != null:
return favorite(_that);case _ProfileTab() when profile != null:
return profile(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  home,TResult Function()?  search,TResult Function()?  favorite,TResult Function()?  profile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeTab() when home != null:
return home();case _SearchTab() when search != null:
return search();case _FavoriteTab() when favorite != null:
return favorite();case _ProfileTab() when profile != null:
return profile();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  home,required TResult Function()  search,required TResult Function()  favorite,required TResult Function()  profile,}) {final _that = this;
switch (_that) {
case _HomeTab():
return home();case _SearchTab():
return search();case _FavoriteTab():
return favorite();case _ProfileTab():
return profile();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  home,TResult? Function()?  search,TResult? Function()?  favorite,TResult? Function()?  profile,}) {final _that = this;
switch (_that) {
case _HomeTab() when home != null:
return home();case _SearchTab() when search != null:
return search();case _FavoriteTab() when favorite != null:
return favorite();case _ProfileTab() when profile != null:
return profile();case _:
  return null;

}
}

}

/// @nodoc


class _HomeTab extends HomeTab {
  const _HomeTab(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeTab);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeTab.home()';
}


}




/// @nodoc


class _SearchTab extends HomeTab {
  const _SearchTab(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchTab);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeTab.search()';
}


}




/// @nodoc


class _FavoriteTab extends HomeTab {
  const _FavoriteTab(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteTab);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeTab.favorite()';
}


}




/// @nodoc


class _ProfileTab extends HomeTab {
  const _ProfileTab(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileTab);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeTab.profile()';
}


}




// dart format on
