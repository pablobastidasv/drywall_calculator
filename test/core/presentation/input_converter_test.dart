import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/presentation/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

InputConverter inputConverter;

void main() {
  setUp(() {
    inputConverter = new InputConverter();
  });

  group('stringToUnsignedDouble', () {
    test('given a positive float number, return their integer value', () {
      final _ = {
        "1.5": 1.5,
        "1.0": 1.0,
        "4": 4,
      }.forEach((givenValue, expected) {
        final result = inputConverter.stringToUnsignedDouble(givenValue);
        expect(result, Right(expected));
      });
    });

    test('given a negative value, return an invalid input failure', () {
      final negativeValue = "-1.5";

      final result = inputConverter.stringToUnsignedDouble(negativeValue);

      expect(result, Left(InvalidInputFailure()));
    });

    test('given an invalid value, return an invalid input failure', () {
      final invalidValue = "abc";

      final result = inputConverter.stringToUnsignedDouble(invalidValue);

      expect(result, Left(InvalidInputFailure()));
    });
  });

  group('stringToUnsignedInteger', () {
    test('given a positive number, return their integer representation', () {
      final positiveNumber = "1";
      final expectedNumber = 1;

      final result = inputConverter.stringToUnsignedInteger(positiveNumber);

      expect(result, equals(Right(expectedNumber)));
    });

    test('given a negative number, return a failure', () {
      final negativeNumber = "-123";

      final result = inputConverter.stringToUnsignedInteger(negativeNumber);

      expect(result, Left(InvalidInputFailure()));
    });

    test('given an invalid string, return a failure', () {
      final invalidString = "invalid string";

      final result = inputConverter.stringToUnsignedInteger(invalidString);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
