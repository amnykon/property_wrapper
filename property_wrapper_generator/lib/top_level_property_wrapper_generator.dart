import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:recase/recase.dart';

class TopLevelPropertyWrapperGenerator extends Generator {
  @override Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = '';
    final units = library.element.units;
    final topLevelVariables = units.expand((element) => element.topLevelVariables);
    for (final variable in topLevelVariables) {
      final metadata = variable.type.element.metadata.map((metadata)=>metadata.computeConstantValue());
      final propertyWrapper = metadata.toList().firstWhere(
        (element) => element.type.getDisplayString() == 'TopLevelPropertyWrapper',
        orElse: ()=>null,
      );
      if (propertyWrapper == null) {
        continue;
      }

      final type = RegExp(r'(?<=<)(.*)(?=>)').firstMatch(variable.type.getDisplayString()).group(0);
      final name = variable.name.startsWith('_') ? variable.name.substring(1) : variable.name;
      final private = name.startsWith('_') ? '_' : '';

      final code = propertyWrapper.getField('code').toStringValue()
        .replaceAll(r'${private}', private)
        .replaceAll(r'${name.camelCase}', name.camelCase)
        .replaceAll(r'${name.pascalCase}', name.pascalCase)
        .replaceAll(r'${name.snakeCase}', name.snakeCase)
        .replaceAll(r'${type}', type);

      result = '$result\n//$variable\n\n$code';
    }
    return result;
  }
}
