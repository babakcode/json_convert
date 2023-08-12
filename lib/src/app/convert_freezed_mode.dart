import 'package:json_convert/json_convert.dart';
import 'package:json_convert/src/models/variables_declaration.dart';
import 'package:recase/recase.dart';
import 'json_convert_mode.dart';
import 'json_convert_options.dart';

class ConvertFreezedMode implements JsonConvertMode {
  @override
  String className;

  @override
  List<MapEntry<String, String>> files = [];

  @override
  Map<String, dynamic> json;

  ConvertFreezedOptions options;

  ConvertFreezedMode(
    this.json, {
    required this.className,
    required this.options,
  });

  void convert() {
    /// clear .dart files list
    files.clear();

    /// files variables
    final allFilesVariables =
        JsonConvertUtils.variablesDeclare(json, name: className);

    final allFilesImports =
        JsonConvertUtils.importClasses(json, className: className);

    for (final entry in allFilesVariables) {
      /// get variables
      final variables = entry.value;
      final imports =
          allFilesImports.firstWhere((element) => element.key == entry.key);
      final fileName = entry.key;

      files.add(MapEntry(entry.key,
          '''${options.foundation ? "import 'package:flutter/foundation.dart';" : ""}
import 'package:freezed_annotation/freezed_annotation.dart';
${imports.value.map((e) => "import '../$e/$e.dart';").join("\n")}
${"part '${fileName.snakeCase}.freezed.dart';"}
${"part '${fileName.snakeCase}.g.dart';"}

@${options.mutable ? "unfreezed" : "freezed"}
class ${fileName.pascalCase} with _\$${fileName.pascalCase} {
  ${options.mutable ? "" : "const "}factory ${fileName.pascalCase}({
    ${_defaultVariables(variables).join(",\n    ")},
  }) = _${fileName.pascalCase};

  factory ${fileName.pascalCase}.fromJson(Map<String, Object?> json) =>
      _\$${fileName.pascalCase}FromJson(json);
        
  ${options.jsonToList ? '''static List<${fileName.pascalCase}> jsonToList(List list) =>
    list.map((e) => ${fileName.pascalCase}.fromJson(e as Map<String, dynamic>))
    .toList();   
''' : ""}
}
'''));
    }
  }

  /// example for [_defaultVariables] is
  ///    @JsonKey(name: 'website') String? website,
  //     @JsonKey(name: 'company') Company? company,
  List<String> _defaultVariables(VariablesDeclaration variables) {
    List<String> list = [];
    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      final type = variables.types.elementAt(index);
      final entry = variables.defaultValues.elementAt(index);
      //
      list.add(
          "${options.jsonKey ? "@JsonKey(name: '${entry.key}') " : ""}$type? $name");
    }
    return list;
  }
}

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
      "type" : type,
    };
  }

  @override
  String get type => "freezed";
}
