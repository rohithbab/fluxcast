import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class GaussAnalysisScreen extends ConsumerStatefulWidget {
  const GaussAnalysisScreen({super.key});

  @override
  ConsumerState<GaussAnalysisScreen> createState() => _GaussAnalysisScreenState();
}

class _GaussAnalysisScreenState extends ConsumerState<GaussAnalysisScreen> {
  double _north = 40.8;
  double _south = 40.6;
  double _east = -73.8;
  double _west = -74.2;
  int _resolution = 10;
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gauss Divergence Analysis'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theory explanation card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Gauss\'s Divergence Theorem',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '∮∮ F·n dS = ∭ ∇·F dV',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This theorem relates the flux of a vector field through a closed surface to the divergence of the field inside the volume. In weather analysis, it helps us understand air mass movement and atmospheric flux patterns.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Region selection
            Text(
              'Select Analysis Region',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildCoordinateSlider('North Latitude', _north, 35.0, 45.0, (value) {
                      setState(() => _north = value);
                    }),
                    _buildCoordinateSlider('South Latitude', _south, 35.0, 45.0, (value) {
                      setState(() => _south = value);
                    }),
                    _buildCoordinateSlider('East Longitude', _east, -80.0, -70.0, (value) {
                      setState(() => _east = value);
                    }),
                    _buildCoordinateSlider('West Longitude', _west, -80.0, -70.0, (value) {
                      setState(() => _west = value);
                    }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Resolution: '),
                        Expanded(
                          child: Slider(
                            value: _resolution.toDouble(),
                            min: 5,
                            max: 20,
                            divisions: 15,
                            label: _resolution.toString(),
                            onChanged: (value) {
                              setState(() => _resolution = value.round());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analysis button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _performAnalysis,
                icon: _isAnalyzing 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.analytics),
                label: Text(_isAnalyzing ? 'Analyzing...' : 'Perform Gauss Analysis'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Results placeholder
            if (_isAnalyzing)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Computing atmospheric flux using Gauss\'s Divergence Theorem...',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            // Educational content
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What This Analysis Shows',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBulletPoint('Net atmospheric flux through the selected volume'),
                    _buildBulletPoint('Air mass convergence or divergence patterns'),
                    _buildBulletPoint('Pressure system development indicators'),
                    _buildBulletPoint('Vertical air movement estimation'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label),
          ),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: 100,
              label: value.toStringAsFixed(2),
              onChanged: onChanged,
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              value.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _performAnalysis() async {
    setState(() => _isAnalyzing = true);
    
    try {
      // Simulate analysis delay
      await Future.delayed(const Duration(seconds: 3));
      
      // Show results dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Analysis Complete'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Flux: 1,234.5 m³/s'),
                const SizedBox(height: 8),
                Text('Interpretation: Moderate outflow detected - air mass is expanding, indicating potential low pressure development.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }
}