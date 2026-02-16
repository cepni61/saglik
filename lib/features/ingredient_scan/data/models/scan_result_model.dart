import 'package:saglik/features/ingredient_scan/domain/entities/scan_result.dart';

class ScanResultModel extends ScanResult {
  const ScanResultModel({
    required super.id,
    required super.imageId,
    required super.recognizedText,
    required super.detectedIngredients,
    required super.healthScore,
    required super.allergens,
    required super.scannedAt,
  });

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      id: json['id'] as String,
      imageId: json['imageId'] as String,
      recognizedText: json['recognizedText'] as String,
      detectedIngredients: (json['detectedIngredients'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      healthScore: json['healthScore'] as int,
      allergens: (json['allergens'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageId': imageId,
      'recognizedText': recognizedText,
      'detectedIngredients': detectedIngredients,
      'healthScore': healthScore,
      'allergens': allergens,
      'scannedAt': scannedAt.toIso8601String(),
    };
  }

  factory ScanResultModel.fromEntity(ScanResult entity) {
    return ScanResultModel(
      id: entity.id,
      imageId: entity.imageId,
      recognizedText: entity.recognizedText,
      detectedIngredients: entity.detectedIngredients,
      healthScore: entity.healthScore,
      allergens: entity.allergens,
      scannedAt: entity.scannedAt,
    );
  }
}
