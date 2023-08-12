// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  set name(String? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'nicName')
  String? get nicName => throw _privateConstructorUsedError;
  @JsonKey(name: 'nicName')
  set nicName(String? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'age')
  int? get age => throw _privateConstructorUsedError;
  @JsonKey(name: 'age')
  set age(int? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  Location? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  set location(Location? value) => throw _privateConstructorUsedError;
  @JsonKey(name: 'posts')
  List<Posts>? get posts => throw _privateConstructorUsedError;
  @JsonKey(name: 'posts')
  set posts(List<Posts>? value) => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'nicName') String? nicName,
      @JsonKey(name: 'age') int? age,
      @JsonKey(name: 'location') Location? location,
      @JsonKey(name: 'posts') List<Posts>? posts});

  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? nicName = freezed,
    Object? age = freezed,
    Object? location = freezed,
    Object? posts = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nicName: freezed == nicName
          ? _value.nicName
          : nicName // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Posts>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocationCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $LocationCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'nicName') String? nicName,
      @JsonKey(name: 'age') int? age,
      @JsonKey(name: 'location') Location? location,
      @JsonKey(name: 'posts') List<Posts>? posts});

  @override
  $LocationCopyWith<$Res>? get location;
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? nicName = freezed,
    Object? age = freezed,
    Object? location = freezed,
    Object? posts = freezed,
  }) {
    return _then(_$_User(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nicName: freezed == nicName
          ? _value.nicName
          : nicName // ignore: cast_nullable_to_non_nullable
              as String?,
      age: freezed == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as Location?,
      posts: freezed == posts
          ? _value.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Posts>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User with DiagnosticableTreeMixin implements _User {
  _$_User(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'nicName') this.nicName,
      @JsonKey(name: 'age') this.age,
      @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'posts') this.posts});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  @JsonKey(name: 'name')
  String? name;
  @override
  @JsonKey(name: 'nicName')
  String? nicName;
  @override
  @JsonKey(name: 'age')
  int? age;
  @override
  @JsonKey(name: 'location')
  Location? location;
  @override
  @JsonKey(name: 'posts')
  List<Posts>? posts;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(name: $name, nicName: $nicName, age: $age, location: $location, posts: $posts)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('nicName', nicName))
      ..add(DiagnosticsProperty('age', age))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('posts', posts));
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'nicName') String? nicName,
      @JsonKey(name: 'age') int? age,
      @JsonKey(name: 'location') Location? location,
      @JsonKey(name: 'posts') List<Posts>? posts}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  @JsonKey(name: 'name')
  String? get name;
  @JsonKey(name: 'name')
  set name(String? value);
  @override
  @JsonKey(name: 'nicName')
  String? get nicName;
  @JsonKey(name: 'nicName')
  set nicName(String? value);
  @override
  @JsonKey(name: 'age')
  int? get age;
  @JsonKey(name: 'age')
  set age(int? value);
  @override
  @JsonKey(name: 'location')
  Location? get location;
  @JsonKey(name: 'location')
  set location(Location? value);
  @override
  @JsonKey(name: 'posts')
  List<Posts>? get posts;
  @JsonKey(name: 'posts')
  set posts(List<Posts>? value);
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
