import 'classic.dart';
import 'freezed.dart';
import 'json_serializable.dart';

/// [JsonConvertOptions] is an abstract class that forces
/// subclasses to generate some methods and variables
/// for example [toJsonSave] for generate config file of
/// json_convert inside .dart_tool folder
/// and [type] is a variable for convert json to dart type detection
abstract class JsonConvertOptions {
  Map<String, dynamic> toJsonSave();
  late String type;

  /// [fromJsonSave] uses when configuration file of json_convert decoded
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
