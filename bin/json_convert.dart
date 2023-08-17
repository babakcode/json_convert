import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:json_convert/json_convert.dart';
import 'package:json_convert/src/app/json_convert_utils.dart';
import 'package:path/path.dart';
import 'package:process_run/process_run.dart';
import 'package:recase/recase.dart';

import 'configuration.dart';

final shell = Shell();

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  Configuration configuration; // default configuration

  var systemTempDir = Directory("./.dart_tool/json_convert");
  if (!systemTempDir.existsSync()) {
    systemTempDir.createSync();
  }
  final configFile = File("${systemTempDir.path}/config.json");
  if (!configFile.existsSync()) {
    configFile.existsSync();
    configuration = Configuration(completed: false);
    _saveConfiguration(configFile, configuration);
  }
  configuration =
      Configuration.fromJson(jsonDecode(configFile.readAsStringSync()));

  if (arguments.contains("clear")) {
    configuration.completed = false;
    _saveConfiguration(configFile, configuration);
    stdout.writeln("${JsonConvertUtils.green}The json_convert default config cleared successfully!${JsonConvertUtils.reset}");
    return;
  } else if (arguments.contains("build")) {
    _build();
    return;
  }

  if (!configuration.completed!) {
    stdout.writeln();
    stdout.write("Default json files directory is: `${JsonConvertUtils.blue}assets/json_models${JsonConvertUtils.reset}`\n"
        "Would you like to change directory?\n[Press Enter / Write new dir location]: ");
    var data = stdin.readLineSync();
    if (data == "") {
      data = null;
    }
    configuration.jsonFilesLocation = data ?? "./assets/json_models";

    if (!configuration.jsonFilesLocation!.startsWith("./")) {
      configuration.jsonFilesLocation =
          configuration.jsonFilesLocation?.replaceFirst("/", "");
      configuration.jsonFilesLocation = "./${configuration.jsonFilesLocation!}";
    }
  }

  Directory dir = Directory(configuration.jsonFilesLocation!);

  if (!dir.existsSync()) {
    stderr.writeln();
    stderr.writeln("${JsonConvertUtils.red}${configuration.jsonFilesLocation} dose not exist!${JsonConvertUtils.reset}");
    return;
  }

  final List<FileSystemEntity> entities = (await dir.list().toList())
      .where((element) => element.path.endsWith(".json"))
      .toList();

  stdout.writeln();

  if (entities.isEmpty) {
    stderr.writeln();
    stderr.writeln("${JsonConvertUtils.red}No `.json` file found in ${dir.path} path location${JsonConvertUtils.reset}");
    return;
  }

  if (!configuration.completed!) {
    stdout.writeln("Please select export type:");
    stdout.writeln("${JsonConvertUtils.cyan}1. classic${JsonConvertUtils.reset}");
    stdout.writeln("${JsonConvertUtils.cyan}2. json_serializable${JsonConvertUtils.reset}");
    stdout.writeln("${JsonConvertUtils.cyan}3. freezed${JsonConvertUtils.reset}");
    configuration.exportType = _detectExportType();
    stdout.writeln();
  }

  if (!configuration.completed!) {
    configuration.options = _exportTypeOptions(configuration.exportType!);
    stdout.writeln();
  }

  if (!configuration.completed!) {
    stdout.writeln("Export location inside lib folder: default directory is "
        "${JsonConvertUtils.blue}`models`${JsonConvertUtils.reset}");
    stdout.writeln("Do you want to change it?");
    stdout.write("[Press Enter / Write new directory location]: ");
    var data = stdin.readLineSync();
    if (data == "") {
      data = null;
    }
    configuration.exportLocation =
        data?.replaceFirst("/", "").replaceFirst("./", "") ?? "models";
    configuration.exportLocation = "./lib/${configuration.exportLocation}";
  }

  Directory exportDir = Directory(configuration.exportLocation!);
  if (!exportDir.existsSync()) {
    exportDir.createSync();
  }

  for (final entity in entities) {
    final file = File(entity.path);

    try {
      final data = jsonDecode(await file.readAsString());
      Map<String, dynamic>? jsonData;
      if (data is Map<String, dynamic>) {
        jsonData = data;
      } else if (data is List) {
        if (data.isNotEmpty) {
          if (data.first is Map<String, dynamic>) {
            jsonData = data.first;
          }
        }
      }

      if (jsonData != null) {
        _exportCodesToLocation(
          jsonData,
          file: file,
          dir: exportDir,
          type: configuration.exportType!,
          options: configuration.options!,
        );
      }
    } catch (e) {
      stderr.writeln("${JsonConvertUtils.red}$e${JsonConvertUtils.reset}");
      continue;
    }
  }
  try {
    stdout.writeln();
    await shell.run("dart format ${configuration.exportLocation}");
  } catch (e) {
    log("error", error: e);
  }

  if(!configuration.completed!){

    stdout.writeln();
    stdout.writeln("Do you want to save your configuration of "
        "${JsonConvertUtils.bold}json_convert${JsonConvertUtils.reset}?\n"
        "By default, it is not saved! [ n / y ]");
    final save = stdin.readLineSync();
    if(save == "y"){
      configuration.completed = true;

      _saveConfiguration(configFile, configuration);
    }
  }
}

