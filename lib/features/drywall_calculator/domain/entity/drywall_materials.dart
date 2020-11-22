import 'package:equatable/equatable.dart';

class DrywallMaterials extends Equatable {
  final double angles;
  final double canals;
  final double dustPutty;
  final double omegasParals;
  final double paintKeg;
  final double principals;
  final double putty;
  final int screws;
  final double sheets;

  DrywallMaterials(
      this.angles,
      this.canals,
      this.dustPutty,
      this.omegasParals,
      this.paintKeg,
      this.principals,
      this.putty,
      this.screws,
      this.sheets
  );

  @override
  List<Object> get props => [
    angles, canals, dustPutty, omegasParals, paintKeg,
    principals, putty, screws, sheets
  ];
}
