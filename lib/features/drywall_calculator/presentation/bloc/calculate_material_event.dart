part of 'calculate_material_bloc.dart';

abstract class CalculateMaterialEvent extends Equatable {
  const CalculateMaterialEvent();
}

class GetDrywallMaterialEvent extends CalculateMaterialEvent {
  final String long;
  final String width;
  final String job;
  final String material;

  GetDrywallMaterialEvent({
    required this.long,
    required this.width,
    this.job = "Ceiling",
    this.material = "Panel",
  });

  @override
  List<Object?> get props => [this.long, this.width, this.job, this.material];
}
