import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

// Database failures
class DatabaseFailure extends Failure {
  final String message;

  const DatabaseFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// OCR failures
class OcrFailure extends Failure {
  final String message;

  const OcrFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Camera failures
class CameraFailure extends Failure {
  final String message;

  const CameraFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Parsing failures
class ParsingFailure extends Failure {
  final String message;

  const ParsingFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// Scoring failures
class ScoringFailure extends Failure {
  final String message;

  const ScoringFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// General failures
class UnexpectedFailure extends Failure {
  final String message;

  const UnexpectedFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
