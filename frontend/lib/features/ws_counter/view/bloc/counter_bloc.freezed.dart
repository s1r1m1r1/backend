// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CounterEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CounterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent()';
}


}

/// @nodoc
class $CounterEventCopyWith<$Res>  {
$CounterEventCopyWith(CounterEvent _, $Res Function(CounterEvent) __);
}


/// Adds pattern-matching-related methods to [CounterEvent].
extension CounterEventPatterns on CounterEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitCounterEvent value)?  init,TResult Function( StartedCounterEvent value)?  started,TResult Function( IncrementCounterEvent value)?  incrementPressed,TResult Function( DecrementCounterEvent value)?  decrementPressed,TResult Function( ChangedCounterEvent value)?  countChanged,TResult Function( ConnectionStateChangedCounterEvent value)?  connectionStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitCounterEvent() when init != null:
return init(_that);case StartedCounterEvent() when started != null:
return started(_that);case IncrementCounterEvent() when incrementPressed != null:
return incrementPressed(_that);case DecrementCounterEvent() when decrementPressed != null:
return decrementPressed(_that);case ChangedCounterEvent() when countChanged != null:
return countChanged(_that);case ConnectionStateChangedCounterEvent() when connectionStateChanged != null:
return connectionStateChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitCounterEvent value)  init,required TResult Function( StartedCounterEvent value)  started,required TResult Function( IncrementCounterEvent value)  incrementPressed,required TResult Function( DecrementCounterEvent value)  decrementPressed,required TResult Function( ChangedCounterEvent value)  countChanged,required TResult Function( ConnectionStateChangedCounterEvent value)  connectionStateChanged,}){
final _that = this;
switch (_that) {
case InitCounterEvent():
return init(_that);case StartedCounterEvent():
return started(_that);case IncrementCounterEvent():
return incrementPressed(_that);case DecrementCounterEvent():
return decrementPressed(_that);case ChangedCounterEvent():
return countChanged(_that);case ConnectionStateChangedCounterEvent():
return connectionStateChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitCounterEvent value)?  init,TResult? Function( StartedCounterEvent value)?  started,TResult? Function( IncrementCounterEvent value)?  incrementPressed,TResult? Function( DecrementCounterEvent value)?  decrementPressed,TResult? Function( ChangedCounterEvent value)?  countChanged,TResult? Function( ConnectionStateChangedCounterEvent value)?  connectionStateChanged,}){
final _that = this;
switch (_that) {
case InitCounterEvent() when init != null:
return init(_that);case StartedCounterEvent() when started != null:
return started(_that);case IncrementCounterEvent() when incrementPressed != null:
return incrementPressed(_that);case DecrementCounterEvent() when decrementPressed != null:
return decrementPressed(_that);case ChangedCounterEvent() when countChanged != null:
return countChanged(_that);case ConnectionStateChangedCounterEvent() when connectionStateChanged != null:
return connectionStateChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  init,TResult Function()?  started,TResult Function()?  incrementPressed,TResult Function()?  decrementPressed,TResult Function( int count)?  countChanged,TResult Function( ConnectionState state)?  connectionStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitCounterEvent() when init != null:
return init();case StartedCounterEvent() when started != null:
return started();case IncrementCounterEvent() when incrementPressed != null:
return incrementPressed();case DecrementCounterEvent() when decrementPressed != null:
return decrementPressed();case ChangedCounterEvent() when countChanged != null:
return countChanged(_that.count);case ConnectionStateChangedCounterEvent() when connectionStateChanged != null:
return connectionStateChanged(_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  init,required TResult Function()  started,required TResult Function()  incrementPressed,required TResult Function()  decrementPressed,required TResult Function( int count)  countChanged,required TResult Function( ConnectionState state)  connectionStateChanged,}) {final _that = this;
switch (_that) {
case InitCounterEvent():
return init();case StartedCounterEvent():
return started();case IncrementCounterEvent():
return incrementPressed();case DecrementCounterEvent():
return decrementPressed();case ChangedCounterEvent():
return countChanged(_that.count);case ConnectionStateChangedCounterEvent():
return connectionStateChanged(_that.state);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  init,TResult? Function()?  started,TResult? Function()?  incrementPressed,TResult? Function()?  decrementPressed,TResult? Function( int count)?  countChanged,TResult? Function( ConnectionState state)?  connectionStateChanged,}) {final _that = this;
switch (_that) {
case InitCounterEvent() when init != null:
return init();case StartedCounterEvent() when started != null:
return started();case IncrementCounterEvent() when incrementPressed != null:
return incrementPressed();case DecrementCounterEvent() when decrementPressed != null:
return decrementPressed();case ChangedCounterEvent() when countChanged != null:
return countChanged(_that.count);case ConnectionStateChangedCounterEvent() when connectionStateChanged != null:
return connectionStateChanged(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class InitCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const InitCounterEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.init'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitCounterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.init()';
}


}




/// @nodoc


class StartedCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const StartedCounterEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.started'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartedCounterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.started()';
}


}




