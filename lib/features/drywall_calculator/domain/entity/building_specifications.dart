import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum Material { panel, board }

enum Job { ceiling, simple_wall, double_wall }

class BuildSpecifications extends Equatable {
  final double long;
  final double width;
  final Material material;
  final Job job;

  BuildSpecifications({
    @required this.long,
    @required this.width,
    this.material = Material.panel,
    this.job = Job.ceiling
  });

  @override
  List<Object> get props => [
    this.long, this.width,
    this.material, this.job
  ];
}