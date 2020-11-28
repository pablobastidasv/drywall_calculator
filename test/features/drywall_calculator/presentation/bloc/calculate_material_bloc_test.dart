import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/core/presentation/input_converter.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/boundary/material_calculator.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockMaterialCalculator extends Mock implements MaterialCalculator {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  MaterialCalculator materialCalculator;
  InputConverter inputConverter;

  CalculateMaterialBloc bloc;

  setUp(() {
    materialCalculator = MockMaterialCalculator();
    inputConverter = MockInputConverter();
    bloc = CalculateMaterialBloc(
      materialCalculator: materialCalculator,
      inputConverter: inputConverter,
    );
  });

  test('initial state should be CalculateMaterialInitial', () {
    expect(bloc.state, equals(CalculateMaterialInitial()));
  });

  group('CalculateMaterial', () {
    final long = "6";
    final width = "5";
    final materials = DrywallMaterials(10.12, 4.92, 1.8, 20.66, 0.24, 13.52, 0.86, 202, 10.08);
    final specification = BuildSpecifications(long: 6, width: 5);

    group('When materials are correctly obtained', () {
      setUp(() {
        when(materialCalculator(any)).thenAnswer((_) async => Right(materials));
      });

      test('input converter is called', () async {
        when(inputConverter.stringToUnsignedDouble(any)).thenReturn(Right(1.0));

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
        await untilCalled(inputConverter.stringToUnsignedDouble(long));
        await untilCalled(inputConverter.stringToUnsignedDouble(width));

        verify(inputConverter.stringToUnsignedDouble(long));
        verify(inputConverter.stringToUnsignedDouble(width));
      });

      test('when input is invalid emit [Error]', () {
        when(inputConverter.stringToUnsignedDouble(any)).thenReturn(Left(InvalidInputFailure()));

        var expected = [
          Error(INPUT_CONVERTER_FAILURE_MESSAGE),
        ];

        expectLater(
          bloc,
          emitsInOrder(expected),
        );

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
      });

      test('get data from CalculateMaterial boundary', () async {
        when(inputConverter.stringToUnsignedDouble("6")).thenReturn(Right(6.0));
        when(inputConverter.stringToUnsignedDouble("5")).thenReturn(Right(5.0));

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
        await untilCalled(materialCalculator(any));

        verify(materialCalculator(specification));
      });

      test('emit [Loading, Loaded] when data is gotten successfully', () {
        when(inputConverter.stringToUnsignedDouble("6")).thenReturn(Right(6.0));
        when(inputConverter.stringToUnsignedDouble("5")).thenReturn(Right(5.0));

        final expected = [Loading(), Loaded(materials: materials)];
        expectLater(bloc, emitsInOrder(expected));

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
      });
    });

    group('When there is a failure in the domain side', () {
      test('emit [Loading, Error] when data getting data api fails', () {
        when(inputConverter.stringToUnsignedDouble("6")).thenReturn(Right(6.0));
        when(inputConverter.stringToUnsignedDouble("5")).thenReturn(Right(5.0));
        when(materialCalculator(any)).thenAnswer((_) async => Left(ApiFailure()));

        final expected = [Loading(), Error(SERVER_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expected));

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
      });

      test('emit [Loading, Error] when data getting data cache fails', () {
        when(inputConverter.stringToUnsignedDouble("6")).thenReturn(Right(6.0));
        when(inputConverter.stringToUnsignedDouble("5")).thenReturn(Right(5.0));
        when(materialCalculator(any)).thenAnswer((_) async => Left(CacheFailure()));

        final expected = [Loading(), Error(CACHE_FAILURE_MESSAGE)];
        expectLater(bloc, emitsInOrder(expected));

        bloc
          ..add(GetDrywallMaterialEvent(long: long, width: width))
          ..close();
      });
    });
  });
}
