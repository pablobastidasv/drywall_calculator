import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Hash value is different if object is different', () {
    final BuildSpecifications specA = BuildSpecifications(long: 5, width: 5);
    final BuildSpecifications specB = BuildSpecifications(long: 5, width: 5);
    final BuildSpecifications specC = BuildSpecifications(long: 6, width: 5);
    final BuildSpecifications specD = BuildSpecifications(long: 5, width: 6);
    final BuildSpecifications specE = BuildSpecifications(long: 5, width: 6, job: Job.ceiling);
    final BuildSpecifications specF = BuildSpecifications(long: 5, width: 6, job: Job.double_wall);
    final BuildSpecifications specG = BuildSpecifications(long: 5, width: 6, job: Job.double_wall, material: Material.board);

    expect(specA.hashValue, specB.hashValue);
    expect(specE.hashValue, specD.hashValue);
    expect(specC.hashValue, isNot(specB.hashValue));
    expect(specE.hashValue, isNot(specF.hashValue));
    expect(specE.hashValue, isNot(specG.hashValue));
  });
}