import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/core/usecases/usercase.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';

class MaterialCalculator implements UseCase<DrywallMaterials, BuildSpecifications> {
  static final kgOfDustPuttyPerLump = 25;
  static final kgOfPuttyPerKeg = 28;

  static final simpleWallFactor = 1;
  static final doubleWallFactor = 2;

  static final paintKegPerArea = 130; // 1 cuñete por 130 m2
  static final kgOfPuttyPerArea = 0.8;
  static final kgOfDustPuttyPerArea = 1.5;

  static final screwsPerSheetOfPanel = 20.0;
  static final screwsPerSheetOfBoard = 30.0;

  static final distanceBetweenPrincipals = 0.9; // 90 am
  static final distanceBetweenOmegasPanel = 0.61; // 90 am
  static final distanceBetweenOmegasBoard = 0.41; // 90 am

  static final extraPerJoin = 0.3; // 30 cm

  static final drywallWidth = 1.22; // meters
  static final drywallLong = 2.44; // meters
  static final drywallUnitArea = drywallWidth * drywallLong; // meters

  @override
  Future<Either<Failure, DrywallMaterials>> call(BuildSpecifications specifications) async {
    var materials = DrywallMaterials(
      calculateAngles(specifications),
      calculateCanals(specifications),
      calculateDustPutty(specifications),
      calculateOmegasParals(specifications),
      calculatePaintKeg(specifications),
      calculatePrincipals(specifications),
      calculatePutty(specifications),
      calculateScrews(specifications),
      calculateSheets(specifications),
    );

    return Right(materials);
  }

  double _perimeter(double long, double width) {
    return (long * 2) + (width * 2);
  }

  double _numberOfJoins(double anglesWithoutJoins) {
    return anglesWithoutJoins.floorToDouble() * (extraPerJoin / drywallLong);
  }

  double _round(double value) {
    var _value = value * 100;
    return _value.roundToDouble() / 100;
  }

  double _area(double width, double long) {
    return width * long;
  }

  _wallTypeFactor(Job job) {
    return job == Job.double_wall ? doubleWallFactor : simpleWallFactor;
  }

  double _distanceBasedOnMaterial(Material material) {
    return material == Material.board ? distanceBetweenOmegasBoard : distanceBetweenOmegasPanel;
  }

  double? _roundCeil(number, decimals) {
    var tenFactor = pow(10, decimals);
    var bumped = number * tenFactor;
    var ceiledValue = bumped.ceil();
    return ceiledValue / tenFactor;
  }

  double _screwsPerSheet(Material material) {
    return material == Material.board ? screwsPerSheetOfBoard : screwsPerSheetOfPanel;
  }

  calculateAngles(BuildSpecifications specifications) {
    var qtyOfAnglesWithoutJoins = _perimeter(specifications.long, specifications.width) / drywallLong;
    if (qtyOfAnglesWithoutJoins > 1) {
      var joins = _numberOfJoins(qtyOfAnglesWithoutJoins);
      qtyOfAnglesWithoutJoins += joins;
    }
    return _round(qtyOfAnglesWithoutJoins);
  }

  calculateCanals(BuildSpecifications specifications) {
    var _qtyOfCanals = max(specifications.long, specifications.width) / drywallLong;
    _qtyOfCanals *= 2;
    return _round(_qtyOfCanals);
  }

  calculateDustPutty(BuildSpecifications specifications) {
    var _dustPuttyPerArea = _area(specifications.long, specifications.width) * kgOfDustPuttyPerArea;
    var _lumpOfDustPuttyPerArea = _dustPuttyPerArea / kgOfDustPuttyPerLump;
    return _lumpOfDustPuttyPerArea * _wallTypeFactor(specifications.job);
  }

  calculateOmegasParals(BuildSpecifications specifications) {
    var _numberOfLines =
        (max(specifications.width, specifications.long) / _distanceBasedOnMaterial(specifications.material))
            .floorToDouble();
    var _numberOmegasPerLine = min(specifications.long, specifications.long) / drywallLong;

    if (_numberOmegasPerLine > 1) {
      var _joinsPerLine = _numberOfJoins(_numberOmegasPerLine);
      _numberOmegasPerLine += _joinsPerLine;
    }

    var _omegas = _numberOfLines * _numberOmegasPerLine;
    return _round(_omegas);
  }

  calculatePaintKeg(BuildSpecifications specifications) {
    var rawValue = _area(specifications.long, specifications.width) / paintKegPerArea;
    rawValue *= _wallTypeFactor(specifications.job);
    return _roundCeil(rawValue, 2);
  }

  calculatePrincipals(BuildSpecifications specifications) {
    var numberOfLines = (min(specifications.long, specifications.width) / distanceBetweenPrincipals).floorToDouble();
    var numberPerLine = max(specifications.long, specifications.width) / drywallLong;
    if (numberPerLine > 1) {
      var joinsPerLine = _numberOfJoins(numberPerLine);
      numberPerLine += joinsPerLine;
    }

    var numberOfPrincipals = numberOfLines * numberPerLine;
    return numberOfPrincipals.roundToDouble();
  }

  calculatePutty(BuildSpecifications specifications) {
    var kgOfPutty = _area(specifications.width, specifications.long) * kgOfPuttyPerArea;
    var kegOfPutty = kgOfPutty / kgOfPuttyPerKeg;
    kegOfPutty *= _wallTypeFactor(specifications.job);
    return kegOfPutty.roundToDouble();
  }

  int calculateScrews(BuildSpecifications specifications) {
    var screws = calculateSheets(specifications) * _screwsPerSheet(specifications.material);
    return screws.ceil();
  }

  calculateSheets(BuildSpecifications specifications) {
    var numberOfSheets = _area(specifications.width, specifications.long) / drywallUnitArea;
    numberOfSheets *= _wallTypeFactor(specifications.job);
    return _round(numberOfSheets);
  }
}
