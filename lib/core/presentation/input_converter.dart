import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';

class InputConverter {

  stringToUnsignedInteger(String positiveNumber) {
    try {
      var parsedNumber = int.parse(positiveNumber);
      if (parsedNumber < 0) throw FormatException();
      return Right(parsedNumber);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  stringToUnsignedDouble(String positiveNumber) {
    try {
      var doubleValue = double.parse(positiveNumber);
      if (doubleValue < 0) throw FormatException();
      return Right(doubleValue);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
