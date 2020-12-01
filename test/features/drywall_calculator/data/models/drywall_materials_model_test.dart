import 'dart:convert';

import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

final materials = DrywallMaterialsModel(10.12, 4.92, 1.8, 20.66, 0.24, 13.52, 0.86, 202, 10.08);
final materials2 = DrywallMaterialsModel(18.36, 8.2, 6, 73.44, 0.77, 50.49, 2.86, 672, 33.59);

void main() {
  test('should be a subclass of DrywallMaterials', () {
    expect(materials, isA<DrywallMaterials>());
  });

  group('Json operations', () {
    test(
      'should return the drywall materials',
      () async {
        final _ = {
          "materials.json": materials,
          "materials2.json": materials2,
        }.forEach((file, expected) {
          final Map<String, dynamic> jsonMap = json.decode(fixture(file));

          final result = DrywallMaterialsModel.fromJson(jsonMap);

          expect(result, expected);
        });
      },
    );

    test('should return the data in json format', () {
      final expected = {
        'angles': 10.12,
        'canals': 4.92,
        'dust_putty': 1.8,
        'omegas_parals': 20.66,
        'paint_keg': 0.24,
        'principals': 13.52,
        'putty': 0.86,
        'screws': 202,
        'sheets': 10.08,
      };

      final result = materials.toJson();

      expect(result, expected);
    });
  });
}
