import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About & Theorem Info'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.air,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FluxCast',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Weather prediction through physics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FluxCast combines traditional meteorology with advanced vector calculus to provide unique insights into atmospheric behavior using Gauss\'s Divergence Theorem and Stokes\' Circulation Theorem.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Gauss theorem section
            Text(
              'Gauss\'s Divergence Theorem',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '∮∮ F·n dS = ∭ ∇·F dV',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Visual diagram explanation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🎯 How FluxCast Uses Gauss Theorem',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildGaussStep(context, '1️⃣', 'Select Region', 'You choose a 3D atmospheric volume using lat/lon bounds and altitude range'),
                          _buildGaussStep(context, '2️⃣', 'Get Wind Data', 'FluxCast fetches wind vectors (u,v,w) from OpenWeatherMap API for grid points'),
                          _buildGaussStep(context, '3️⃣', 'Calculate Divergence', '∇·F = ∂u/∂x + ∂v/∂y + ∂w/∂z at each point'),
                          _buildGaussStep(context, '4️⃣', 'Surface Integral', 'Measures net air flow through the boundary of your volume'),
                          _buildGaussStep(context, '5️⃣', 'Physical Meaning', 'Positive = Air expanding (Low pressure forming)\nNegative = Air converging (High pressure forming)'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Atmospheric interpretation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🌬️', style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Atmospheric Physics Explained',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildPhysicsExplanation(context, '📤 Positive Flux (Outflow)', 'Air is leaving the volume faster than entering', 'Creates low pressure → Rising air → Clouds, storms possible'),
                          _buildPhysicsExplanation(context, '📥 Negative Flux (Inflow)', 'Air is entering the volume faster than leaving', 'Creates high pressure → Sinking air → Clear, stable weather'),
                          _buildPhysicsExplanation(context, '⚖️ Balanced Flux', 'Equal inflow and outflow', 'Stable conditions → Minimal pressure changes'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Text(
                      'Real-World Applications:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(context, 'Hurricane tracking: Detect circulation centers'),
                    _buildBulletPoint(context, 'Weather fronts: Identify air mass boundaries'),
                    _buildBulletPoint(context, 'Aviation safety: Predict turbulence zones'),
                    _buildBulletPoint(context, 'Climate modeling: Understand large-scale patterns'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stokes theorem section
            Text(
              'Stokes\' Circulation Theorem',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '∮ F·dr = ∬ (∇ × F)·n dS',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Visual diagram explanation for Stokes
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '🌪️ How FluxCast Uses Stokes Theorem',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildStokesStep(context, '1️⃣', 'Draw Path', 'You draw a closed loop on the map (or use quick options like circular/square)'),
                          _buildStokesStep(context, '2️⃣', 'Get Wind Vectors', 'FluxCast fetches wind data (u,v) around and inside your path'),
                          _buildStokesStep(context, '3️⃣', 'Calculate Curl', '∇ × F = ∂v/∂x - ∂u/∂y (measures rotation at each point)'),
                          _buildStokesStep(context, '4️⃣', 'Line Integral', '∮ F·dr = Sum of wind flow along your path boundary'),
                          _buildStokesStep(context, '5️⃣', 'Storm Detection', 'High circulation + high curl = Potential vortex/storm formation'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Circulation interpretation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('🌀', style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Circulation Physics Explained',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildCirculationExplanation(context, '🔄 Positive Circulation', 'Counterclockwise wind flow around your path', 'Low pressure center → Rising air → Storm potential'),
                          _buildCirculationExplanation(context, '🔃 Negative Circulation', 'Clockwise wind flow around your path', 'High pressure center → Sinking air → Stable conditions'),
                          _buildCirculationExplanation(context, '🎯 High Curl Magnitude', 'Strong rotational patterns detected', 'Vorticity present → Monitor for storm development'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Storm formation diagram
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('⚠️', style: const TextStyle(fontSize: 24)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Storm Formation Indicators',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildStormIndicator(context, '🌪️ High Circulation (>1000 m²/s)', 'Strong wind rotation around the path'),
                          _buildStormIndicator(context, '🌀 High Curl (>0.015 s⁻¹)', 'Intense rotational activity in the area'),
                          _buildStormIndicator(context, '⚡ Combined Effect', 'Both high circulation AND high curl = Storm risk'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text('💡', style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Real hurricanes show circulation values of 10,000+ m²/s with curl magnitudes exceeding 0.1 s⁻¹',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Text(
                      'Real-World Applications:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(context, 'Hurricane eye detection: Find the circulation center'),
                    _buildBulletPoint(context, 'Tornado tracking: Identify mesocyclone rotation'),
                    _buildBulletPoint(context, 'Wind shear analysis: Detect dangerous aviation conditions'),
                    _buildBulletPoint(context, 'Ocean currents: Study large-scale circulation patterns'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How it works section
            Text(
              'How FluxCast Works',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepItem(
                      context,
                      '1',
                      'Data Collection',
                      'Real-time weather data from OpenWeatherMap API including wind vectors, temperature, and pressure fields.',
                      Icons.cloud_download,
                    ),
                    _buildStepItem(
                      context,
                      '2',
                      'Vector Field Construction',
                      'Weather parameters are converted into mathematical vector fields suitable for calculus operations.',
                      Icons.grid_on,
                    ),
                    _buildStepItem(
                      context,
                      '3',
                      'Theorem Application',
                      'Gauss and Stokes theorems are applied to compute divergence, curl, flux, and circulation values.',
                      Icons.calculate,
                    ),
                    _buildStepItem(
                      context,
                      '4',
                      'Physical Interpretation',
                      'Mathematical results are translated into meteorological insights and weather predictions.',
                      Icons.insights,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // References section
            Text(
              'Further Reading',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildReferenceItem(
                      context,
                      'Vector Calculus in Meteorology',
                      'Understanding atmospheric dynamics through mathematical analysis',
                    ),
                    _buildReferenceItem(
                      context,
                      'Fluid Dynamics and Weather Systems',
                      'Application of vector field theory to atmospheric science',
                    ),
                    _buildReferenceItem(
                      context,
                      'Numerical Weather Prediction',
                      'Modern computational approaches to weather forecasting',
                    ),
                    _buildReferenceItem(
                      context,
                      'Atmospheric Physics',
                      'Physical principles governing weather and climate',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Credits
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Credits',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Weather data provided by OpenWeatherMap API\nBuilt with Flutter and Python FastAPI\nMathematical computations using NumPy and SciPy',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
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

  Widget _buildStepItem(BuildContext context, String number, String title, 
                       String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildGaussStep(BuildContext context, String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicsExplanation(BuildContext context, String title, String description, String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              result,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStokesStep(BuildContext context, String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCirculationExplanation(BuildContext context, String title, String description, String result) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple[100],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              result,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.purple[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStormIndicator(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: Colors.red[600],
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}