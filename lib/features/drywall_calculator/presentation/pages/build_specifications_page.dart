import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/widgets/build_materials_form.dart';
import 'package:flutter/material.dart';

class BuildSpecificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de materiales'),
      ),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: BuildMaterialsForm(),
    );
  }
}
