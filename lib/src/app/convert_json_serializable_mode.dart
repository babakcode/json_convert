import 'package:json_convert/json_convert.dart';
import 'package:json_convert/src/app/json_convert_options.dart';
import 'package:json_convert/src/models/variables_declaration.dart';
import 'package:recase/recase.dart';
import 'json_convert_mode.dart';

class ConvertJsonSerializableMode implements JsonConvertMode{
  @override
  String className;

  @override
  List<MapEntry<String, String>> files = [];

  @override
  Map<String, dynamic> json;

  ConvertJsonSerializableOptions options;

  ConvertJsonSerializableMode(
      this.json, {
        required this.className,
        required this.options,
      });

  void convert() {
    /// clear .dart files list
    files.clear();

    /// files variables
    final allFilesVariables = JsonConvertUtils.variablesDeclare(json, name: className);

    final allFilesImports =
    JsonConvertUtils.importClasses(json, className: className);

    for (final entry in allFilesVariables) {
      /// get variables
      final variables = entry.value;
      final imports =
      allFilesImports.firstWhere((element) => element.key == entry.key);
      final fileName = entry.key;

      files.add(MapEntry(entry.key,
          '''import 'package:json_annotation/json_annotation.dart';
${options.equatableMixin ? "import 'package:equatable/equatable.dart';" : ""}
${imports.value.map((e) => "import '../$e/$e.dart';").join("\n")}
${"part '${fileName.snakeCase}.g.dart';"}

@JsonSerializable()
class ${fileName.pascalCase} ${options.equatableMixin ? "with EquatableMixin" : ""}{
  ${"${_defaultVariables(variables).join(";\n  ")};"}
  
  ${fileName.pascalCase}({
   ${_variablesInsideParentheses(variables).join(",\n   ")},
  });
${options.equatableMixin ? '''
  
  @override
  List<Object?> get props =>
      [${variables.names.join(", ")}];''' : ""}

  ${options.copyWith ? '''
${fileName.pascalCase} copyWith({
    ${_copyWithParentheses(variables).join(",\n    ")},
  }) {
    return ${fileName.pascalCase}(
      ${_copyWith(variables).join(",\n      ")},
    );
  }''' : ""}

  factory ${fileName.pascalCase}.fromJson(Map<String, dynamic> json) =>
      _\$${fileName.pascalCase}FromJson(json);

  Map<String, dynamic> toJson() => _\$${fileName.pascalCase}ToJson(this);

  @override
  String toString() =>
      "${fileName.pascalCase}(${variables.names.map((e) => "$e: \$$e").toList().join(", ")},)";
      
  @override
  int get hashCode =>
      Object.hash(${variables.names.join(", ")},);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${fileName.pascalCase} &&
          runtimeType == other.runtimeType &&
          ${variables.names.map((e) => "$e == other.$e").join(" &&\n\t\t  ")};
  
  ${options.jsonToList ? '''static List<${fileName.pascalCase}> jsonToList(List list) =>
    list.map((e) => ${fileName.pascalCase}.fromJson(e as Map<String, dynamic>))
    .toList();   
''' : ""} 
}
'''));
    }
  }

  /// example for [_defaultVariables] is
  // int? id;
  // String? name;
  // String? username;
  List<String> _defaultVariables(VariablesDeclaration variables) {
    List<String> list = [];
    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      final type = variables.types.elementAt(index);
      final entry = variables.defaultValues.elementAt(index);
      //
      list.add("${options.jsonKey? "@JsonKey(name: '${entry.key}') " : ""}$type? $name");
    }
    return list;
  }

  /// the [_variablesInsideParentheses] method for declare variables
  /// inside constructor of class
  /// for example:
  /// (
  /// this.name,
  /// this.family,
  /// )
  List<String> _variablesInsideParentheses(VariablesDeclaration variables) {
    List<String> list = [];
    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      list.add("this.$name");
    }
    return list;
  }

  List<String> _copyWithParentheses(VariablesDeclaration variables) {
    List<String> list = [];

    for (int index = 0; index < variables.names.length; index++) {
      final type = variables.types.elementAt(index);
      final name = variables.names.elementAt(index);
      list.add("$type? $name");
    }

    return list;
  }

  /// example for [_copyWith] method is:
  ///       id: id ?? this.id,
  ///       name: name ?? this.name,
  List<String> _copyWith(VariablesDeclaration variables) {
    List<String> list = [];

    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      list.add("$name: $name ?? this.$name");
    }

    return list;
  }

}

class ConvertJsonSerializableOptions extends JsonConvertOptions{

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

  factory ConvertJsonSerializableOptions.fromJsonSave(Map<String, dynamic> json) {
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
      "type" : type,
    };
  }
}