import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fast_info.dart';

class BuildMaterialsForm extends StatefulWidget {
  @override
  _BuildMaterialsFormState createState() => _BuildMaterialsFormState();
}

class _BuildMaterialsFormState extends State<BuildMaterialsForm> {
  final _formKey = GlobalKey<FormState>();

  var _long = '';
  var _width = '';
  var _job = '';
  var _material = '';

  var _area = 0.0;
  var _perimeter = 0.0;

  Widget _buildLongField() {
    return TextFormField(
      validator: _notEmptyInputTextValidator,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration("Largo en m"),
      onChanged: (value) {
        this._long = value;
        _calculateArea();
      },
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
    );
  }

  Widget _buildWidthField() {
    return TextFormField(
      validator: _notEmptyInputTextValidator,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration("Ancho/Alto en m"),
      onChanged: (value) {
        this._width = value;
        _calculateArea();
      },
    );
  }

  Widget _buildJobField() {
    return DropdownButtonFormField(
      validator: _notEmptyComboBoxValidator,
      onChanged: (value) {
        setState(() {
          _job = value;
        });
      },
      items: _jobItems(),
      decoration: _inputDecoration('Tipo de trabajo'),
    );
  }

  Widget _buildMaterialField() {
    return DropdownButtonFormField(
      validator: _notEmptyComboBoxValidator,
      onChanged: (value) {
        setState(() {
          _material = value;
        });
      },
      items: _materialItems(),
      decoration: _inputDecoration('Tipo de trabajo'),
    );
  }

  Row _buildCalculateButtonRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RaisedButton(
            child: Text('Calcular'),
            color: Theme.of(context).accentColor,
            textTheme: ButtonTextTheme.primary,
            onPressed: () {
              _onCalculate(context);
            },
          ),
        ),
      ],
    );
  }

  void _onCalculate(BuildContext context) {
    if (_formKey.currentState.validate()) {
      BlocProvider.of<CalculateMaterialBloc>(context).add(GetDrywallMaterialEvent(
        long: this._long,
        width: this._width,
        material: this._material,
        job: this._job,
      ));
      Navigator.of(context).pushNamed('/materials');
    }
  }

  Row _buildFastInfoRow() {
    return Row(
      children: [
        Expanded(
          child: FastInfo(
            message: 'Área',
            quantity: _area,
            unit: 'm²',
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FastInfo(
            message: 'Perímetro',
            quantity: _perimeter,
            unit: 'm',
          ),
        )
      ],
    );
  }

  String _notEmptyInputTextValidator(val) {
    if (val.isEmpty) return 'Ingrese el valor';
    return null;
  }

  String _notEmptyComboBoxValidator(val) {
    if (val == null) return 'Seleccione un valor';
    return null;
  }

  List<DropdownMenuItem<String>> _jobItems() {
    return {
      'ceiling': 'Cielo',
      'simple_wall': 'Muro simple',
      'double_wall': 'Muro doble',
    }
        .entries
        .map(
          (e) => DropdownMenuItem(
            value: e.key,
            child: Text(e.value),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _materialItems() {
    return {
      'panel': 'Panel',
      'board': 'Board',
    }
        .entries
        .map(
          (e) => DropdownMenuItem(
            value: e.key,
            child: Text(e.value),
          ),
        )
        .toList();
  }

  void _calculateArea() {
    double long = 0;
    double width = 0;

    if (!(_isNullOrEmpty(this._long) || _isNullOrEmpty(this._width))) {
      long = double.tryParse(this._long);
      width = double.tryParse(this._width);
    }

    setState(() {
      _area = long * width;
      _perimeter = (long * 2) + (_area * 2);
    });
  }

  bool _isNullOrEmpty(String value) => value == null || value.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          _buildLongField(),
          SizedBox(height: 15),
          _buildWidthField(),
          SizedBox(height: 15),
          _buildJobField(),
          SizedBox(height: 15),
          _buildMaterialField(),
          SizedBox(height: 15),
          _buildFastInfoRow(),
          SizedBox(height: 50),
          _buildCalculateButtonRow(context)
        ],
      ),
    );
  }
}
