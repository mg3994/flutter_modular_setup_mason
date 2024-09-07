extension NumParseX on Comparable {
  double? toDoubleValue() {
    if (this is double) {
      return this as double;
    } else if (this is int) {
      return (this as int).toDouble();
    } else if (this is num) {
      return (this as num).toDouble();
    } else if (this is String) {
      final stringValue = this as String;
      // Use regex to match valid double format
      final regex = RegExp(r'^-?\d+(\.\d+)?$');
      if (regex.hasMatch(stringValue)) {
        return double.tryParse(stringValue);
      }
    }
    return null; // Returning null if the conversion fails
  }
}

// void main() {
//   var x = "14";

//   print(x.toDoubleValue()); // Outputs: 14.0
// }
