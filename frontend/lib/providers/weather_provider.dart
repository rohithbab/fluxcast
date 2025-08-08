import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final weatherProvider = StateNotifierProvider<WeatherNotifier, AsyncValue<WeatherData>>((ref) {
  return WeatherNotifier(ref.read(apiServiceProvider));
});

class WeatherNotifier extends StateNotifier<AsyncValue<WeatherData>> {
  final ApiService _apiService;

  WeatherNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> getCurrentWeather() async {
    try {
      state = const AsyncValue.loading();
      
      // Get current location
      final position = await _getCurrentPosition();
      
      // Fetch weather data
      final weather = await _apiService.getCurrentWeather(
        position.latitude,
        position.longitude,
      );
      
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> getWeatherForLocation(double lat, double lon) async {
    try {
      state = const AsyncValue.loading();
      
      final weather = await _apiService.getCurrentWeather(lat, lon);
      state = AsyncValue.data(weather);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Use default location (New York) if location services are disabled
      return Position(
        longitude: -74.0060,
        latitude: 40.7128,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Use default location if permission is denied
        return Position(
          longitude: -74.0060,
          latitude: 40.7128,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Use default location if permission is permanently denied
      return Position(
        longitude: -74.0060,
        latitude: 40.7128,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
      );
    }

    // Get current position
    return await Geolocator.getCurrentPosition();
  }
}

// Provider for Gauss analysis
final gaussAnalysisProvider = FutureProvider.family<GaussAnalysisResult, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.performGaussAnalysis(
    north: params['north'],
    south: params['south'],
    east: params['east'],
    west: params['west'],
    resolution: params['resolution'] ?? 10,
  );
});

// Provider for Stokes analysis
final stokesAnalysisProvider = FutureProvider.family<StokesAnalysisResult, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.performStokesAnalysis(
    pathPoints: List<Map<String, double>>.from(params['pathPoints']),
    resolution: params['resolution'] ?? 10,
  );
});

// Provider for forecast data
final forecastProvider = FutureProvider.family<Map<String, dynamic>, Map<String, double>>((ref, coords) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getForecast(coords['lat']!, coords['lon']!);
});