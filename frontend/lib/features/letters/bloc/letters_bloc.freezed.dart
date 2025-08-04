// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'letters_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LettersEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LettersEvent()';
}


}

/// @nodoc
class $LettersEventCopyWith<$Res>  {
$LettersEventCopyWith(LettersEvent _, $Res Function(LettersEvent) __);
}


/// Adds pattern-matching-related methods to [LettersEvent].
extension LettersEventPatterns on LettersEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LettersStarted value)?  started,TResult Function( LettersNewPressed value)?  newPressed,TResult Function( LettersDeleteMessagePressed value)?  deleteMessagePressed,TResult Function( LettersCorrectLetterPressed value)?  correctLetterPressed,TResult Function( LetterOnNewLetters value)?  onNewLetters,TResult Function( LetterOnUpdateLetters value)?  onUpdateLetters,TResult Function( LettersOnDeleteMessage value)?  onDeleteMessage,TResult Function( LettersConnectionStateChanged value)?  connectionStateChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LettersStarted() when started != null:
return started(_that);case LettersNewPressed() when newPressed != null:
return newPressed(_that);case LettersDeleteMessagePressed() when deleteMessagePressed != null:
return deleteMessagePressed(_that);case LettersCorrectLetterPressed() when correctLetterPressed != null:
return correctLetterPressed(_that);case LetterOnNewLetters() when onNewLetters != null:
return onNewLetters(_that);case LetterOnUpdateLetters() when onUpdateLetters != null:
return onUpdateLetters(_that);case LettersOnDeleteMessage() when onDeleteMessage != null:
return onDeleteMessage(_that);case LettersConnectionStateChanged() when connectionStateChanged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LettersStarted value)  started,required TResult Function( LettersNewPressed value)  newPressed,required TResult Function( LettersDeleteMessagePressed value)  deleteMessagePressed,required TResult Function( LettersCorrectLetterPressed value)  correctLetterPressed,required TResult Function( LetterOnNewLetters value)  onNewLetters,required TResult Function( LetterOnUpdateLetters value)  onUpdateLetters,required TResult Function( LettersOnDeleteMessage value)  onDeleteMessage,required TResult Function( LettersConnectionStateChanged value)  connectionStateChanged,}){
final _that = this;
switch (_that) {
case LettersStarted():
return started(_that);case LettersNewPressed():
return newPressed(_that);case LettersDeleteMessagePressed():
return deleteMessagePressed(_that);case LettersCorrectLetterPressed():
return correctLetterPressed(_that);case LetterOnNewLetters():
return onNewLetters(_that);case LetterOnUpdateLetters():
return onUpdateLetters(_that);case LettersOnDeleteMessage():
return onDeleteMessage(_that);case LettersConnectionStateChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LettersStarted value)?  started,TResult? Function( LettersNewPressed value)?  newPressed,TResult? Function( LettersDeleteMessagePressed value)?  deleteMessagePressed,TResult? Function( LettersCorrectLetterPressed value)?  correctLetterPressed,TResult? Function( LetterOnNewLetters value)?  onNewLetters,TResult? Function( LetterOnUpdateLetters value)?  onUpdateLetters,TResult? Function( LettersOnDeleteMessage value)?  onDeleteMessage,TResult? Function( LettersConnectionStateChanged value)?  connectionStateChanged,}){
final _that = this;
switch (_that) {
case LettersStarted() when started != null:
return started(_that);case LettersNewPressed() when newPressed != null:
return newPressed(_that);case LettersDeleteMessagePressed() when deleteMessagePressed != null:
return deleteMessagePressed(_that);case LettersCorrectLetterPressed() when correctLetterPressed != null:
return correctLetterPressed(_that);case LetterOnNewLetters() when onNewLetters != null:
return onNewLetters(_that);case LetterOnUpdateLetters() when onUpdateLetters != null:
return onUpdateLetters(_that);case LettersOnDeleteMessage() when onDeleteMessage != null:
return onDeleteMessage(_that);case LettersConnectionStateChanged() when connectionStateChanged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String message)?  newPressed,TResult Function( int messageId)?  deleteMessagePressed,TResult Function( String message,  int messageId)?  correctLetterPressed,TResult Function( List<LetterDto> letters)?  onNewLetters,TResult Function( List<LetterDto> letters)?  onUpdateLetters,TResult Function( List<int> messageIds)?  onDeleteMessage,TResult Function( ConnectionState state)?  connectionStateChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LettersStarted() when started != null:
return started();case LettersNewPressed() when newPressed != null:
return newPressed(_that.message);case LettersDeleteMessagePressed() when deleteMessagePressed != null:
return deleteMessagePressed(_that.messageId);case LettersCorrectLetterPressed() when correctLetterPressed != null:
return correctLetterPressed(_that.message,_that.messageId);case LetterOnNewLetters() when onNewLetters != null:
return onNewLetters(_that.letters);case LetterOnUpdateLetters() when onUpdateLetters != null:
return onUpdateLetters(_that.letters);case LettersOnDeleteMessage() when onDeleteMessage != null:
return onDeleteMessage(_that.messageIds);case LettersConnectionStateChanged() when connectionStateChanged != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String message)  newPressed,required TResult Function( int messageId)  deleteMessagePressed,required TResult Function( String message,  int messageId)  correctLetterPressed,required TResult Function( List<LetterDto> letters)  onNewLetters,required TResult Function( List<LetterDto> letters)  onUpdateLetters,required TResult Function( List<int> messageIds)  onDeleteMessage,required TResult Function( ConnectionState state)  connectionStateChanged,}) {final _that = this;
switch (_that) {
case LettersStarted():
return started();case LettersNewPressed():
return newPressed(_that.message);case LettersDeleteMessagePressed():
return deleteMessagePressed(_that.messageId);case LettersCorrectLetterPressed():
return correctLetterPressed(_that.message,_that.messageId);case LetterOnNewLetters():
return onNewLetters(_that.letters);case LetterOnUpdateLetters():
return onUpdateLetters(_that.letters);case LettersOnDeleteMessage():
return onDeleteMessage(_that.messageIds);case LettersConnectionStateChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String message)?  newPressed,TResult? Function( int messageId)?  deleteMessagePressed,TResult? Function( String message,  int messageId)?  correctLetterPressed,TResult? Function( List<LetterDto> letters)?  onNewLetters,TResult? Function( List<LetterDto> letters)?  onUpdateLetters,TResult? Function( List<int> messageIds)?  onDeleteMessage,TResult? Function( ConnectionState state)?  connectionStateChanged,}) {final _that = this;
switch (_that) {
case LettersStarted() when started != null:
return started();case LettersNewPressed() when newPressed != null:
return newPressed(_that.message);case LettersDeleteMessagePressed() when deleteMessagePressed != null:
return deleteMessagePressed(_that.messageId);case LettersCorrectLetterPressed() when correctLetterPressed != null:
return correctLetterPressed(_that.message,_that.messageId);case LetterOnNewLetters() when onNewLetters != null:
return onNewLetters(_that.letters);case LetterOnUpdateLetters() when onUpdateLetters != null:
return onUpdateLetters(_that.letters);case LettersOnDeleteMessage() when onDeleteMessage != null:
return onDeleteMessage(_that.messageIds);case LettersConnectionStateChanged() when connectionStateChanged != null:
return connectionStateChanged(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class LettersStarted implements LettersEvent {
  const LettersStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LettersEvent.started()';
}


}




/// @nodoc


class LettersNewPressed implements LettersEvent {
  const LettersNewPressed(this.message);
  

 final  String message;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LettersNewPressedCopyWith<LettersNewPressed> get copyWith => _$LettersNewPressedCopyWithImpl<LettersNewPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersNewPressed&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'LettersEvent.newPressed(message: $message)';
}


}

/// @nodoc
abstract mixin class $LettersNewPressedCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LettersNewPressedCopyWith(LettersNewPressed value, $Res Function(LettersNewPressed) _then) = _$LettersNewPressedCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$LettersNewPressedCopyWithImpl<$Res>
    implements $LettersNewPressedCopyWith<$Res> {
  _$LettersNewPressedCopyWithImpl(this._self, this._then);

  final LettersNewPressed _self;
  final $Res Function(LettersNewPressed) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(LettersNewPressed(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LettersDeleteMessagePressed implements LettersEvent {
  const LettersDeleteMessagePressed(this.messageId);
  

 final  int messageId;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LettersDeleteMessagePressedCopyWith<LettersDeleteMessagePressed> get copyWith => _$LettersDeleteMessagePressedCopyWithImpl<LettersDeleteMessagePressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersDeleteMessagePressed&&(identical(other.messageId, messageId) || other.messageId == messageId));
}


@override
int get hashCode => Object.hash(runtimeType,messageId);

@override
String toString() {
  return 'LettersEvent.deleteMessagePressed(messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $LettersDeleteMessagePressedCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LettersDeleteMessagePressedCopyWith(LettersDeleteMessagePressed value, $Res Function(LettersDeleteMessagePressed) _then) = _$LettersDeleteMessagePressedCopyWithImpl;
@useResult
$Res call({
 int messageId
});




}
/// @nodoc
class _$LettersDeleteMessagePressedCopyWithImpl<$Res>
    implements $LettersDeleteMessagePressedCopyWith<$Res> {
  _$LettersDeleteMessagePressedCopyWithImpl(this._self, this._then);

  final LettersDeleteMessagePressed _self;
  final $Res Function(LettersDeleteMessagePressed) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageId = null,}) {
  return _then(LettersDeleteMessagePressed(
null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LettersCorrectLetterPressed implements LettersEvent {
  const LettersCorrectLetterPressed({required this.message, required this.messageId});
  

 final  String message;
 final  int messageId;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LettersCorrectLetterPressedCopyWith<LettersCorrectLetterPressed> get copyWith => _$LettersCorrectLetterPressedCopyWithImpl<LettersCorrectLetterPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersCorrectLetterPressed&&(identical(other.message, message) || other.message == message)&&(identical(other.messageId, messageId) || other.messageId == messageId));
}


@override
int get hashCode => Object.hash(runtimeType,message,messageId);

@override
String toString() {
  return 'LettersEvent.correctLetterPressed(message: $message, messageId: $messageId)';
}


}

/// @nodoc
abstract mixin class $LettersCorrectLetterPressedCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LettersCorrectLetterPressedCopyWith(LettersCorrectLetterPressed value, $Res Function(LettersCorrectLetterPressed) _then) = _$LettersCorrectLetterPressedCopyWithImpl;
@useResult
$Res call({
 String message, int messageId
});




}
/// @nodoc
class _$LettersCorrectLetterPressedCopyWithImpl<$Res>
    implements $LettersCorrectLetterPressedCopyWith<$Res> {
  _$LettersCorrectLetterPressedCopyWithImpl(this._self, this._then);

  final LettersCorrectLetterPressed _self;
  final $Res Function(LettersCorrectLetterPressed) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? messageId = null,}) {
  return _then(LettersCorrectLetterPressed(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,messageId: null == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class LetterOnNewLetters implements LettersEvent {
  const LetterOnNewLetters(final  List<LetterDto> letters): _letters = letters;
  

 final  List<LetterDto> _letters;
 List<LetterDto> get letters {
  if (_letters is EqualUnmodifiableListView) return _letters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_letters);
}


/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterOnNewLettersCopyWith<LetterOnNewLetters> get copyWith => _$LetterOnNewLettersCopyWithImpl<LetterOnNewLetters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterOnNewLetters&&const DeepCollectionEquality().equals(other._letters, _letters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_letters));

@override
String toString() {
  return 'LettersEvent.onNewLetters(letters: $letters)';
}


}

/// @nodoc
abstract mixin class $LetterOnNewLettersCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LetterOnNewLettersCopyWith(LetterOnNewLetters value, $Res Function(LetterOnNewLetters) _then) = _$LetterOnNewLettersCopyWithImpl;
@useResult
$Res call({
 List<LetterDto> letters
});




}
/// @nodoc
class _$LetterOnNewLettersCopyWithImpl<$Res>
    implements $LetterOnNewLettersCopyWith<$Res> {
  _$LetterOnNewLettersCopyWithImpl(this._self, this._then);

  final LetterOnNewLetters _self;
  final $Res Function(LetterOnNewLetters) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? letters = null,}) {
  return _then(LetterOnNewLetters(
null == letters ? _self._letters : letters // ignore: cast_nullable_to_non_nullable
as List<LetterDto>,
  ));
}


}

