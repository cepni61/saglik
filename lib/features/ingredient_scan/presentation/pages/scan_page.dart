import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saglik/core/di/injection.dart';
import 'package:saglik/features/ingredient_scan/presentation/bloc/scan_bloc.dart';
import 'package:saglik/features/ingredient_scan/presentation/bloc/scan_event.dart';
import 'package:saglik/features/ingredient_scan/presentation/bloc/scan_state.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ScanBloc>(),
      child: const ScanPageView(),
    );
  }
}

class ScanPageView extends StatelessWidget {
  const ScanPageView({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null && context.mounted) {
      context.read<ScanBloc>().add(StartScanEvent(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Etiket Tara'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          if (state is ScanLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Taranıyor...'),
                ],
              ),
            );
          }

          if (state is ScanSuccess) {
            return _buildResultView(context, state);
          }

          if (state is ScanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ScanBloc>().add(const LoadHistoryEvent());
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          return _buildInitialView(context);
        },
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 120,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          const Text(
            'Ürün Etiketini Tarayın',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'İçindekiler bölümünün fotoğrafını çekin veya galeriden seçin',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                context,
                icon: Icons.camera_alt,
                label: 'Fotoğraf Çek',
                onTap: () => _pickImage(context, ImageSource.camera),
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                context,
                icon: Icons.photo_library,
                label: 'Galeriden Seç',
                onTap: () => _pickImage(context, ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView(BuildContext context, ScanSuccess state) {
    final result = state.result;
    final scoreColor = _getScoreColor(result.healthScore);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Score Card
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Sağlık Skoru',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: result.healthScore / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[300],
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        '${result.healthScore}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getScoreText(result.healthScore),
                    style: TextStyle(
                      fontSize: 16,
                      color: scoreColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Allergens
          if (result.allergens.isNotEmpty) ...[
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Alerjen Uyarısı',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...result.allergens.map(
                      (allergen) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('• $allergen'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Detected Ingredients
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tespit Edilen İçindekiler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: result.detectedIngredients
                        .map(
                          (ingredient) => Chip(
                            label: Text(ingredient),
                            backgroundColor:
                                Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recognized Text
          Card(
            child: ExpansionTile(
              title: const Text('Tam Metin'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(result.recognizedText),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Scan Again Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _pickImage(context, ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text('Yeni Tarama'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getScoreText(int score) {
    if (score >= 70) return 'Sağlıklı';
    if (score >= 40) return 'Orta Derecede Sağlıklı';
    return 'Sağlıksız';
  }
}
