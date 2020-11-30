import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:drywall_calculator_dart/core/network/network_info.dart';
import 'package:drywall_calculator_dart/core/presentation/input_converter.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_api_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/datasources/drywall_calculator_local_data_source.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/data/repositories/drywall_calculator_repository_impl.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/boundary/material_calculator.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/repositories/drywall_calculator_repository.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.I;

Future<void> init() async {
  _regiterFeatures();
  _registerCore();
  await _registerExternals();
}

Future _registerExternals() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  // HttpClient
  sl.registerLazySingleton(() => http.Client());
  // ConnectionChecker
  sl.registerLazySingleton(() => DataConnectionChecker());
}

void _registerCore() {
  // InputConverter
  sl.registerLazySingleton(() => InputConverter());
  // NetworkInfo
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
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
  sl.registerLazySingleton(() => MaterialCalculator(sl()));
  // Repository
  sl.registerLazySingleton<DrywallCalculatorRepository>(
    () => DrywallCalculatorRepositoryImpl(
      apiDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // DrywallCalculatorApiDataSourceImpl
  sl.registerLazySingleton<DrywallCalculatorApiDataSource>(
    () => DrywallCalculatorApiDataSourceImpl(
      httpClient: sl(),
    ),
  );
  // DrywallCalculatorLocalDataSource
  sl.registerLazySingleton<DrywallCalculatorLocalDataSource>(
    () => DrywallCalculatorLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
}
