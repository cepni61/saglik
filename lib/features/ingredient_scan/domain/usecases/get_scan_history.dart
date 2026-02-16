import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:saglik/core/error/failures.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';
import 'package:saglik/features/ingredient_scan/domain/repositories/ingredient_scan_repository.dart';

@lazySingleton
class GetScanHistory {
  final IngredientScanRepository repository;

  GetScanHistory(this.repository);

  Future<Either<Failure, List<ScanResult>>> call() async {
    return await repository.getScanHistory();
  }
}
