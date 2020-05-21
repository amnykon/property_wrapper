import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:recase/recase.dart';

class ClassMemberPropertyWrapperGenerator extends Generator {
  @override Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var result = '';
    for (final kind in library.classes) {
      for (final variable in kind.fields) {
        final metadata = variable.type.element?.metadata?.map((metadata)=>metadata.computeConstantValue());
        if (metadata == null) {
          continue;
        }
        final propertyWrapper = metadata.toList().firstWhere(
          (element) => element.type.getDisplayString() == 'ClassMemberPropertyWrapper',
          orElse: ()=>null,
        );
        if (propertyWrapper == null) {
          continue;
        }

        final type = RegExp(r'(?<=<)(.*)(?=>)').firstMatch(variable.type.getDisplayString()).group(0);
        final name = variable.name.startsWith('_') ? variable.name.substring(1) : variable.name;
        final private = name.startsWith('_') ? '_' : '';

        final code = propertyWrapper.getField('code').toStringValue()
          .replaceAll(r'${class}', kind.name)
          .replaceAll(r'${private}', private)
          .replaceAll(r'${name.camelCase}', name.camelCase)
          .replaceAll(r'${name.pascalCase}', name.pascalCase)
          .replaceAll(r'${name.snakeCase}', name.snakeCase)
          .replaceAll(r'${type}', type);

        result = '$result\n//$variable\n\n$code';
      }
    }
    return result;
  }
}
