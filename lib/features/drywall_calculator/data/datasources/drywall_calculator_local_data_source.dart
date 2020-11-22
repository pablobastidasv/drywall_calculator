import 'dart:convert';

import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../models/drywall_materials_model.dart';
import '../../domain/entity/building_specifications.dart';

abstract class DrywallCalculatorLocalDataSource {
  /// Throws [CacheException] if no cached for specifications data is present
  Future<DrywallMaterialsModel> getMaterialOf(BuildSpecifications specifications);

  Future<void> cacheMaterials(BuildSpecifications specifications, DrywallMaterialsModel materials);
}

class DrywallCalculatorLocalDataSourceImpl implements DrywallCalculatorLocalDataSource {
  final SharedPreferences sharedPreferences;

  DrywallCalculatorLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheMaterials(BuildSpecifications specifications, DrywallMaterialsModel materials) {
    final rawMaterials = json.encode(materials.toJson());
    return sharedPreferences.setString(specifications.hashValue, rawMaterials);
  }

  @override
  Future<DrywallMaterialsModel> getMaterialOf(BuildSpecifications specifications) {
    final key = specifications.hashValue;
    final cachedMaterialString = _getMaterialsFromLocalStorage(key);
    return _convertToMaterialModel(cachedMaterialString);
  }

  String _getMaterialsFromLocalStorage(String key) {
    if (sharedPreferences.containsKey(key))
      return sharedPreferences.getString(key);
    else
      throw CacheException();
  }

  Future<DrywallMaterialsModel> _convertToMaterialModel(String cachedMaterialString) {
    final mapInfo = json.decode(cachedMaterialString);
    var materialsModel = DrywallMaterialsModel.fromJson(mapInfo);
    return Future.value(materialsModel);
  }
}
