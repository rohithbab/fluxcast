import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _windController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _windController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await _fadeController.forward();
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _windController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon with wind animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: AnimatedBuilder(
                animation: _windController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _windController.value * 2 * 3.14159,
                    child: const Icon(
                      Icons.air,
                      size: 60,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ).animate().scale(
              duration: 800.ms,
              curve: Curves.elasticOut,
            ),
            
            const SizedBox(height: 40),
            
            // App Name
            FadeTransition(
              opacity: _fadeController,
              child: Text(
                'FluxCast',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ).animate().slideY(
              begin: 0.3,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
            
            const SizedBox(height: 16),
            
            // Tagline
            FadeTransition(
              opacity: _fadeController,
              child: Text(
                'Weather prediction through physics',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ).animate().slideY(
              begin: 0.5,
              duration: 800.ms,
              curve: Curves.easeOut,
            ),
            
            const SizedBox(height: 60),
            
            // Loading indicator with wind particles
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Initializing atmospheric calculations...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(
              delay: 1000.ms,
              duration: 500.ms,
            ),
          ],
        ),
      ),
    );
  }
}