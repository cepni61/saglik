import 'package:equatable/equatable.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {
  const ScanInitial();
}

class ScanLoading extends ScanState {
  const ScanLoading();
}

class ScanSuccess extends ScanState {
  final ScanResult result;

  const ScanSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class ScanError extends ScanState {
  final String message;

  const ScanError(this.message);

  @override
  List<Object?> get props => [message];
}

class HistoryLoaded extends ScanState {
  final List<ScanResult> history;

  const HistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}
