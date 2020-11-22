import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final properties;
  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

class ApiFailure extends Failure {}
class CacheFailure extends Failure {}