import 'dart:convert';

import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/build_specification_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

const _authority = 'us-central1-avalane-staging.cloudfunctions.net';
const _path = '/MaterialCalculatorFunction';

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
    Uri uri = _buildUri(specifications);

    var response = await httpClient.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200)
      return DrywallMaterialsModel.fromJson(json.decode(response.body));
    else
      throw ApiException();
  }

  Uri _buildUri(BuildSpecifications specifications) {
    final queryParams = _queryParamsFrom(specifications);
    final uri = Uri.https(_authority, _path, queryParams);
    return uri;
  }

  Map<String, String> _queryParamsFrom(BuildSpecifications specifications) {
    final model = BuildSpecificationsModel.from(specifications);

    return {
      'long': model.long.toString(),
      'width': model.width.toString(),
      'material': model.materialParam,
      'wall_type': model.jobParam,
    };
  }
}
