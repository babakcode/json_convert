// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      name: json['name'] as String?,
      nicName: json['nicName'] as String?,
      age: json['age'] as int?,
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      posts: (json['posts'] as List<dynamic>?)
          ?.map((e) => Posts.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'name': instance.name,
      'nicName': instance.nicName,
      'age': instance.age,
      'location': instance.location,
      'posts': instance.posts,
    };
