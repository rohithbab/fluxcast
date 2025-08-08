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
                    Text(
                      'Mathematical Meaning:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The surface integral of a vector field over a closed surface equals the volume integral of the divergence of the field over the region enclosed by the surface.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Weather Application:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(context, 'Measures net atmospheric flux through a volume'),
                    _buildBulletPoint(context, 'Detects air mass convergence or divergence'),
                    _buildBulletPoint(context, 'Helps predict pressure system development'),
                    _buildBulletPoint(context, 'Analyzes vertical air movement patterns'),
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
                    Text(
                      'Mathematical Meaning:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The line integral of a vector field around a closed curve equals the surface integral of the curl of the field over any surface bounded by the curve.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Weather Application:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBulletPoint(context, 'Measures atmospheric circulation patterns'),
                    _buildBulletPoint(context, 'Detects rotational wind systems'),
                    _buildBulletPoint(context, 'Identifies potential storm formation'),
                    _buildBulletPoint(context, 'Analyzes vorticity and cyclonic activity'),
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
}