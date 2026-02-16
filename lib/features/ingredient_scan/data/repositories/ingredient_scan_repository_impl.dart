import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:saglik/core/error/failures.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/ingredient.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';
import 'package:saglik/features/ingredient_scan/domain/repositories/ingredient_scan_repository.dart';

@LazySingleton(as: IngredientScanRepository)
class IngredientScanRepositoryImpl implements IngredientScanRepository {
  final List<ScanResult> _scanHistory = [];

  @override
  Future<Either<Failure, String>> recognizeTextFromImage(
      String imagePath) async {
    try {
      // TODO: Implement real OCR with google_mlkit_text_recognition
      // For now, return mock data
      await Future.delayed(const Duration(seconds: 1));
      return const Right(
        'İçindekiler: Su, şeker, sitrik asit, doğal aroma, E330, sodyum benzoat',
      );
    } catch (e) {
      return Left(OcrFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> parseIngredients(String text) async {
    try {
      // TODO: Implement intelligent parsing
      // For now, simple comma-based splitting
      final ingredients = text
          .split(':')
          .last
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      return Right(ingredients);
    } catch (e) {
      return Left(ParsingFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ingredient>>> matchIngredients(
    List<String> ingredientNames,
  ) async {
    try {
      // TODO: Match against real database
      // For now, create mock ingredients
      final ingredients = ingredientNames.asMap().entries.map((entry) {
        final name = entry.value.toLowerCase();
        final isUnhealthy = name.contains('şeker') ||
            name.contains('e330') ||
            name.contains('benzoat');

        return Ingredient(
          id: entry.key.toString(),
          name: entry.value,
          category: 'mock',
          healthImpact: isUnhealthy ? -50 : 10,
          isAllergen: false,
          allergenTypes: [],
        );
      }).toList();

      return Right(ingredients);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> calculateHealthScore(
    List<Ingredient> ingredients,
  ) async {
    try {
      if (ingredients.isEmpty) {
        return const Right(50);
      }

      // Simple scoring: average of health impacts, normalized to 0-100
      final totalImpact = ingredients.fold<int>(
        0,
        (sum, ingredient) => sum + ingredient.healthImpact,
      );
      final averageImpact = totalImpact / ingredients.length;

      // Convert from -100/100 range to 0/100 range
      final score = ((averageImpact + 100) / 2).round().clamp(0, 100);

      return Right(score);
    } catch (e) {
      return Left(ScoringFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveScanResult(ScanResult result) async {
    try {
      _scanHistory.add(result);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ScanResult>>> getScanHistory() async {
    try {
      return Right(List.from(_scanHistory.reversed));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
