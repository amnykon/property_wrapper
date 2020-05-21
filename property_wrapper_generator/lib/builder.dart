import 'package:build/build.dart';

import 'package:property_wrapper_generator/top_level_property_wrapper_generator.dart';
import 'package:property_wrapper_generator/class_member_property_wrapper_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder propertyWrapper(BuilderOptions _) =>
  SharedPartBuilder([TopLevelPropertyWrapperGenerator(), ClassMemberPropertyWrapperGenerator()], 'property_wrapper');