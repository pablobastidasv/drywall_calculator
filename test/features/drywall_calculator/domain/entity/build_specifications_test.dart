import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Hash value is different if object is different', () {
    final BuildSpecifications specA = BuildSpecifications(long: 5, width: 5);
    final BuildSpecifications specB = BuildSpecifications(long: 5, width: 5);
    final BuildSpecifications specC = BuildSpecifications(long: 6, width: 5);
    final BuildSpecifications specD = BuildSpecifications(long: 5, width: 6);
    final BuildSpecifications specE = BuildSpecifications(long: 5, width: 6, job: Job.ceiling);
    final BuildSpecifications specF = BuildSpecifications(long: 5, width: 6, job: Job.double_wall);
    final BuildSpecifications specG =
        BuildSpecifications(long: 5, width: 6, job: Job.double_wall, material: Material.board);

    expect(specA.hashValue, specB.hashValue);
    expect(specE.hashValue, specD.hashValue);
    expect(specC.hashValue, isNot(specB.hashValue));
    expect(specE.hashValue, isNot(specF.hashValue));
    expect(specE.hashValue, isNot(specG.hashValue));
  });

  group('BuildSpecifications', () {
    test('create a new BuildSpecifications with wrong long, return an error', () {
      try {
        BuildSpecifications(long: -1, width: 4);
        fail("Test should never reach this point.");
      } on AssertionError {}
    });

    test('create a new BuildSpecifications with wrong width, return an error', () {
      try {
        BuildSpecifications(long: 5, width: -4);
        fail("Test should never reach this point.");
      } on AssertionError {}
    });
  });

  group('BuildSpecifications.from', () {
    final width = 5.0;
    final long = 6.0;

    final expected = BuildSpecifications(
      long: long,
      width: width,
      material: Material.panel,
      job: Job.ceiling,
    );

    test('create a new BuildSpecification from strings, return the new specification with given values', () {
      final result = BuildSpecifications.from(long, width, "panel", "ceiling");

      expect(result, isNotNull);
      expect(result.isRight(), isTrue);

      expect(result, Right(expected));
    });

    test('create a new BuildSpecification with wrong long, return failure', () {
      final result = BuildSpecifications.from(-4, width, "panel", "ceiling");

      expect(result.isLeft(), isTrue);
      expect(result, equals(Left(InvalidArgumentFailure())));
    });

    test('create a new BuildSpecification with wrong width, return failure', () {
      final result = BuildSpecifications.from(long, -4, "panel", "ceiling");

      expect(result.isLeft(), isTrue);
      expect(result, equals(Left(InvalidArgumentFailure())));
    });

    test('create a new BuildSpecification with wrong material, return failure', () {
      final result = BuildSpecifications.from(long, width, "bricks", "ceiling");

      expect(result.isLeft(), isTrue);
      expect(result, equals(Left(InvalidArgumentFailure())));
    });

    test('create a new BuildSpecification with wrong job, return failure', () {
      final result = BuildSpecifications.from(long, width, "board", "floor");

      expect(result.isLeft(), isTrue);
      expect(result, equals(Left(InvalidArgumentFailure())));
    });

    test('create a new BuildSpecification with job in different case, return the object', () {
      final result = BuildSpecifications.from(long, width, "panel", "Ceiling");

      expect(result.isRight(), isTrue);
      expect(result, equals(Right(expected)));
    });

    test('create a new BuildSpecification with material in different case, return the object', () {
      final result = BuildSpecifications.from(long, width, "PaNel", "ceiling");

      expect(result.isRight(), isTrue);
      expect(result, equals(Right(expected)));
    });
  });
}
