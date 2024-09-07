// class Equatable {
//   const Equatable();
// }
// never import any flutter package as ui will cause error
import "../macros/macros.dart"; //only directive approch no flutter package

import 'dart:async';


/// The `Equatable` class is a Dart macro used for automatically implementing equality
/// and hashCode methods for classes. This macro is particularly useful for reducing boilerplate
/// code and ensuring consistent esquality checks across your Dart classes.
///
/// The `Equatable` macro implements both `ClassDeclarationsMacro` and `ClassDefinitionMacro`
/// to provide functionality for modifying class declarations and definitions.
///
/// It applies the `@Equatable` annotation to a class, generating the necessary code
/// for equality comparison based on the fields of the class.
///
/// The `stringify` parameter controls whether a `toString` method is generated for the class:
/// - If `stringify` is `true`, the generated `toString` method will include the values of
///   the fields in its output.
/// - If `stringify` is `false` (the default), the `toString` method will not include field values.
///
/// This macro is part of the `equatable_macro` package and provides a clean and efficient
/// way to make classes equatable without manually overriding `==` and `hashCode` methods.
///
/// ## Usage
/// To use the `Equatable` macro, annotate your class with `@Equatable()` as follows:
///
/// ```dart
/// import 'package:equatable_macro/equatable_macro.dart';
///
/// @Equatable(stringify: true) // Set stringify to true to include field values in toString
/// class Example {
///   final int id;
///   final String name;
///
///   const Example(this.id, this.name);
/// }
/// ```
///
/// ## Parameters
/// - `stringify` (optional, defaults to `false`): If `true`, the generated `toString` method
///   will include the values of the fields in its output. If `false`, the `toString` method
///   will not include field values.
///
/// ## Implementation
/// The `Equatable` macro modifies the class definition to include the following:
/// - An overridden `==` operator that compares instances based on their field values.
/// - An overridden `hashCode` getter that computes a hash code based on the field values.
/// - An optional `toString` method if `stringify` is set to `true`. The `toString` method
///   will return a string representation of the class including field values.
///
/// ## Example
/// ```dart
/// import 'package:equatable_macro/equatable_macro.dart';
///
/// @Equatable(stringify: true)
/// class Example {
///   final int id;
///   final String name;
///
///   const Example(this.id, this.name);
/// }
///
/// void main() {
///   var a = Example(1, 'a');
///   var b = Example(1, 'a');
///   var c = Example(2, 'b');
///
///   print(a == b); // true
///   print(a == c); // false
///   print(a.toString()); // Example(id: 1, name: a)
/// }
/// ```
///
/// This macro is intended to simplify the process of making Dart classes equatable
/// and improve code maintainability by automating the implementation of equality
/// checks and hash code computations. The `stringify` parameter provides flexibility
/// for including or excluding field values in the `toString` representation.


