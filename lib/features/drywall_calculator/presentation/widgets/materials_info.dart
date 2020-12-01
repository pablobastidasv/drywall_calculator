import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';
import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/drywall_materials.dart';
import 'package:flutter/material.dart';

import 'material_info.dart';

class MaterialsInfo extends StatelessWidget {
  final DrywallMaterials materials;
  final BuildSpecifications specifications;

  const MaterialsInfo({
    Key key,
    @required this.materials,
    @required this.specifications,
  }) : super(key: key);

  Widget _buildPutty() {
    return MaterialInfo(
      material: 'Masilla',
      quantity: materials.putty,
      unit: "Kg",
    );
  }

  Widget _buildDustPutty() {
    return MaterialInfo(
      material: 'Masilla en polvo',
      quantity: materials.dustPutty,
      unit: "Bultos",
    );
  }

  Widget _buildPaintKeg() {
    return MaterialInfo(
      material: 'Cuñete de pintura',
      quantity: materials.paintKeg,
    );
  }

  Widget _buldScrews() {
    return MaterialInfo(
      material: 'Tornillos de lamina',
      quantity: materials.screws,
    );
  }

  Widget _buildLaminas() {
    return MaterialInfo(
      material: 'Láminas',
      quantity: materials.sheets,
    );
  }

  Widget _buildCanals() {
    return MaterialInfo(
      material: 'Canales',
      quantity: materials.canals,
    );
  }

  Widget _buildPrincipales() {
    return MaterialInfo(
      material: 'Principales',
      quantity: materials.principals,
    );
  }

  Widget _buildAngles() {
    return MaterialInfo(
      material: 'Ángulos',
      quantity: materials.angles,
    );
  }

  Widget _buildOmegasParales() {
    return MaterialInfo(
      material: specifications.job == Job.ceiling ? 'Omegas' : 'Parales',
      quantity: materials.omegasParals,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          _buildOmegasParales(),
          _buildAngles(),
          _buildPrincipales(),
          _buildCanals(),
          _buildLaminas(),
          _buldScrews(),
          _buildPaintKeg(),
          _buildDustPutty(),
          _buildPutty(),
        ],
      ),
    );
  }
}
