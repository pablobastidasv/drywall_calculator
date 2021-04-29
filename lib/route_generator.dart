import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/pages/build_specifications_page.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/pages/materials_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/pages/error_page.dart';
import 'injection_container.dart';

class RouteGenerator {
  final CalculateMaterialBloc _bloc = sl<CalculateMaterialBloc>();

  Route<dynamic> generateRoute(RouteSettings settings) {
    // final arg = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _bloc,
            child: BuildSpecificationsPage(),
          ),
        );
      case '/materials':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _bloc,
            child: MaterialsViewPage(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => ErrorPage());
    }
  }

  void dispose() {
    this._bloc.close();
  }
}