/// @nodoc


class LetterOnUpdateLetters implements LettersEvent {
  const LetterOnUpdateLetters(final  List<LetterDto> letters): _letters = letters;
  

 final  List<LetterDto> _letters;
 List<LetterDto> get letters {
  if (_letters is EqualUnmodifiableListView) return _letters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_letters);
}


/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LetterOnUpdateLettersCopyWith<LetterOnUpdateLetters> get copyWith => _$LetterOnUpdateLettersCopyWithImpl<LetterOnUpdateLetters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LetterOnUpdateLetters&&const DeepCollectionEquality().equals(other._letters, _letters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_letters));

@override
String toString() {
  return 'LettersEvent.onUpdateLetters(letters: $letters)';
}


}

/// @nodoc
abstract mixin class $LetterOnUpdateLettersCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LetterOnUpdateLettersCopyWith(LetterOnUpdateLetters value, $Res Function(LetterOnUpdateLetters) _then) = _$LetterOnUpdateLettersCopyWithImpl;
@useResult
$Res call({
 List<LetterDto> letters
});




}
/// @nodoc
class _$LetterOnUpdateLettersCopyWithImpl<$Res>
    implements $LetterOnUpdateLettersCopyWith<$Res> {
  _$LetterOnUpdateLettersCopyWithImpl(this._self, this._then);

  final LetterOnUpdateLetters _self;
  final $Res Function(LetterOnUpdateLetters) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? letters = null,}) {
  return _then(LetterOnUpdateLetters(
null == letters ? _self._letters : letters // ignore: cast_nullable_to_non_nullable
as List<LetterDto>,
  ));
}


}

