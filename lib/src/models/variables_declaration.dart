class VariablesDeclaration {
  List<String> names;
  List<String> types;
  List<MapEntry<String, dynamic>> defaultValues;

  VariablesDeclaration(
    this.names,
    this.types, {
    required this.defaultValues,
  });

  @override
  String toString() => "(names=$names, types=$types, "
      "defaultValues=$defaultValues)";
}
