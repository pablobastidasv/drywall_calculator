
import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/core/usecases/usercase.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/repositories/drywall_calculator_repository.dart';


class MaterialCalculator implements UseCase<DrywallMaterials, BuildSpecifications>{
  final DrywallCalculatorRepository repository;

  MaterialCalculator(this.repository);

  @override
  Future<Either<Failure, DrywallMaterials>> call(BuildSpecifications specifications) async {
    return await repository.getMaterials(specifications);
  }
}