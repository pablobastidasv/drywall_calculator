import '../models/drywall_materials_model.dart';
import '../../domain/entity/building_specifications.dart';

abstract class DrywallCalculatorLocalDataSource {
  /// Throws [CacheException] if no cached for specifications data is present
  Future<DrywallMaterialsModel> getMaterialOf(BuildSpecifications specifications);

  Future<void> cacheMaterials(BuildSpecifications specifications, DrywallMaterialsModel materials);
}