void _build() async {
  final buildRunner =
      await addDependencyIfNotExist("build_runner", asDev: true);
  if (buildRunner == null) {
    return;
  }
  final jsonSerializable =
      await addDependencyIfNotExist("json_serializable", asDev: true);
  if (jsonSerializable == null) {
    return;
  }
  final jsonAnnotation = await addDependencyIfNotExist("json_annotation");
  if (jsonAnnotation == null) {
    return;
  }
  final freezed = await addDependencyIfNotExist("freezed", asDev: true);
  if (freezed == null) {
    return;
  }
  final freezedAnnotation = await addDependencyIfNotExist("freezed_annotation");
  if (freezedAnnotation == null) {
    return;
  }
  final analysisOptionsFile = File("./analysis_options.yaml");
  if (analysisOptionsFile.existsSync()) {
    String data = analysisOptionsFile.readAsStringSync();
    if (!data.contains('''analyzer:
  errors:
    invalid_annotation_target: ignore''')) {
      data += '''analyzer:
  errors:
    invalid_annotation_target: ignore''';
      analysisOptionsFile.writeAsStringSync(data);
    }
  }

  await shell.run("dart run build_runner build");
}

Future<bool?> addDependencyIfNotExist(String dependency,
    {bool asDev = false}) async {
  final pubspec = File("./pubspec.yaml");
  if (!pubspec.existsSync()) {
    stdout.writeln("You don't have `pubspec.yaml` in root layout");
    return null;
  }
  final readPubspec = pubspec.readAsStringSync();

  if (!readPubspec.contains(" $dependency: ")) {
    stdout.writeln();
    String ans = stdInRequired(
        "You don't have ${JsonConvertUtils.blue}$dependency"
            "${JsonConvertUtils.reset} in dependencies!\n"
            "Do you want to add this dependency? [y/n]: ",
        lowercase: true,
        includes: ["y", "n"]);
    if (ans == 'y') {
      await shell.run("dart pub add ${asDev ? "--dev " : ""}$dependency");
      return addDependencyIfNotExist(dependency);
    }
  } else {
    return true;
  }
  return null;
}

String stdInRequired(
  String key, {
  List includes = const [],
  bool lowercase = false,
}) {
  stdout.write(key);
  String? s = stdin.readLineSync();
  if (s == null || s == '') {
    s = stdInRequired(key, includes: includes, lowercase: lowercase);
  }
  s = s.trim();
  if (includes.isNotEmpty) {
    if (lowercase) {
      s = s.toLowerCase();
    }
    if (!includes.contains(s)) {
      s = stdInRequired(key, includes: includes, lowercase: lowercase);
    }
  }
  return s;
}

