
import 'package:json_convert/src/app/options/json_convert_options.dart';

class ConvertJsonSerializableOptions extends JsonConvertOptions {
  final bool copyWith;
  final bool jsonKey;
  final bool jsonToList;
  final bool equatableMixin;

  ConvertJsonSerializableOptions({
    this.jsonKey = false,
    this.copyWith = true,
    this.jsonToList = true,
    this.equatableMixin = false,
  });

  @override
  String get type => "json_serializable";

  factory ConvertJsonSerializableOptions.fromJsonSave(
      Map<String, dynamic> json) {
    return ConvertJsonSerializableOptions(
      jsonKey: json['jsonKey'],
      copyWith: json['copyWith'],
      jsonToList: json['jsonToList'],
      equatableMixin: json['equatableMixin'],
    );
  }

  @override
  Map<String, dynamic> toJsonSave() {
    return {
      "jsonKey": jsonKey,
      "copyWith": copyWith,
      "jsonToList": jsonToList,
      "equatableMixin": equatableMixin,
      "type": type,
    };
  }
}
