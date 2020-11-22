import 'dart:convert';

import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_local_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matcher/matcher.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  DrywallCalculatorLocalDataSourceImpl drywallCalculatorLocalDataSource;
  MockSharedPreferences mockSharedPreferences;

  BuildSpecifications specifications;

  setUp(() {
    specifications = BuildSpecifications(long: 6, width: 5);
    mockSharedPreferences = MockSharedPreferences();

    drywallCalculatorLocalDataSource = DrywallCalculatorLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getMaterialOf', () {
    final materials = DrywallMaterialsModel.fromJson(json.decode(fixture('materials.json')));

    test('return materials from shared preferences when match the given specification', () async {
      when(mockSharedPreferences.containsKey(specifications.hashValue)).thenReturn(true);
      when(mockSharedPreferences.getString(specifications.hashValue)).thenReturn(fixture('materials.json'));

      final result = await drywallCalculatorLocalDataSource.getMaterialOf(specifications);

      verify(mockSharedPreferences.containsKey(specifications.hashValue));
      verify(mockSharedPreferences.getString(specifications.hashValue));
      expect(result, materials);
    });

    test('throw a CacheException when materials is not present in the shared preferences', () async {
      when(mockSharedPreferences.containsKey(specifications.hashValue)).thenReturn(false);
      when(mockSharedPreferences.getString(specifications.hashValue)).thenReturn(null);

      final call = drywallCalculatorLocalDataSource.getMaterialOf;

      expect(() => call(specifications), throwsA(TypeMatcher<CacheException>()));
      verifyNever(mockSharedPreferences.getString(specifications.hashValue));
    });
  });

  group('cacheMaterials', () {
    final materials = DrywallMaterialsModel(10.12, 4.92, 1.8, 20.66, 0.24, 13.52, 0.86, 202, 10.08);

    test('call SharePreferences to cache the materials', () async {
      final rawMaterials = json.encode(materials.toJson());

      await drywallCalculatorLocalDataSource.cacheMaterials(specifications, materials);

      verify(mockSharedPreferences.setString(specifications.hashValue, rawMaterials));
    });
  });
}
