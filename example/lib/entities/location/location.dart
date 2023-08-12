import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@unfreezed
class Location with _$Location {
  factory Location({
    @JsonKey(name: 'lat') double? lat,
    @JsonKey(name: 'lng') double? lng,
  }) = _Location;

  factory Location.fromJson(Map<String, Object?> json) =>
      _$LocationFromJson(json);

  static List<Location> jsonToList(List list) =>
      list.map((e) => Location.fromJson(e as Map<String, dynamic>)).toList();
}
