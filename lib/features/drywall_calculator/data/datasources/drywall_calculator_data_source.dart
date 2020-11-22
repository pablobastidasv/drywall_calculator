import '../../domain/entity/building_specifications.dart';
import '../../domain/entity/drywall_materials.dart';

abstract class DrywallCalculatorApiDataSource {
  /// Calls the https://us-central1-avalane-staging.cloudfunctions.net/MaterialCalculatorFunction endpoint
  ///
  /// Throws a [ApiExceptions] for all error codes.
  Future<DrywallMaterials> getMaterials(BuildSpecifications specifications);
}