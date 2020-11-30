import 'package:drywall_calculator_dart/core/presentation/pages/error_page.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
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
            return MaterialsInfo(
              materials: state.materials,
            );
          } else if (state is Error) {
            return Container(
              child: Text(state.message),
            );
          }
          return ErrorPage();
        },
      ),
    );
  }
}

class MaterialsInfo extends StatelessWidget {
  final DrywallMaterials materials;

  const MaterialsInfo({
    Key key,
    @required this.materials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MaterialInfo(
              material: 'Parales',
              quantity: materials.omegasParals,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Ángulos',
              quantity: materials.angles,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Principales',
              quantity: materials.principals,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Canales',
              quantity: materials.canals,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Láminas',
              quantity: materials.sheets,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Tornillos de lamina',
              quantity: materials.screws,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Cuñete de pintura',
              quantity: materials.paintKeg,
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Masilla en polvo',
              quantity: materials.dustPutty,
              unit: "Bultos",
            ),
            SizedBox(height: 15),
            MaterialInfo(
              material: 'Masilla',
              quantity: materials.putty,
              unit: "Kg",
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class MaterialInfo extends StatelessWidget {
  final material;
  final quantity;
  final unit;

  const MaterialInfo({
    Key key,
    this.material = 'Laminas',
    this.quantity = 4.0,
    this.unit = 'UND',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            this.material,
            style: TextStyle(
              fontSize: 25,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '${this.quantity} ${this.unit}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
