import 'package:dartz/dartz.dart';
import 'package:saglik/core/error/failures.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/ingredient.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';

abstract class IngredientScanRepository {
  /// Recognize text from image path using OCR
  Future<Either<Failure, String>> recognizeTextFromImage(String imagePath);

  /// Parse recognized text to extract ingredient names
  Future<Either<Failure, List<String>>> parseIngredients(String text);

  /// Match ingredient names against local database
  Future<Either<Failure, List<Ingredient>>> matchIngredients(
    List<String> ingredientNames,
  );

  /// Calculate health score based on ingredients
  Future<Either<Failure, int>> calculateHealthScore(
    List<Ingredient> ingredients,
  );

  /// Save scan result to local database
  Future<Either<Failure, void>> saveScanResult(ScanResult result);

  /// Get scan history
  Future<Either<Failure, List<ScanResult>>> getScanHistory();
}
