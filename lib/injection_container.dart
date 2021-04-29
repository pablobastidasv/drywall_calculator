import 'package:drywall_calculator_dart/core/presentation/input_converter.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/boundary/material_calculator.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.I;

Future<void> init() async {
  _regiterFeatures();
  _registerCore();
}

void _registerCore() {
  // InputConverter
  sl.registerLazySingleton(() => InputConverter());
}

void _regiterFeatures() {
  // Bloc
  sl.registerFactory(
    () => CalculateMaterialBloc(
      materialCalculator: sl(),
      inputConverter: sl(),
    ),
  );
  // Material Calculator
  sl.registerLazySingleton(() => MaterialCalculator());
}
