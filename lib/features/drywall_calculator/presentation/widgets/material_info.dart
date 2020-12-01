import 'package:flutter/material.dart';

class MaterialInfo extends StatelessWidget {
  final material;
  final quantity;
  final unit;

  const MaterialInfo({
    Key key,
    @required this.material,
    @required this.quantity,
    this.unit = 'UND',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              this.material,
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey,
              ),
            ),
          ),
        ),
        Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${this.quantity} ${this.unit}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
