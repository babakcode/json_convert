import 'package:json_convert/src/app/options/json_convert_options.dart';

/// [ConvertFreezedOptions] is a class for methods of this generation checkmarks
class ConvertFreezedOptions extends JsonConvertOptions {
  final bool foundation;
  final bool mutable;
  final bool jsonKey;
  final bool jsonToList;

  ConvertFreezedOptions({
    this.mutable = false,
    this.jsonKey = false,
    this.foundation = true,
    this.jsonToList = true,
  });

  factory ConvertFreezedOptions.fromJsonSave(Map<String, dynamic> json) {
    return ConvertFreezedOptions(
      jsonKey: json['jsonKey'],
      foundation: json['foundation'],
      jsonToList: json['jsonToList'],
      mutable: json['mutable'],
    );
  }

  @override
  Map<String, dynamic> toJsonSave() {
    return {
      "jsonKey": jsonKey,
      "foundation": foundation,
      "jsonToList": jsonToList,
      "mutable": mutable,
      "type": type,
    };
  }

  @override
  String get type => "freezed";
}