/// @nodoc


class IncrementCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const IncrementCounterEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.incrementPressed'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncrementCounterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.incrementPressed()';
}


}




/// @nodoc


class DecrementCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const DecrementCounterEvent();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.decrementPressed'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DecrementCounterEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.decrementPressed()';
}


}




/// @nodoc


class ChangedCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const ChangedCounterEvent(this.count);
  

 final  int count;

/// Create a copy of CounterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangedCounterEventCopyWith<ChangedCounterEvent> get copyWith => _$ChangedCounterEventCopyWithImpl<ChangedCounterEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.countChanged'))
    ..add(DiagnosticsProperty('count', count));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangedCounterEvent&&(identical(other.count, count) || other.count == count));
}


@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.countChanged(count: $count)';
}


}

/// @nodoc
abstract mixin class $ChangedCounterEventCopyWith<$Res> implements $CounterEventCopyWith<$Res> {
  factory $ChangedCounterEventCopyWith(ChangedCounterEvent value, $Res Function(ChangedCounterEvent) _then) = _$ChangedCounterEventCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$ChangedCounterEventCopyWithImpl<$Res>
    implements $ChangedCounterEventCopyWith<$Res> {
  _$ChangedCounterEventCopyWithImpl(this._self, this._then);

  final ChangedCounterEvent _self;
  final $Res Function(ChangedCounterEvent) _then;

/// Create a copy of CounterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(ChangedCounterEvent(
null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class ConnectionStateChangedCounterEvent with DiagnosticableTreeMixin implements CounterEvent {
  const ConnectionStateChangedCounterEvent(this.state);
  

 final  ConnectionState state;

/// Create a copy of CounterEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionStateChangedCounterEventCopyWith<ConnectionStateChangedCounterEvent> get copyWith => _$ConnectionStateChangedCounterEventCopyWithImpl<ConnectionStateChangedCounterEvent>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'CounterEvent.connectionStateChanged'))
    ..add(DiagnosticsProperty('state', state));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionStateChangedCounterEvent&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'CounterEvent.connectionStateChanged(state: $state)';
}


}

/// @nodoc
abstract mixin class $ConnectionStateChangedCounterEventCopyWith<$Res> implements $CounterEventCopyWith<$Res> {
  factory $ConnectionStateChangedCounterEventCopyWith(ConnectionStateChangedCounterEvent value, $Res Function(ConnectionStateChangedCounterEvent) _then) = _$ConnectionStateChangedCounterEventCopyWithImpl;
@useResult
$Res call({
 ConnectionState state
});




}
/// @nodoc
class _$ConnectionStateChangedCounterEventCopyWithImpl<$Res>
    implements $ConnectionStateChangedCounterEventCopyWith<$Res> {
  _$ConnectionStateChangedCounterEventCopyWithImpl(this._self, this._then);

  final ConnectionStateChangedCounterEvent _self;
  final $Res Function(ConnectionStateChangedCounterEvent) _then;

/// Create a copy of CounterEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(ConnectionStateChangedCounterEvent(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ConnectionState,
  ));
}


}

// dart format on
