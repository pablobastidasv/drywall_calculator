import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:drywall_calculator_dart/core/presentation/input_converter.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/boundary/material_calculator.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'calculate_material_event.dart';

part 'calculate_material_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String UNKNOWN_FAILURE_MESSAGE = 'Unknown failure';
const String INPUT_CONVERTER_FAILURE_MESSAGE = 'Input converter failure, number should be positive or cero';

class CalculateMaterialBloc extends Bloc<CalculateMaterialEvent, CalculateMaterialState> {
  final MaterialCalculator materialCalculator;
  final InputConverter inputConverter;

  CalculateMaterialBloc({@required this.materialCalculator, @required this.inputConverter})
      : assert(materialCalculator != null),
        assert(inputConverter != null),
        super(CalculateMaterialInitial());

  @override
  Stream<CalculateMaterialState> mapEventToState(CalculateMaterialEvent event) async* {
    if (event is GetDrywallMaterialEvent) {
      final specsOrFailure = _eventToBuildingSpecification(event);

      yield* specsOrFailure.fold(
        _handleInputFailure,
        _processBuildSpecifications,
      );
    }
  }

  Stream<CalculateMaterialState> _handleInputFailure(failure) async* {
    yield Error(INPUT_CONVERTER_FAILURE_MESSAGE);
  }

  Stream<CalculateMaterialState> _processBuildSpecifications(BuildSpecifications specifications) async* {
    yield Loading();
    final materialsOrFailure = await materialCalculator(specifications);
    yield materialsOrFailure.fold(
      (failure) => Error(_mapFailureToMessage(failure)),
      (materials) => Loaded(materials: materials),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ApiFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return UNKNOWN_FAILURE_MESSAGE;
    }
  }

  Either<Failure, BuildSpecifications> _eventToBuildingSpecification(GetDrywallMaterialEvent event) {
    final longOrFailure = inputConverter.stringToUnsignedDouble(event.long);
    final widthOrFailure = inputConverter.stringToUnsignedDouble(event.width);

    return longOrFailure.bind(
      (long) => widthOrFailure.bind(
        (width) => BuildSpecifications.from(long, width, event.material, event.job),
      ),
    );
  }
}
