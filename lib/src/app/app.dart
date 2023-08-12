import 'dart:convert';
import 'dart:developer';

class JsonConvert {
  String json;
  bool checkAddJsonKey;

  JsonConvert(this.json, {this.checkAddJsonKey = false});

  String? convert() {
    Map<String, dynamic>? jsonData = _validate();
    if (jsonData == null) {
      return null;
    }

    // if(!checkAddJsonKey){
    //   checkAddJsonKey = JsonConvertUtils.checkBetterToAddJsonKey(jsonData);
    // }

    return null;
  }

  Map<String, dynamic>? _validate() {
    try {
      final parse1 = jsonDecode(json.trim());
      Map<String, dynamic> jsonData;

      if (parse1 is List) {
        if (parse1.isEmpty) {
          return null;
        } else if (parse1.first is! Map<String, dynamic>) {
          return null;
        }
        jsonData = parse1.first;
      } else if (parse1 is Map<String, dynamic>) {
        jsonData = parse1;
      } else {
        return null;
      }

      return jsonData;
    } catch (e) {
      log('error in convert', error: e);
    }
    return null;
  }
}
