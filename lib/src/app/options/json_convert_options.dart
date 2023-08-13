import 'classic.dart';
import 'freezed.dart';
import 'json_serializable.dart';

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
