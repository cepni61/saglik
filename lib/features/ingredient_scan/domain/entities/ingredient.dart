import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String id;
  final String name;
  final String? category;
  final int healthImpact; // -100 (very bad) to 100 (very good)
  final bool isAllergen;
  final List<String> allergenTypes;

  const Ingredient({
    required this.id,
    required this.name,
    this.category,
    required this.healthImpact,
    this.isAllergen = false,
    this.allergenTypes = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        healthImpact,
        isAllergen,
        allergenTypes,
      ];
}
