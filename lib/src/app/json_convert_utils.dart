import 'package:json_convert/src/models/variables_declaration.dart';
import 'package:recase/recase.dart';

/// ths class generated to help generation of dart files
class JsonConvertUtils {
  /// [checkBetterToAddJsonKey] is used and true when json key includes unusual
  /// name.
  /// As an example [_id] is an unusual name and not camelcase
  /// In this case, the value of the [checkBetterToAddJsonKey] method is true
  ///
  /// This function runs recursive when reaches to map<String, dynamic>
  /// type data to detection all of the variables names as json key
  static bool checkBetterToAddJsonKey(Map<String, dynamic> jsonData) {
    for (final key in jsonData.keys) {
      if (key.contains("_")) {
        return true;
      }
      final value = jsonData[key];
      if (value is Map<String, dynamic>) {
        if (checkBetterToAddJsonKey(value)) {
          return true;
        }
      } else if (value is List) {
        if (value.isNotEmpty) {
          if (value.first is Map<String, dynamic>) {
            if (checkBetterToAddJsonKey(value.first)) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  /// [importClasses] function to generate imports of dart files
  /// This function runs recursive to get all of the json files
  /// and generate imports for themself of dart files and split that
  /// export example
  /// import 'address.dart';
  /// import 'company.dart';
  /// saves on List<String> inside `MapEntry`
  ///
  /// name of classes saves on String inside `MapEntry'
  static List<MapEntry<String, List<String>>> importClasses(Map json,
      {required String className,
      List<MapEntry<String, List<String>>>? recursiveImports}) {
    /// imports of current class
    List<String> imports = [];

    /// current entry
    final currentEntry = MapEntry<String, List<String>>(className, imports);

    /// add current entry for recursive list
    recursiveImports ??= [];
    recursiveImports.add(currentEntry);

    for (final String key in json.keys) {
      final value = json[key];
      // detect file types
      if (value is Map<String, dynamic>) {
        String import = key.snakeCase;
        if (!imports.contains(import)) {
          imports.add(import);
        }

        importClasses(
          value,
          className: key,
          recursiveImports: recursiveImports,
        );
      } else if (value is List<dynamic>) {
        if (value.isNotEmpty && value.first is Map) {
          String import = key.snakeCase;
          if (!imports.contains(import)) {
            imports.add(import);
          }

          importClasses(
            value.first,
            className: key,
            recursiveImports: recursiveImports,
          );
        }
      }
    }

    return recursiveImports;
  }

  /// [variablesDeclare] runs recursive to get all variables of each files
  static List<MapEntry<String, VariablesDeclaration>> variablesDeclare(
      Map<String, dynamic> json,
      {required String name,
      bool nullable = false,
      List<MapEntry<String, VariablesDeclaration>>? recursiveVariables}) {
    List<String> names = [], types = [];
    List<MapEntry<String, dynamic>> defaultTypes = [];

    /// current file codes
    final currentFileVariables = MapEntry<String, VariablesDeclaration>(
        name,
        VariablesDeclaration(
          names,
          types,
          defaultValues: defaultTypes,
        ));

    /// all files variables
    recursiveVariables ??= [];
    recursiveVariables.add(currentFileVariables);

    for (final key in json.keys) {
      String varType = "${json[key].runtimeType}";
      defaultTypes.add(MapEntry<String, dynamic>(key, json[key]));

      final varName = generateVariableDeDuplicatedName(key, names);
      final valueOfEntity = json[key];

      if (valueOfEntity is Map<String, dynamic>) {
        varType = key.pascalCase;
        variablesDeclare(
          valueOfEntity,
          name: key,
          recursiveVariables: recursiveVariables,
          nullable: nullable,
        );
      } else if (valueOfEntity is List<dynamic>) {
        if (valueOfEntity.isEmpty) {
          varType = "List<Null>";
        } else {
          final firstElementOfList = valueOfEntity.first;
          if (firstElementOfList is Map<String, dynamic>) {
            varType = "List<${key.pascalCase}>";
            variablesDeclare(
              valueOfEntity.first,
              name: key,
              recursiveVariables: recursiveVariables,
              nullable: nullable,
            );
          } else {
            varType = "List<${valueOfEntity.runtimeType}>";
          }
        }
      }
      names.add(varName);
      types.add(varType);
    }

    return recursiveVariables;
  }

  /// [generateVariableDeDuplicatedName] runs when variable names are same and
  /// splits these with addition increment number at the end of the variable name
  static String generateVariableDeDuplicatedName(String key, List<String> names,
      {int times = 0}) {
    key = key.camelCase;
    if (names.contains(key)) {
      times++;
      String newKey = "$key$times";
      if (names.contains(newKey)) {
        key = generateVariableDeDuplicatedName(key, names, times: times);
      } else {
        key = newKey;
      }
    }
    return key;
  }
}
