import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/exceptions.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/core/network/network_info.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_api_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_local_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/models/drywall_materials_model.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/repositories/drywall_calculator_repository_impl.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDrywallCalculatorApiDataSource extends Mock implements DrywallCalculatorApiDataSource {}

class MockDrywallCalculatorLocalDataSource extends Mock implements DrywallCalculatorLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  DrywallCalculatorRepositoryImpl repository;

  MockDrywallCalculatorApiDataSource mockApiDataSource;
  MockDrywallCalculatorLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockApiDataSource = MockDrywallCalculatorApiDataSource();
    mockLocalDataSource = MockDrywallCalculatorLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = DrywallCalculatorRepositoryImpl(
      apiDataSource: mockApiDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getMaterials', () {
    final specifications = BuildSpecifications(long: 6, width: 5);
    final materialsModel = DrywallMaterialsModel(10.12, 4.92, 1.8, 20.66, 0.24, 13.52, 0.86, 202, 10.08);
    final DrywallMaterials materials = materialsModel;

    test(
      'should check if the device is online',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        repository.getMaterials(specifications);

        verify(mockNetworkInfo.isConnected);
      },
    );

    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('return remote data when the call to remote data source is successful', () async {
        when(mockApiDataSource.getMaterials(specifications)).thenAnswer((_) async => materialsModel);

        var result = await repository.getMaterials(specifications);

        verify(mockApiDataSource.getMaterials(specifications));
        expect(result, equals(Right(materials)));
      });

      test('cache the data locally when the call to remote data source is successful', () async {
        when(mockApiDataSource.getMaterials(specifications)).thenAnswer((_) async => materialsModel);

        await repository.getMaterials(specifications);

        verify(mockApiDataSource.getMaterials(specifications));
        verify(mockLocalDataSource.cacheMaterials(specifications, materialsModel));
      });

      test('throw a server error when the call to remote data source is unsuccessful', () async {
        when(mockApiDataSource.getMaterials(specifications)).thenThrow(ApiException());

        var result = await repository.getMaterials(specifications);

        verify(mockApiDataSource.getMaterials(specifications));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ApiFailure())));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('return locally cached data when cache data is present', () async {
        when(mockLocalDataSource.getMaterialOf(specifications)).thenAnswer((_) async => materialsModel);

        var result = await repository.getMaterials(specifications);

        verifyZeroInteractions(mockApiDataSource);
        verify(mockLocalDataSource.getMaterialOf(specifications));
        expect(result, equals(Right(materials)));
      });

      test('return cache failure when cache data is NOT present', () async {
        when(mockLocalDataSource.getMaterialOf(specifications)).thenThrow(CacheException());

        var result = await repository.getMaterials(specifications);

        verifyZeroInteractions(mockApiDataSource);
        verify(mockLocalDataSource.getMaterialOf(specifications));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
