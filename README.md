# Property Wrapper

Autogenerate code when a global or class variable of a property wrapper type is declared.

## Property Wrapper Declaration

##### Add property_wrapper as a dependency:
```yaml
dependencies:
  property_wrapper: ^1.0.0
```

##### install ProprtyWrapper:

With pub:
``` shell
pub get
```

With flutter:
``` shell
flutter pub get
```

##### Annotate property wrapper class:
To generates code when the variable is global:
``` dart
@TopLevelPropertyWrapper(r'''
${code to generate}
''')
@sealed class ${className}<T> {
...
}
```
To generates code when the variable is a class property:
``` dart
@ClassMemberPropertyWrapper(r'''
${code to generate}
''')
@sealed class ${className}<T> {
...
}
```

Property wrappers have one generic type for the value type that they hold.

##### Specify the code to generate with the parameter of the annotation

In the code to generate, the following markup may be used. These are replaced with the following:
* `${class}` - The name of the containing class. only available for ClassMemberPropertyWrapper.
* `${private}` - If the variable name starts with two _, ${private} is replaced with _, else it is removed. 
* `${name.camelCase}` - The name of the variable in camel case.
* `${name.pascalCase}` - The name of the variable in pascal case.
* `${name.snakeCase}` - The name of the variable in snake case.
* `${type}` - The generic type of the variable.

##### Common usages of markup:
Extend the containing class to add members:
```dart
extension StatusEffectable${type}Extension on ${type} {
...
}
```

Extend to an exsisting class to add members:
```dart
extension ${private}${name.pascalCase}ZoneExtension on Zone {
...
}
```
Add getter
```dart
${type} get ${private}${name.camelCase} => ZoneLocal.get(_${private}${name.camelCase});
```
## Property Value Usage

##### Add property_wrapper_generator and build_runner as dev_dependencies

```yaml
dev_dependencies:
  build_runner: ^1.0.0
  property_wrapper_generator: ^1.0.0
```
##### install dependencies:

With pub:
``` shell
pub get
```

With flutter:
``` shell
flutter pub get
```
##### Add a part file
`dart part '${part}.g.dart';`

##### Declare the variable
If the generated code is to be public:
```dart
final _variable  = Type<int>();
```
If the generated code is to be private:
```dart
final __variable  = Type<int>();
```

##### Run build_runner to generate the part file.

With pub:
```shell
pub run build_runner build
```

With flutter:
```shell
flutter pub run build_runner build
```
