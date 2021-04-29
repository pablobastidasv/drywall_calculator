import 'package:dartz/dartz.dart';
import 'package:drywall_calculator_dart/core/error/failures.dart';
import 'package:equatable/equatable.dart';

enum Material { panel, board }

enum Job { ceiling, simple_wall, double_wall }

class BuildSpecifications extends Equatable {
  final double long;
  final double width;
  final Material material;
  final Job job;

  BuildSpecifications({
    required this.long,
    required this.width,
    this.material = Material.panel,
    this.job = Job.ceiling,
  })  : assert(long > 0),
        assert(width > 0);

  @override
  List<Object> get props => [this.long, this.width, this.material, this.job];

  String get hashValue => hashCode.toString();

  static Either<Failure, BuildSpecifications> from(
    double long,
    double width,
    String material,
    String job,
  ) {
    try {
      final enumMaterial = Material.values.firstWhere((e) => _compareEnum(e.toString(), material));
      final enumJob = Job.values.firstWhere((e) => _compareEnum(e.toString(), job));

      var specifications = BuildSpecifications(
        long: long,
        width: width,
        material: enumMaterial,
        job: enumJob,
      );
      return Right(specifications);
    } on AssertionError {
      return Left(InvalidArgumentFailure());
    } on StateError {
      return Left(InvalidArgumentFailure());
    }
  }

  static bool _compareEnum(String enumVal, String material) => enumVal.split('.')[1].toLowerCase() == material.toLowerCase();
}
