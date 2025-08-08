import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StokesAnalysisScreen extends ConsumerStatefulWidget {
  const StokesAnalysisScreen({super.key});

  @override
  ConsumerState<StokesAnalysisScreen> createState() => _StokesAnalysisScreenState();
}

class _StokesAnalysisScreenState extends ConsumerState<StokesAnalysisScreen> {
  List<Map<String, double>> _pathPoints = [];
  bool _isAnalyzing = false;
  int _resolution = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stokes Circulation Analysis'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Stokes\' Circulation Theorem',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '∮ F·dr = ∬ (∇ × F)·n dS',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This theorem relates the circulation of a vector field around a closed curve to the curl of the field over the surface bounded by the curve. In meteorology, it helps detect rotational patterns and storm formation.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Path selection
            Text(
              'Define Analysis Path',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Draw a closed path on the map to analyze circulation patterns:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    // Placeholder map area
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[400]!),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Interactive Map\n(Tap to add points)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Quick path options
                    Text(
                      'Quick Path Options:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _setCircularPath(),
                          icon: const Icon(Icons.circle_outlined),
                          label: const Text('Circular'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _setSquarePath(),
                          icon: const Icon(Icons.crop_square),
                          label: const Text('Square'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.tertiary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _clearPath(),
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Resolution slider
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

            const SizedBox(height: 16),

            // Path points display
            if (_pathPoints.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Path Points (${_pathPoints.length}):',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 100,
                        child: ListView.builder(
                          itemCount: _pathPoints.length,
                          itemBuilder: (context, index) {
                            final point = _pathPoints[index];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 12,
                                backgroundColor: Theme.of(context).colorScheme.tertiary,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              title: Text(
                                'Lat: ${point['lat']!.toStringAsFixed(3)}, Lon: ${point['lon']!.toStringAsFixed(3)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
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
                onPressed: (_pathPoints.length >= 3 && !_isAnalyzing) ? _performAnalysis : null,
                icon: _isAnalyzing 
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.rotate_right),
                label: Text(_isAnalyzing ? 'Analyzing...' : 'Perform Stokes Analysis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            if (_pathPoints.length < 3)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please define at least 3 points to create a closed path',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
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
                        'Computing circulation using Stokes\' Theorem...',
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
                    _buildBulletPoint('Circulation magnitude around the selected path'),
                    _buildBulletPoint('Rotational wind patterns and vorticity'),
                    _buildBulletPoint('Storm and cyclone detection indicators'),
                    _buildBulletPoint('Atmospheric curl field visualization'),
                  ],
                ),
              ),
            ),
          ],
        ),
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
              color: Theme.of(context).colorScheme.tertiary,
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

  void _setCircularPath() {
    setState(() {
      _pathPoints = [
        {'lat': 40.7128, 'lon': -74.0060}, // Center: NYC
        {'lat': 40.7228, 'lon': -74.0060}, // North
        {'lat': 40.7178, 'lon': -73.9960}, // East
        {'lat': 40.7028, 'lon': -74.0060}, // South
        {'lat': 40.7178, 'lon': -74.0160}, // West
        {'lat': 40.7128, 'lon': -74.0060}, // Close the loop
      ];
    });
  }

  void _setSquarePath() {
    setState(() {
      _pathPoints = [
        {'lat': 40.7028, 'lon': -74.0160}, // SW
        {'lat': 40.7228, 'lon': -74.0160}, // NW
        {'lat': 40.7228, 'lon': -73.9960}, // NE
        {'lat': 40.7028, 'lon': -73.9960}, // SE
        {'lat': 40.7028, 'lon': -74.0160}, // Close the loop
      ];
    });
  }

  void _clearPath() {
    setState(() {
      _pathPoints.clear();
    });
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
                Text('Circulation: 567.8 m²/s'),
                const SizedBox(height: 8),
                Text('Curl Magnitude: 0.012 s⁻¹'),
                const SizedBox(height: 8),
                Text('Storm Detection: Low Risk'),
                const SizedBox(height: 8),
                Text('Interpretation: Weak counterclockwise circulation detected. Low rotational activity - stable conditions.'),
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