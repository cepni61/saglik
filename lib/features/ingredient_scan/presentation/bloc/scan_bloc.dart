import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:saglik/features/ingredient_scan/domain/usecases/get_scan_history.dart';
import 'package:saglik/features/ingredient_scan/domain/usecases/scan_ingredient_label.dart';
import 'package:saglik/features/ingredient_scan/presentation/bloc/scan_event.dart';
import 'package:saglik/features/ingredient_scan/presentation/bloc/scan_state.dart';

@injectable
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanIngredientLabel scanIngredientLabel;
  final GetScanHistory getScanHistory;

  ScanBloc({
    required this.scanIngredientLabel,
    required this.getScanHistory,
  }) : super(const ScanInitial()) {
    on<StartScanEvent>(_onStartScan);
    on<LoadHistoryEvent>(_onLoadHistory);
  }

  Future<void> _onStartScan(
    StartScanEvent event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading());

    final result = await scanIngredientLabel(event.imagePath);

    result.fold(
      (failure) => emit(ScanError(_mapFailureToMessage(failure))),
      (scanResult) => emit(ScanSuccess(scanResult)),
    );
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<ScanState> emit,
  ) async {
    final result = await getScanHistory();

    result.fold(
      (failure) => emit(ScanError(_mapFailureToMessage(failure))),
      (history) => emit(HistoryLoaded(history)),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }
}
