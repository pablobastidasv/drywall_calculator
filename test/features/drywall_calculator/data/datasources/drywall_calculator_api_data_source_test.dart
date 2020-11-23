import 'dart:convert';

import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_api_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  DrywallCalculatorApiDataSourceImpl drywallCalculatorApiDataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = new MockHttpClient();

    drywallCalculatorApiDataSource = new DrywallCalculatorApiDataSourceImpl(httpClient: mockHttpClient);
  });

  group('getMaterials', () {
    final BuildSpecifications specifications = BuildSpecifications(long: 5, width: 5);
    final materials = DrywallMaterialsModel.fromJson(json.decode(fixture('materials.json')));

    group('when response is success', () {
      setUp(() {
        var rawMaterials = fixture('materials.json');
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response(rawMaterials, 200));
      });

      test('perform a GET request on a URL with the query params and with application/json header', () {
        drywallCalculatorApiDataSource.getMaterials(specifications);

        verify(mockHttpClient.get(
          calculatorFunctionUrl,
          headers: {'Content-Type': 'application/json'},
        ));
      });

      test('return the materials from the response', () async {
        final result = await drywallCalculatorApiDataSource.getMaterials(specifications);

        expect(result, materials);
      });
    });

    group('When response is other than success', () {
      test('throw an ApiException when the response code is different to 200', () {
        when(mockHttpClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => http.Response('something went wrong', 404));

        final call = drywallCalculatorApiDataSource.getMaterials;

        expect(() => call(specifications), throwsA(TypeMatcher<ApiException>()));
      });
    });
  });
}
