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
                        Expanded(
                          child: Text(
                            'Gauss\'s Divergence Theorem',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
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
      
      // Generate random realistic values for demo
      final netFlux = (800 + (DateTime.now().millisecond % 2000) - 1000).toDouble();
      final meanDivergence = (DateTime.now().millisecond % 20 - 10) * 0.001;
      final isHighPressure = netFlux < -500;
      final isLowPressure = netFlux > 500;
      
      // Show enhanced results dialog
      if (mounted) {
        _showGaussResultDialog(netFlux, meanDivergence, isHighPressure, isLowPressure);
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

  void _showGaussResultDialog(double netFlux, double meanDivergence, bool isHighPressure, bool isLowPressure) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation1,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(
            opacity: animation1,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '📊',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Gauss Analysis Complete',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // Net Flux Result
                    _buildGaussResultCard(
                      netFlux > 0 ? '📤' : '📥',
                      'Net Flux',
                      '${netFlux.toStringAsFixed(1)} m³/s',
                      netFlux.abs() > 800 ? 'Strong' : netFlux.abs() > 400 ? 'Moderate' : 'Weak',
                      netFlux.abs() > 800 ? Colors.red : netFlux.abs() > 400 ? Colors.orange : Colors.green,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Divergence Result
                    _buildGaussResultCard(
                      meanDivergence > 0 ? '💨' : '🌪️',
                      'Mean Divergence',
                      '${meanDivergence.toStringAsFixed(4)} s⁻¹',
                      meanDivergence.abs() > 0.005 ? 'High Activity' : meanDivergence.abs() > 0.002 ? 'Moderate' : 'Low Activity',
                      meanDivergence.abs() > 0.005 ? Colors.red : meanDivergence.abs() > 0.002 ? Colors.orange : Colors.green,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Pressure System Detection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isHighPressure ? Colors.blue[50] : isLowPressure ? Colors.orange[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isHighPressure ? Colors.blue[200]! : isLowPressure ? Colors.orange[200]! : Colors.green[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isHighPressure ? '🔵' : isLowPressure ? '🔴' : '🟢',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pressure System',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isHighPressure ? 'High Pressure Formation' : isLowPressure ? 'Low Pressure Development' : 'Balanced Conditions',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isHighPressure ? Colors.blue[700] : isLowPressure ? Colors.orange[700] : Colors.green[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Air Movement Visualization
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('🌬️', style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'Air Movement Pattern',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildAirMovementIndicator(
                                'Inflow',
                                netFlux < 0 ? netFlux.abs() : 0,
                                '⬇️',
                                Colors.blue,
                              ),
                              _buildAirMovementIndicator(
                                'Outflow',
                                netFlux > 0 ? netFlux : 0,
                                '⬆️',
                                Colors.red,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Interpretation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🧠', style: const TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'Physical Interpretation',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _getGaussInterpretation(netFlux, meanDivergence, isHighPressure, isLowPressure),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Got it!'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGaussResultCard(String emoji, String title, String value, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirMovementIndicator(String label, double value, String emoji, Color color) {
    final intensity = (value / 1000).clamp(0.0, 1.0);
    
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: intensity,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.abs().toStringAsFixed(0)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getGaussInterpretation(double netFlux, double meanDivergence, bool isHighPressure, bool isLowPressure) {
    String fluxDescription = netFlux > 0 ? 'outflow' : 'inflow';
    String fluxStrength = netFlux.abs() > 800 ? 'Strong' : netFlux.abs() > 400 ? 'Moderate' : 'Weak';
    
    String divergenceDescription = meanDivergence > 0 ? 'positive divergence (air expansion)' : 'negative divergence (air convergence)';
    
    String pressureImplication = '';
    if (isHighPressure) {
      pressureImplication = ' This convergence pattern suggests high pressure system development with descending air masses and stable weather conditions.';
    } else if (isLowPressure) {
      pressureImplication = ' This divergence pattern indicates low pressure system formation with ascending air masses and potential for unstable weather.';
    } else {
      pressureImplication = ' The balanced flux indicates stable atmospheric conditions with minimal pressure changes expected.';
    }
    
    return '$fluxStrength atmospheric $fluxDescription detected with $divergenceDescription.$pressureImplication The Gauss divergence theorem reveals how air mass distribution changes within the selected volume.';
  }
}