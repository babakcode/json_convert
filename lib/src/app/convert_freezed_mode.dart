import 'package:json_convert/src/models/variables_declaration.dart';
import 'package:recase/recase.dart';
import 'json_convert_mode.dart';
import 'json_convert_utils.dart';
import 'options/freezed.dart';

/// [ConvertFreezedMode] generates dart model files
/// that need to build_runner
/// to generate (filename.g.dart and filename.freezed.dart) files
class ConvertFreezedMode implements JsonConvertMode {
  /// [className] is first json file name
  @override
  String className;

  /// [files] is finalized exported codes in string type
  @override
  List<MapEntry<String, String>> files = [];

  /// [json] is decoded json file
  /// if decoded file type of variable is `List<dynamic>`
  /// first element of list select as decoded file!
  @override
  Map<String, dynamic> json;

  /// [options] is [ConvertFreezedMode] methods checkboxes variables
  ConvertFreezedOptions options;

  /// constructor
  ConvertFreezedMode(
    this.json, {
    required this.className,
    required this.options,
  });

  /// [convert] is a main method of [ConvertFreezedMode] class
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