/// @nodoc


class LettersOnDeleteMessage implements LettersEvent {
  const LettersOnDeleteMessage(final  List<int> messageIds): _messageIds = messageIds;
  

 final  List<int> _messageIds;
 List<int> get messageIds {
  if (_messageIds is EqualUnmodifiableListView) return _messageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messageIds);
}


/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LettersOnDeleteMessageCopyWith<LettersOnDeleteMessage> get copyWith => _$LettersOnDeleteMessageCopyWithImpl<LettersOnDeleteMessage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersOnDeleteMessage&&const DeepCollectionEquality().equals(other._messageIds, _messageIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messageIds));

@override
String toString() {
  return 'LettersEvent.onDeleteMessage(messageIds: $messageIds)';
}


}

/// @nodoc
abstract mixin class $LettersOnDeleteMessageCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LettersOnDeleteMessageCopyWith(LettersOnDeleteMessage value, $Res Function(LettersOnDeleteMessage) _then) = _$LettersOnDeleteMessageCopyWithImpl;
@useResult
$Res call({
 List<int> messageIds
});




}
/// @nodoc
class _$LettersOnDeleteMessageCopyWithImpl<$Res>
    implements $LettersOnDeleteMessageCopyWith<$Res> {
  _$LettersOnDeleteMessageCopyWithImpl(this._self, this._then);

  final LettersOnDeleteMessage _self;
  final $Res Function(LettersOnDeleteMessage) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageIds = null,}) {
  return _then(LettersOnDeleteMessage(
null == messageIds ? _self._messageIds : messageIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class LettersConnectionStateChanged implements LettersEvent {
  const LettersConnectionStateChanged(this.state);
  

 final  ConnectionState state;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LettersConnectionStateChangedCopyWith<LettersConnectionStateChanged> get copyWith => _$LettersConnectionStateChangedCopyWithImpl<LettersConnectionStateChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LettersConnectionStateChanged&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'LettersEvent.connectionStateChanged(state: $state)';
}


}

/// @nodoc
abstract mixin class $LettersConnectionStateChangedCopyWith<$Res> implements $LettersEventCopyWith<$Res> {
  factory $LettersConnectionStateChangedCopyWith(LettersConnectionStateChanged value, $Res Function(LettersConnectionStateChanged) _then) = _$LettersConnectionStateChangedCopyWithImpl;
@useResult
$Res call({
 ConnectionState state
});




}
/// @nodoc
class _$LettersConnectionStateChangedCopyWithImpl<$Res>
    implements $LettersConnectionStateChangedCopyWith<$Res> {
  _$LettersConnectionStateChangedCopyWithImpl(this._self, this._then);

  final LettersConnectionStateChanged _self;
  final $Res Function(LettersConnectionStateChanged) _then;

/// Create a copy of LettersEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(LettersConnectionStateChanged(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as ConnectionState,
  ));
}


}

// dart format on
