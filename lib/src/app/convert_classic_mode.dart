import 'package:json_convert/src/models/variables_declaration.dart';
import 'package:recase/recase.dart';
import 'json_convert_mode.dart';
import 'json_convert_options.dart';
import 'json_convert_utils.dart';

class ConvertClassicMode implements JsonConvertMode {
  @override
  Map<String, dynamic> json;

  @override
  String className;

  @override
  List<MapEntry<String, String>> files = [];
  ConvertClassicOptions options;

  ConvertClassicMode(this.json,
      {required this.className, required this.options});

  void convert() {
    /// clear .dart files list
    files.clear();

    /// files variables
    final allFilesVariables = JsonConvertUtils.variablesDeclare(json,
        nullable: options.nullable, name: className);

    final allFilesImports =
        JsonConvertUtils.importClasses(json, className: className);

    for (final entry in allFilesVariables) {
      /// get variables
      final variables = entry.value;
      final imports =
          allFilesImports.firstWhere((element) => element.key == entry.key);
      final fileName = entry.key;

      files.add(MapEntry(entry.key,
          '''${options.equatableMixin ? "import 'package:equatable/equatable.dart';" : ""}
${imports.value.map((e) => "import '$e.dart';").join("\n")}

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
    ${_copyWithParentheses(variables).join(",\n    ")}
  }) {
    return ${fileName.pascalCase}(
      ${_copyWith(variables).join(",\n      ")}
    );
  }''' : ""}
  
  ${options.toJson ? '''
Map<String, dynamic> toJson() {
    return {
      ${_toJson(variables).join(",\n\t  ")}
    };
  }
  ''' : ""}
${options.fromJson ? '''
  factory ${fileName.pascalCase}.fromJson(Map<String, dynamic> json) {
    return ${fileName.pascalCase}(
      ${_fromJson(variables).join(",\n\t  ")}
    );
  }
  ''' : ""}
  @override
  String toString() =>
      "${fileName.pascalCase}(${variables.names.map((e) => "$e: \$$e").toList().join(", ")})";
      
  @override
  int get hashCode =>
      Object.hash(${variables.names.join(", ")});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ${fileName.pascalCase} &&
          runtimeType == other.runtimeType &&
          ${variables.names.map((e) => "$e == other.$e").join(" &&\n\t\t  ")};
  
  ${(options.fromJson && options.jsonToList) ? '''static List<${fileName.pascalCase}> jsonToList(List list) =>
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
      //
      list.add("$type${options.nullable ? "?" : ""} $name");
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
      list.add("${options.nullable ? "" : "required"} this.$name");
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

  /// example for [_toJson] method is:
  ///         'id': id,
  //         'name': name,
  List<String> _toJson(VariablesDeclaration variables) {
    List<String> list = [];

    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      list.add("'$name': $name");
    }

    return list;
  }

  /// example for [_fromJson] method is :
  // email: json['email'] as String?,
  // address: json['address'] == null
  // ? null
  //     : Address.fromJson(json['address'] as Map<String, dynamic>),
  /// with nullsafety
  // geo: (json['geo'] as List<dynamic>?)
  //     ?.map((e) => Geo.fromJson(e as Map<String, dynamic>))
  //     .toList(),
  /// without nullsafety
  /// (json['geo'] as List<dynamic>)
  //           .map((e) => Geo.fromJson(e as Map<String, dynamic>))
  //           .toList(),
  ///
  List<String> _fromJson(VariablesDeclaration variables) {
    List<String> list = [];

    for (int index = 0; index < variables.names.length; index++) {
      final name = variables.names.elementAt(index);
      final typeConverted = variables.types.elementAt(index);
      final entryDefault = variables.defaultValues.elementAt(index);

      if (entryDefault.value is Map<String, dynamic>) {
        list.add("$name: ${options.nullable ?

            /// with nullsafety
            "json['$name'] == null\n\t\t? null\n\t\t"
                ": $typeConverted.fromJson(json['$name'] as Map<String, dynamic>)"

            /// not nullsafety
            : "$typeConverted.fromJson(json['$name'] as Map<String, dynamic>)"}");
      } else if (entryDefault.value is List) {
        list.add(
            "$name: (json['$name'] as List<dynamic>${options.nullable ? "?" : ""})\n\t\t"
            "${options.nullable ? "?" : ""}.map((e) => ${name.pascalCase}.fromJson(e as Map<String, dynamic>))\n\t\t"
            ".toList()");
      } else {
        list.add(
            "$name: json['$name'] as ${entryDefault.value.runtimeType}${options.nullable ? "?" : ""}");
      }
    }

    return list;
  }
}

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
