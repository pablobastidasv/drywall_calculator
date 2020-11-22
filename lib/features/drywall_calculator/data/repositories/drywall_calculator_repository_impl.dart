import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:meta/meta.dart';

import '../../../../core/platform/network_info.dart';
import '../datasources/drywall_calculator_data_source.dart';
import '../datasources/drywall_calculator_local_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entity/building_specifications.dart';
import '../../domain/entity/drywall_materials.dart';
import '../../domain/repositories/drywall_calculator_repository.dart';

class DrywallCalculatorRepositoryImpl extends DrywallCalculatorRepository {
  final DrywallCalculatorApiDataSource apiDataSource;
  final DrywallCalculatorLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DrywallCalculatorRepositoryImpl({
    @required this.apiDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, DrywallMaterials>> getMaterials(BuildSpecifications specifications) async {
    if (await networkInfo.isConnected) {
      return await _connectToApiAndGetMaterials(specifications);
    } else {
      return await _getMaterialsFromCache(specifications);
    }
  }

  Future<Either<Failure, DrywallMaterials>> _connectToApiAndGetMaterials(BuildSpecifications specifications) async {
    try {
      return await _getMaterialsAndCache(specifications);
    } on ApiException {
      return Left(ApiFailure());
    }
  }

  Future<Right<Failure, DrywallMaterials>> _getMaterialsAndCache(BuildSpecifications specifications) async {
    final drywallMaterials = await apiDataSource.getMaterials(specifications);
    localDataSource.cacheMaterials(specifications, drywallMaterials);
    return Right(drywallMaterials);
  }

  Future<Either<Failure, DrywallMaterials>> _getMaterialsFromCache(BuildSpecifications specifications) async {
    try {
      return await _extractMaterialsFromCache(specifications);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  Future<Right<Failure, DrywallMaterials>> _extractMaterialsFromCache(BuildSpecifications specifications) async {
    final cachedMaterials = await localDataSource.getMaterialOf(specifications);
    return Right(cachedMaterials);
  }
}
