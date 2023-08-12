import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../location/location.dart';
import '../posts/posts.dart';
part 'user.freezed.dart';
part 'user.g.dart';

@unfreezed
class User with _$User {
  factory User({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'nicName') String? nicName,
    @JsonKey(name: 'age') int? age,
    @JsonKey(name: 'location') Location? location,
    @JsonKey(name: 'posts') List<Posts>? posts,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  static List<User> jsonToList(List list) =>
      list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
}
