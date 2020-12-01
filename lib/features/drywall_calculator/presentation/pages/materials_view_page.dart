import 'package:drywall_calculator_dart/core/presentation/pages/error_page.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/widgets/materials_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MaterialsViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Materiales'),
      ),
      body: BlocBuilder<CalculateMaterialBloc, CalculateMaterialState>(
        builder: (context, state) {
          if (state is Loading) {
            return SpinKitRotatingCircle(
              color: Theme.of(context).accentColor,
              size: 50.0,
            );
          } else if (state is Loaded) {
            return SingleChildScrollView(
              child: MaterialsInfo(
                materials: state.materials,
                specifications: state.specifications,
              ),
            );
          } else if (state is Error) {
            return Container(
              child: Center(
                child: Text(state.message),
              ),
            );
          }
          return ErrorPage();
        },
      ),
    );
  }
}