void _exportCodesToLocation(Map<String, dynamic> jsonData,
    {required String type,
    required JsonConvertOptions options,
    required File file,
    required Directory dir}) {
  String fileName = file.path;
  fileName = basename(fileName).replaceAll(".json", "");
  // if(fileName.contains("\\")){
  //   fileName = fileName.split("\\").last;
  // }
  switch (type) {
    case "classic":
      final convert = ConvertClassicMode(
        jsonData,
        className: fileName,
        options: options as ConvertClassicOptions,
      );
      convert.convert();
      for (var element in convert.files) {
        File("${dir.path}/${element.key.snakeCase}.dart")
          ..createSync()
          ..writeAsStringSync(element.value);
      }
      break;

    case "json_serializable":
      {
        final convert = ConvertJsonSerializableMode(
          jsonData,
          className: fileName,
          options: options as ConvertJsonSerializableOptions,
        );
        convert.convert();
        for (var element in convert.files) {
          /// create directory with class name
          /// as an example
          /// user export in ( user/user.dart)
          Directory dirWithClassName =
              Directory("${dir.path}/${element.key.snakeCase}");
          dirWithClassName.createSync();
          File("${dirWithClassName.path}/${element.key.snakeCase}.dart")
            ..createSync()
            ..writeAsStringSync(element.value);
        }

        break;
      }
    case "freezed":
      {
        final convert = ConvertFreezedMode(
          jsonData,
          className: fileName,
          options: options as ConvertFreezedOptions,
        );
        convert.convert();
        for (var element in convert.files) {
          /// create directory with class name
          /// as an example
          /// user export in ( user/user.dart)
          Directory dirWithClassName =
              Directory("${dir.path}/${element.key.snakeCase}");
          dirWithClassName.createSync();
          File("${dirWithClassName.path}/${element.key.snakeCase}.dart")
            ..createSync()
            ..writeAsStringSync(element.value);
        }

        break;
      }
  }
}

JsonConvertOptions _exportTypeOptions(String exportType) {
  stdout.writeln("Please complete the $exportType model methods checkbox:");
  switch (exportType) {
    case "classic":
      return ConvertClassicOptions(
        nullable: _getOption("nullable", def: true),
        fromJson: _getOption("fromJson", def: true),
        toJson: _getOption("toJson", def: true),
        copyWith: _getOption("copyWith", def: true),
        jsonToList: _getOption("jsonToList", def: true),
        equatableMixin: _getOption("equatableMixin", def: false),
      );
    case "json_serializable":
      return ConvertJsonSerializableOptions(
        copyWith: _getOption("copyWith", def: true),
        jsonKey: _getOption("jsonKey", def: true),
        jsonToList: _getOption("jsonToList", def: true),
        equatableMixin: _getOption("equatableMixin", def: false),
      );
    case "freezed":
      return ConvertFreezedOptions(
        foundation: _getOption("foundation", def: true),
        jsonKey: _getOption("jsonKey", def: true),
        jsonToList: _getOption("jsonToList", def: true),
        mutable: _getOption("mutable", def: false),
      );
  }

  throw Error();
}

bool _getOption(String key, {required bool def}) {
  stdout.write(
      "$key ${JsonConvertUtils.lightYellow}(default: $def)${JsonConvertUtils.reset} [Enter or $def/ ${def ? "false" : "true"}]: ");
  String option = stdin.readLineSync() ?? "$def";
  if (option == "") {
    option = "$def";
  }
  return bool.tryParse(option) ?? _getOption(key, def: def);
}

void _saveConfiguration(File file, Configuration configuration) {
  file.writeAsStringSync(jsonEncode(configuration.toJson()));
}

String _detectExportType() {
  stdout.write("Write [1-3] or [classic, json_serializable, freezed]: ");
  String? data = stdin.readLineSync();
  data ??= _detectExportType();
  switch (data.trim()) {
    case "1" || "classic":
      return "classic";
    case "2" || "json_serializable":
      return "json_serializable";
    case "3" || "freezed":
      return "freezed";
    default:
      data = _detectExportType();
  }
  return data;
}

Future<void> dcat(List<String> paths, {bool showLineNumbers = false}) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    await stdin.pipe(stdout);
  } else {
    for (final path in paths) {
      var lineNumber = 1;
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      try {
        await for (final line in lines) {
          if (showLineNumbers) {
            stdout.write('${lineNumber++} ');
          }
          stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future<void> _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}