macro class Equatable implements ClassDeclarationsMacro, ClassDefinitionMacro {
  /// Indicates whether the `toString` method should include field values.
  /// Defaults to `false`.
  final bool? _stringify;

  /// Creates an instance of the `Equatable` macro.
  ///
  /// - `stringify`: If `true`, the generated `toString` method will include field values.
  ///   If `false`, the `toString` method will not include field values. Defaults to `false`.
  const Equatable({ bool? stringify, }) : _stringify = stringify;
  ///! For Future Release
  bool get stringify {
    return _stringify  ?? _defaultstringify;
  }
  ///! For Future Release
  static  bool _defaultstringify = false;
  ///! For Future Release
  set stringify(bool stringify) { 
    _defaultstringify=stringify;
    stringify = stringify;}
  
  MethodDeclaration? equality(List<MethodDeclaration> methods ,String op) {
    return
     methods.firstWhereOrNull(
      (m) => m.identifier.name == op,
    );
    
  }


  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz, MemberDeclarationBuilder builder)async {
  // Assuming `clazz.identifier.name` gives you the class name as a string
final String className = clazz.identifier.name;

    final boolean = await  builder.resolveIdentifier(Uri.parse('dart:core'), 'bool');
      final integer = await builder.resolveIdentifier(Uri.parse('dart:core'), 'int');
      final string = await builder.resolveIdentifier(Uri.parse('dart:core'), 'String');
    final defaultClassMethodHashCode = await builder.methodsOf(clazz).then((value)=>value.where((elements)=>(elements.isGetter && elements.identifier.name == "hashCode" ))) ; 
    final defaultClassMethodEqualEqual = await builder.methodsOf(clazz).then((value)=>value.where((elements)=>(elements.isOperator && elements.identifier.name == "=="))) ; 
    final defaultClassMethodToString = await builder.methodsOf(clazz).then((value)=>value.where((elements)=>( elements.identifier.name == "toString"))) ; 
     
    if (defaultClassMethodHashCode.isNotEmpty ) { 
    for (var element in defaultClassMethodHashCode ) {
                  builder.report(  Diagnostic( DiagnosticMessage(
              'A default `${element.identifier.name}` method was created with `@Equatable()` Macro',
              target: element.asDiagnosticTarget,
            ),
            Severity.error,
       
          correctionMessage:' * Remove This `${element.identifier.name}` method  *'));
            
      
    }

    }

    
    if (defaultClassMethodEqualEqual.isNotEmpty ) { 
    for (var element in defaultClassMethodEqualEqual ) {
                 builder.report(  Diagnostic( DiagnosticMessage(
              'The name `${element.identifier.name}` is already defined and it is created by `@Equatable()` Macro',
              target: element.asDiagnosticTarget,
            ),
            Severity.error,
       
          correctionMessage:' * Remove This `${element.identifier.name}` method or Try renaming the declarations*'));
           
      
    }

    }


    if (defaultClassMethodToString.isNotEmpty && stringify) { 
    for (var element in defaultClassMethodToString ) {
                 builder.report(  Diagnostic( DiagnosticMessage(
              'The name `${element.identifier.name}` is already defined and it is created by `@Equatable()` Macro',
              target: element.asDiagnosticTarget,
            ),
            Severity.error,
       
          correctionMessage:' * Remove This `${element.identifier.name}` method or Try renaming the declarations*'));
           
      
    }

    }

    return builder.declareInType(DeclarationCode.fromParts(['  external ', boolean, ' operator==(', ' covariant ', '${className}' ' other);\n',
    '  external ', integer, ' get hashCode;\n', //if nothing in fields then hash code will be 0 , that's not good, change full logic
    if (stringify) ...['  external ', string, ' toString();'],

    ]));
  }
  
  @override
  Future<void> buildDefinitionForClass(ClassDeclaration clazz, TypeDefinitionBuilder builder) async {

 final methods = await builder.methodsOf(clazz);


final object    = await builder.resolveIdentifier(Uri.parse('dart:core'), 'Object');  

final equalsMethod = (equality(methods,"==") == null)? null :await  builder.buildMethod(equality(methods,"==")!.identifier);
final hashCodeMethod =  (equality(methods,'hashCode') == null)? null :await   builder.buildMethod(equality(methods,'hashCode')!.identifier);
 final toStringMethod =  (equality(methods,'toString') == null)? null :await   builder.buildMethod(equality(methods,'toString')!.identifier);
 var allFields = <FieldDeclaration>[];
 superclassOf(ClassDeclaration clazz) async {  final superclassType = clazz.superclass != null
      ? await builder.typeDeclarationOf( clazz.superclass!.identifier): null;
        return superclassType is ClassDeclaration ? superclassType : null;
       }

allFields.addAll(await builder.fieldsOf(clazz));
 var superclass = await superclassOf(clazz);

while (superclass != null && superclass.identifier.name != 'Object') {
  allFields.addAll(await builder.fieldsOf(superclass));
  superclass = await superclassOf(superclass);
}
allFields = allFields..removeWhere((f) => f.hasStatic); //!   modify in future
final fields       = allFields;
final fieldNames = fields.map((f) => f.identifier.name); 
final lastField = fieldNames.lastOrNull; //error here modify it as nullable
final toStringFields = fields.map((field) {
      return '${field.type.isNullable ? 'if (${field.identifier.name} != null)' : ''} "${field.identifier.name}: \${${field.identifier.name}.toString()}", ';
    });
if (stringify) {

  toStringMethod?.augment(FunctionBodyCode.fromParts([ '=> "',
          clazz.identifier.name,
          '(\${[',
          ...toStringFields,
          '].join(", ")})',
          '";',]));
}
 // if only this part 
   if (fields.isEmpty || lastField == null) {
       equalsMethod?.augment(
        FunctionBodyCode.fromParts(
          [
             '=>'
      'other != null ;\n '
     
          ],
        ),      
      );
    }

   if (equalsMethod ==null || hashCodeMethod == null) {
   return;
   }

   if(lastField != null) {
     equalsMethod.augment(
      FunctionBodyCode.fromParts(
        [
           
          '=>',  
          for (final field in fieldNames)
           
            ...[ 'other.$field == $field', if (field != lastField) ' && '], //that will give error here
          ';\n',
         
        ],
         ),      
    );
   }



     hashCodeMethod.augment(
      FunctionBodyCode.fromParts(
        [
          '=> ',
          object,
          '.hashAll',
          '([',
        
          'runtimeType,',
          fieldNames.join(', '),
          ']',
          
          ');',
        ],
      ),
    );

   
}

}



extension IterableExtensionX<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

}