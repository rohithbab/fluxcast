class WeatherData {
  final double temperature;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double windDirection;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String locationName;
  final String description;
  final String icon;

  WeatherData({
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDirection,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.description,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      pressure: json['main']['pressure'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      windDirection: json['wind']['deg']?.toDouble() ?? 0.0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      latitude: json['coord']['lat'].toDouble(),
      longitude: json['coord']['lon'].toDouble(),
      locationName: json['name'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}

class GaussAnalysisResult {
  final double netFlux;
  final String fluxUnit;
  final String interpretation;
  final Map<String, dynamic> visualizationData;
  final Map<String, dynamic> computationDetails;

  GaussAnalysisResult({
    required this.netFlux,
    required this.fluxUnit,
    required this.interpretation,
    required this.visualizationData,
    required this.computationDetails,
  });

  factory GaussAnalysisResult.fromJson(Map<String, dynamic> json) {
    return GaussAnalysisResult(
      netFlux: json['net_flux'].toDouble(),
      fluxUnit: json['flux_unit'],
      interpretation: json['interpretation'],
      visualizationData: json['visualization_data'],
      computationDetails: json['computation_details'],
    );
  }
}

class StokesAnalysisResult {
  final double circulation;
  final String circulationUnit;
  final double curlMagnitude;
  final String interpretation;
  final bool stormDetection;
  final Map<String, dynamic> visualizationData;
  final Map<String, dynamic> computationDetails;

  StokesAnalysisResult({
    required this.circulation,
    required this.circulationUnit,
    required this.curlMagnitude,
    required this.interpretation,
    required this.stormDetection,
    required this.visualizationData,
    required this.computationDetails,
  });

  factory StokesAnalysisResult.fromJson(Map<String, dynamic> json) {
    return StokesAnalysisResult(
      circulation: json['circulation'].toDouble(),
      circulationUnit: json['circulation_unit'],
      curlMagnitude: json['curl_magnitude'].toDouble(),
      interpretation: json['interpretation'],
      stormDetection: json['storm_detection'],
      visualizationData: json['visualization_data'],
      computationDetails: json['computation_details'],
    );
  }
}