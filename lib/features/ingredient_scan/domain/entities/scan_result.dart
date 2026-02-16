import 'package:equatable/equatable.dart';

class ScanResult extends Equatable {
  final String id;
  final String imageId;
  final String recognizedText;
  final List<String> detectedIngredients;
  final int healthScore;
  final List<String> allergens;
  final DateTime scannedAt;

  const ScanResult({
    required this.id,
    required this.imageId,
    required this.recognizedText,
    required this.detectedIngredients,
    required this.healthScore,
    required this.allergens,
    required this.scannedAt,
  });

  @override
  List<Object?> get props => [
        id,
        imageId,
        recognizedText,
        detectedIngredients,
        healthScore,
        allergens,
        scannedAt,
      ];
}
