import 'json_convert_options.dart';

/// [ConvertClassicOptions] is a class for methods of this generation checkmarks
class ConvertClassicOptions extends JsonConvertOptions {
  final bool fromJson;
  final bool jsonToList;
  final bool toJson;
  final bool copyWith;
  final bool nullable;
  final bool equatableMixin;

  ConvertClassicOptions({
    this.fromJson = true,
    this.jsonToList = true,
    this.toJson = true,
    this.copyWith = true,
    this.nullable = true,
    this.equatableMixin = false,
  });

  @override
  String get type => "classic";

  factory ConvertClassicOptions.fromJsonSave(Map<String, dynamic> json) {
    return ConvertClassicOptions(
      equatableMixin: json['equatableMixin'],
      copyWith: json['copyWith'],
      fromJson: json['fromJson'],
      jsonToList: json['jsonToList'],
      nullable: json['nullable'],
      toJson: json['toJson'],
    );
  }

  @override
  Map<String, dynamic> toJsonSave() => {
        "equatableMixin": equatableMixin,
        "copyWith": copyWith,
        "fromJson": fromJson,
        "jsonToList": jsonToList,
        "nullable": nullable,
        "toJson": toJson,
        "type": type,
      };
}
