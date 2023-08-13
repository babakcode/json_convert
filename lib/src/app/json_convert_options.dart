import 'package:json_convert/src/app/convert_classic_mode.dart';
import 'package:json_convert/src/app/convert_freezed_mode.dart';
import 'package:json_convert/src/app/convert_json_serializable_mode.dart';

abstract class JsonConvertOptions {
  Map<String, dynamic> toJsonSave();
  late String type;

  static JsonConvertOptions fromJsonSave(Map<String, dynamic> map) {
    switch (map['type']) {
      case "classic":
        return ConvertClassicOptions.fromJsonSave(map);
      case "json_serializable":
        return ConvertJsonSerializableOptions.fromJsonSave(map);
      case "freezed":
        return ConvertFreezedOptions.fromJsonSave(map);
    }
    throw Error();
  }
}
