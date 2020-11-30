import 'package:drywall_calculator_dart/features/drywall_calculator/domain/entity/building_specifications.dart';

class BuildSpecificationsModel extends BuildSpecifications {
  BuildSpecificationsModel({
    double long,
    double width,
    material = Material.panel,
    job = Job.ceiling,
  }) : super(long: long, width: width, material: material, job: job);

  factory BuildSpecificationsModel.from(BuildSpecifications specifications) {
    return BuildSpecificationsModel(
      long: specifications.long,
      width: specifications.width,
      material: specifications.material,
      job: specifications.job,
    );
  }

  String get materialParam {
    switch (material) {
      case Material.board:
        return "Board";
      default:
        return "Panel";
    }
  }

  String get jobParam {
    switch (job) {
      case Job.double_wall:
        return "Double";
      default:
        return "Simple";
    }
  }
}
