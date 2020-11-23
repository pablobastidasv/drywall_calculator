import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'dart:convert';

import '../../domain/entity/building_specifications.dart';

final calculatorFunctionUrl = 'https://us-central1-avalane-staging.cloudfunctions.net/MaterialCalculatorFunction';

abstract class DrywallCalculatorApiDataSource {
  /// Calls the https://us-central1-avalane-staging.cloudfunctions.net/MaterialCalculatorFunction endpoint
  ///
  /// Throws a [ApiExceptions] for all error codes.
  Future<DrywallMaterialsModel> getMaterials(BuildSpecifications specifications);
}

class DrywallCalculatorApiDataSourceImpl extends DrywallCalculatorApiDataSource {
  final http.Client httpClient;

  DrywallCalculatorApiDataSourceImpl({
    @required this.httpClient,
  });

  @override
  Future<DrywallMaterialsModel> getMaterials(BuildSpecifications specifications) async {
    var response = await httpClient.get(
      calculatorFunctionUrl,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200)
      return DrywallMaterialsModel.fromJson(json.decode(response.body));
    else
      throw ApiException();
  }
}
