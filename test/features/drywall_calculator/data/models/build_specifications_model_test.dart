import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/build_specification_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('return correct material query param', () {
    final _ = {
      Material.board: "Board",
      Material.panel: "Panel",
    }.forEach((material, expected) {
      final spec = BuildSpecificationsModel(
        long: 6.0,
        width: 5.0,
        job: Job.double_wall,
        material: material,
      );

      expect(spec.materialParam, equals(expected));
    });
  });

  test('return correct job query param', () {
    final _ = {
      Job.double_wall: 'Double',
      Job.simple_wall: 'Simple',
      Job.ceiling: 'Simple',
    }.forEach((job, expected) {
      final spec = BuildSpecificationsModel(
        long: 6.0,
        width: 5.0,
        job: job,
        material: Material.board,
      );

      expect(spec.jobParam, equals(expected));
    });
  });
}
