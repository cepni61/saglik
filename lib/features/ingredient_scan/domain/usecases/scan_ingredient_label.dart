import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:saglik/core/error/failures.dart';
import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';
import 'package:saglik/features/ingredient_scan/domain/repositories/ingredient_scan_repository.dart';

@lazySingleton
class ScanIngredientLabel {
  final IngredientScanRepository repository;

  ScanIngredientLabel(this.repository);

  Future<Either<Failure, ScanResult>> call(String imagePath) async {
    // Step 1: Recognize text from image
    final textResult = await repository.recognizeTextFromImage(imagePath);
    if (textResult.isLeft()) {
      return Left((textResult as Left<Failure, String>).value);
    }
    final recognizedText = (textResult as Right<Failure, String>).value;

    // Step 2: Parse ingredients from text
    final parseResult = await repository.parseIngredients(recognizedText);
    if (parseResult.isLeft()) {
      return Left((parseResult as Left<Failure, List<String>>).value);
    }
    final ingredientNames = (parseResult as Right<Failure, List<String>>).value;

    // Step 3: Match ingredients against database
    final matchResult = await repository.matchIngredients(ingredientNames);
    if (matchResult.isLeft()) {
      return Left((matchResult as Left).value);
    }
    final ingredients = (matchResult as Right).value;

    // Step 4: Calculate health score
    final scoreResult = await repository.calculateHealthScore(ingredients);
    if (scoreResult.isLeft()) {
      return Left((scoreResult as Left<Failure, int>).value);
    }
    final healthScore = (scoreResult as Right<Failure, int>).value;

    // Step 5: Create scan result
    final scanResult = ScanResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imageId: imagePath,
      recognizedText: recognizedText,
      detectedIngredients: ingredientNames,
      healthScore: healthScore,
      allergens: ingredients
          .where((i) => i.isAllergen)
          .expand((i) => i.allergenTypes)
          .toSet()
          .toList(),
      scannedAt: DateTime.now(),
    );

    // Step 6: Save to database
    final saveResult = await repository.saveScanResult(scanResult);
    if (saveResult.isLeft()) {
      return Left((saveResult as Left<Failure, void>).value);
    }

    return Right(scanResult);
  }
}
