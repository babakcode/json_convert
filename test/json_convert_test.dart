import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_convert/src/app/conver_classic_mode.dart';
import 'package:json_convert/src/app/convert_freezed_mode.dart';
import 'package:json_convert/src/constants/constants.dart';

void main() {
  test('test camelcase converter', () {
    final classic = ConvertFreezedMode(
      Constants.mapJson2,
      className: "babak-simple",
      options: ConvertFreezedOptions(
        mutable: true,
      )
    );
    classic.convert();
    print("====================");
    print(classic.files);
    // print(classic.convert());
  });
}
