import 'package:drywall_calculator_dart/features/drywall_calculator/presentation/bloc/calculate_material_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BuildMaterialsForm(),
      ),
    );
  }
}

class FastInfo extends StatelessWidget {
  final String message;
  final double quantity;
  final String unit;

  const FastInfo({
    Key key,
    @required this.message,
    @required this.quantity,
    @required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          this.message,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text('${this.quantity} ${this.unit}'),
      ],
    );
  }
}

class BuildMaterialsForm extends StatefulWidget {
  @override
  _BuildMaterialsFormState createState() => _BuildMaterialsFormState();
}

class _BuildMaterialsFormState extends State<BuildMaterialsForm> {
  final _formKey = GlobalKey<FormState>();

  var job = '';
  var material = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          TextFormField(
            validator: notEmptyInputTextValidator,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Largo en m",
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            validator: notEmptyInputTextValidator,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Ancho/Alto en m",
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField(
            validator: notEmptyComboBoxValidator,
            onChanged: (value) {
              setState(() {
                job = value;
              });
            },
            items: jobItems(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tipo de trabajo',
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField(
            validator: notEmptyComboBoxValidator,
            onChanged: (value) {
              setState(() {
                material = value;
              });
            },
            items: materialItems(),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Material a usar',
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FastInfo(
                  message: 'Área',
                  quantity: 10,
                  unit: 'm²',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FastInfo(
                  message: 'Perímetro',
                  quantity: 10,
                  unit: 'm',
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: RaisedButton(
                  child: Text('Calcular'),
                  color: Theme.of(context).accentColor,
                  textTheme: ButtonTextTheme.primary,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      BlocProvider.of<CalculateMaterialBloc>(context).add(GetDrywallMaterialEvent(
                        long: "6",
                        width: "5",
                      ));
                      Navigator.of(context).pushNamed('/materials');
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  String notEmptyInputTextValidator(val) {
    if (val.isEmpty) return 'Ingrese el valor';
    return null;
  }

  String notEmptyComboBoxValidator(val) {
    if (val == null) return 'Seleccione un valor';
    return null;
  }

  List<DropdownMenuItem<String>> jobItems() {
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

  List<DropdownMenuItem<String>> materialItems() {
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
}
