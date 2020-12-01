import 'package:flutter/material.dart';

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
