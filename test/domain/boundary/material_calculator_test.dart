import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/boundary/material_calculator.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/repositories/drywall_calculator_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDrywallCalculatorRepository extends Mock
    implements DrywallCalculatorRepository {}

void main() {
  MaterialCalculator usecase;
  MockDrywallCalculatorRepository repository;

  setUp(() {
    repository = MockDrywallCalculatorRepository();
    usecase = MaterialCalculator(repository);
  });

  final specifications = BuildSpecifications(long: 6, width: 5);

  final materials = DrywallMaterials(10.12, 4.92, 1.8, 20.66, 0.24, 13.52, 0.86, 202, 10.08);

  test(
    'should get materials from the repository',
    () async {
      when(repository.getMaterials(specifications))
          .thenAnswer((_) async => Right(materials));

      final result = await usecase(specifications);

      expect(result, Right(materials));
      verify(repository.getMaterials(specifications));
    });
}
