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
                    
                    // Interactive map area
                    GestureDetector(
                      onTapDown: (details) => _addPointFromTap(details),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Theme.of(context).colorScheme.tertiary),
                        ),
                        child: CustomPaint(
                          painter: PathPainter(_pathPoints, Theme.of(context).colorScheme.tertiary),
                          child: _pathPoints.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.touch_app,
                                        size: 48,
                                        color: Theme.of(context).colorScheme.tertiary,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to add points\nCreate a closed path',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.tertiary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : null,
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

  void _addPointFromTap(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = details.localPosition;
    
    // Convert tap position to lat/lon coordinates (simplified mapping)
    // This is a basic conversion for demonstration
    final lat = 40.7128 + (100 - localPosition.dy) * 0.001; // Rough conversion
    final lon = -74.0060 + (localPosition.dx - 100) * 0.001; // Rough conversion
    
    setState(() {
      _pathPoints.add({'lat': lat, 'lon': lon});
    });
  }

  void _performAnalysis() async {
    setState(() => _isAnalyzing = true);
    
    try {
      // Simulate analysis delay
      await Future.delayed(const Duration(seconds: 3));
      
      // Generate random realistic values for demo
      final circulation = (500 + (DateTime.now().millisecond % 1000)).toDouble();
      final curlMagnitude = (0.005 + (DateTime.now().millisecond % 20) * 0.001);
      final isStormRisk = curlMagnitude > 0.015;
      
      // Show enhanced results dialog
      if (mounted) {
        _showStokesResultDialog(circulation, curlMagnitude, isStormRisk);
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

  void _showStokesResultDialog(double circulation, double curlMagnitude, bool isStormRisk) {
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
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '🌪️',
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Stokes Analysis Complete',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circulation Result
                    _buildResultCard(
                      '🔄',
                      'Circulation',
                      '${circulation.toStringAsFixed(1)} m²/s',
                      circulation > 800 ? 'Strong' : circulation > 400 ? 'Moderate' : 'Weak',
                      circulation > 800 ? Colors.red : circulation > 400 ? Colors.orange : Colors.green,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Curl Magnitude
                    _buildResultCard(
                      '🌀',
                      'Curl Magnitude',
                      '${curlMagnitude.toStringAsFixed(3)} s⁻¹',
                      curlMagnitude > 0.015 ? 'High Rotation' : curlMagnitude > 0.010 ? 'Moderate' : 'Low Rotation',
                      curlMagnitude > 0.015 ? Colors.red : curlMagnitude > 0.010 ? Colors.orange : Colors.green,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Storm Detection
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isStormRisk ? Colors.red[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isStormRisk ? Colors.red[200]! : Colors.green[200]!,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isStormRisk ? '⚠️' : '✅',
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Storm Detection',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isStormRisk ? 'High Risk - Monitor Closely' : 'Low Risk - Stable Conditions',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isStormRisk ? Colors.red[700] : Colors.green[700],
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
                            _getStokesInterpretation(circulation, curlMagnitude, isStormRisk),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Got it!'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultCard(String emoji, String title, String value, String status, Color statusColor) {
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

  String _getStokesInterpretation(double circulation, double curlMagnitude, bool isStormRisk) {
    String direction = circulation > 0 ? 'counterclockwise' : 'clockwise';
    String strength = circulation.abs() > 800 ? 'Strong' : circulation.abs() > 400 ? 'Moderate' : 'Weak';
    
    if (isStormRisk) {
      return '$strength $direction circulation with high rotational activity detected. The elevated curl magnitude suggests potential vortex formation. Weather conditions may become unstable with possible storm development.';
    } else {
      return '$strength $direction circulation with low rotational activity. The curl field shows minimal vorticity, indicating stable atmospheric conditions with low probability of storm formation.';
    }
  }
}

// Custom painter for drawing the path
class PathPainter extends CustomPainter {
  final List<Map<String, double>> points;
  final Color color;

  PathPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw lines connecting points
    if (points.length > 1) {
      final path = Path();
      
      // Convert first point to screen coordinates
      final firstPoint = _latLonToScreen(points[0], size);
      path.moveTo(firstPoint.dx, firstPoint.dy);
      
      // Draw lines to other points
      for (int i = 1; i < points.length; i++) {
        final screenPoint = _latLonToScreen(points[i], size);
        path.lineTo(screenPoint.dx, screenPoint.dy);
      }
      
      // Close the path if we have enough points
      if (points.length >= 3) {
        path.close();
      }
      
      canvas.drawPath(path, paint);
    }

    // Draw points
    for (int i = 0; i < points.length; i++) {
      final screenPoint = _latLonToScreen(points[i], size);
      canvas.drawCircle(screenPoint, 6, pointPaint);
      
      // Draw point number
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${i + 1}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          screenPoint.dx - textPainter.width / 2,
          screenPoint.dy - textPainter.height / 2,
        ),
      );
    }
  }

  Offset _latLonToScreen(Map<String, double> point, Size size) {
    // Simple conversion from lat/lon to screen coordinates
    // This is a basic mapping for demonstration
    final lat = point['lat']!;
    final lon = point['lon']!;
    
    // Map lat/lon to screen coordinates (simplified)
    final x = (lon + 74.0060) * 1000 + size.width / 2;
    final y = (40.7128 - lat) * 1000 + size.height / 2;
    
    return Offset(
      x.clamp(0, size.width),
      y.clamp(0, size.height),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}