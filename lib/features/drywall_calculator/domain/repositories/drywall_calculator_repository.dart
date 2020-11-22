import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';

abstract class DrywallCalculatorRepository {
  Future<Either<Failure, DrywallMaterials>> getMaterials(BuildSpecifications specifications);
}
