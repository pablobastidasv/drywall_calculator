import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';

class DrywallMaterialsModel extends DrywallMaterials {
  DrywallMaterialsModel(double angles, double canals, double dustPutty, double omegasParals, double paintKeg,
      double principals, double putty, int screws, double sheets)
      : super(angles, canals, dustPutty, omegasParals, paintKeg, principals, putty, screws, sheets);

  factory DrywallMaterialsModel.fromJson(Map<String, dynamic> jsonMap) {
    return DrywallMaterialsModel(
        jsonMap['angles'],
        jsonMap['canals'],
        jsonMap['dust_putty'],
        jsonMap['omegas_parals'],
        jsonMap['paint_keg'],
        jsonMap['principals'],
        jsonMap['putty'],
        jsonMap['screws'],
        jsonMap['sheets']);
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
