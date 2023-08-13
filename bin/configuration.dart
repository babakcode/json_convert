import 'package:json_convert/src/app/options/json_convert_options.dart';

class Configuration {
  bool? completed;
  String? jsonFilesLocation;
  JsonConvertOptions? options;
  String? exportLocation;
  String? exportType;

  Configuration({
    this.completed,
    this.jsonFilesLocation,
    this.options,
    this.exportLocation,
    this.exportType,
  });

  Configuration.fromJson(Map<String, dynamic> json) {
    completed = json['completed'];
    jsonFilesLocation = json['jsonFilesLocation'];
    options = json['options'] == null
        ? null
        : JsonConvertOptions.fromJsonSave(json['options']);
    exportLocation = json['exportLocation'];
    exportType = json['exportType'];
  }

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "jsonFilesLocation": jsonFilesLocation,
        "exportLocation": exportLocation,
        "exportType": exportType,
        "options": options?.toJsonSave(),
      };
}
