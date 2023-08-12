import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'posts.freezed.dart';
part 'posts.g.dart';

@unfreezed
class Posts with _$Posts {
  factory Posts({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
  }) = _Posts;

  factory Posts.fromJson(Map<String, Object?> json) => _$PostsFromJson(json);

  static List<Posts> jsonToList(List list) =>
      list.map((e) => Posts.fromJson(e as Map<String, dynamic>)).toList();
}
