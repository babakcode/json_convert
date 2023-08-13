import 'package:flutter_test/flutter_test.dart';
import 'package:json_convert/json_convert.dart';
import 'package:json_convert/src/constants/constants.dart';

void main() {
  test('test camelcase converter', () {
    final classic = ConvertFreezedMode(Constants.mapJson2,
        className: "babak-simple",
        options: ConvertFreezedOptions(
          mutable: true,
        ));
    classic.convert();
  });
}
