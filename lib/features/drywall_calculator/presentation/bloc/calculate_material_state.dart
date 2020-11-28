part of 'calculate_material_bloc.dart';

abstract class CalculateMaterialState extends Equatable {
  const CalculateMaterialState();
}

class CalculateMaterialInitial extends CalculateMaterialState {
  @override
  List<Object> get props => [];
}

class Loading extends CalculateMaterialState {
  @override
  List<Object> get props => [];
}

class Loaded extends CalculateMaterialState {
  final DrywallMaterials materials;

  Loaded({@required this.materials});

  @override
  List<Object> get props => [materials];
}

class Error extends CalculateMaterialState {
  final String message;

  Error(this.message);

  @override
  List<Object> get props => [message];
}
