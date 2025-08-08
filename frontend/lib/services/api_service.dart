import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Change for production
  static const String weatherApiKey = 'aa19ff4b6a01ff024adcd554b6c22198';
  
  // Get current weather from backend
  Future<WeatherData> getCurrentWeather(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather/current?lat=$lat&lon=$lon'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WeatherData.fromJson(data);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to direct OpenWeatherMap API
      return await _getWeatherFromOpenWeatherMap(lat, lon);
    }
  }

  // Fallback method to get weather directly from OpenWeatherMap
  Future<WeatherData> _getWeatherFromOpenWeatherMap(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric'
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherData.fromJson(data);
    } else {
      throw Exception('Failed to load weather data from OpenWeatherMap');
    }
  }

  // Perform Gauss analysis
  Future<GaussAnalysisResult> performGaussAnalysis({
    required double north,
    required double south,
    required double east,
    required double west,
    int resolution = 10,
  }) async {
    final requestBody = {
      'bounds': {
        'north': north,
        'south': south,
        'east': east,
        'west': west,
        'altitude_min': 0.0,
        'altitude_max': 1000.0,
      },
      'resolution': resolution,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/analysis/gauss'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return GaussAnalysisResult.fromJson(data);
    } else {
      throw Exception('Failed to perform Gauss analysis: ${response.statusCode}');
    }
  }

  // Perform Stokes analysis
  Future<StokesAnalysisResult> performStokesAnalysis({
    required List<Map<String, double>> pathPoints,
    int resolution = 10,
  }) async {
    final requestBody = {
      'path_points': pathPoints.map((point) => [point['lat']!, point['lon']!]).toList(),
      'resolution': resolution,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/analysis/stokes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return StokesAnalysisResult.fromJson(data);
    } else {
      throw Exception('Failed to perform Stokes analysis: ${response.statusCode}');
    }
  }

  // Get forecast data
  Future<Map<String, dynamic>> getForecast(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to OpenWeatherMap forecast API
      return await _getForecastFromOpenWeatherMap(lat, lon);
    }
  }

  Future<Map<String, dynamic>> _getForecastFromOpenWeatherMap(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$weatherApiKey&units=metric'
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'forecast': data['list'].take(8).map((item) => WeatherData.fromJson({
          ...item,
          'coord': {'lat': lat, 'lon': lon},
          'name': data['city']['name'],
        })).toList(),
        'location': data['city']['name'],
      };
    } else {
      throw Exception('Failed to load forecast data from OpenWeatherMap');
    }
  }
}