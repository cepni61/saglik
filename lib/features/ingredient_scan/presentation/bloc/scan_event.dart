import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object?> get props => [];
}

class StartScanEvent extends ScanEvent {
  final String imagePath;

  const StartScanEvent(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class LoadHistoryEvent extends ScanEvent {
  const LoadHistoryEvent();
}
