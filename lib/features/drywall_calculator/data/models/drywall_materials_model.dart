import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';

class DrywallMaterialsModel extends DrywallMaterials {
  DrywallMaterialsModel(double angles, double canals, double dustPutty, double omegasParals, double paintKeg,
      double principals, double putty, int screws, double sheets)
      : super(angles, canals, dustPutty, omegasParals, paintKeg, principals, putty, screws, sheets);

  factory DrywallMaterialsModel.fromJson(Map<String, dynamic> jsonMap) {
    return DrywallMaterialsModel(
        jsonMap['angles'].toDouble(),
        jsonMap['canals'].toDouble(),
        jsonMap['dust_putty'].toDouble(),
        jsonMap['omegas_parals'].toDouble(),
        jsonMap['paint_keg'].toDouble(),
        jsonMap['principals'].toDouble(),
        jsonMap['putty'].toDouble(),
        jsonMap['screws'].toInt(),
        jsonMap['sheets'].toDouble());
  }

  Map<String, dynamic> toJson() {
    return {
      'angles': this.angles,
      'canals': this.canals,
      'dust_putty': this.dustPutty,
      'omegas_parals': this.omegasParals,
      'paint_keg': this.paintKeg,
      'principals': this.principals,
      'putty': this.putty,
      'screws': this.screws,
      'sheets': this.sheets,
    };
  }
}
