# FluxCast - Weather Prediction Through Physics

A mobile application that uses Gauss's Divergence Theorem and Stokes' Theorem to analyze atmospheric flux and circulation patterns using live weather data.

## 🌟 Features

- **Real-time Weather Analysis**: Live data from OpenWeatherMap API
- **Gauss Divergence Analysis**: Atmospheric flux and air mass movement detection
- **Stokes Circulation Analysis**: Storm formation and rotational pattern detection
- **Physics-Based Forecasting**: 24-48 hour predictions with theorem insights
- **Educational Content**: Learn about vector calculus in meteorology
- **Interactive Visualizations**: Maps, charts, and vector field displays

## 🏗️ Project Structure

```
fluxcast/
├── frontend/                 # Flutter mobile app
│   ├── lib/
│   │   ├── screens/         # App screens (splash, home, analysis, etc.)
│   │   ├── widgets/         # Reusable UI components
│   │   ├── models/          # Data models
│   │   ├── services/        # API services
│   │   ├── providers/       # State management
│   │   └── theme/           # App theming
│   └── pubspec.yaml
├── backend/                 # Python FastAPI server
│   ├── main.py             # FastAPI application
│   ├── models/             # Pydantic models
│   ├── services/           # Business logic
│   │   ├── weather_service.py    # Weather API integration
│   │   ├── gauss_service.py      # Gauss theorem calculations
│   │   └── stokes_service.py     # Stokes theorem calculations
│   └── requirements.txt
├── start_backend.py        # Backend startup script
├── start_fluxcast.bat     # Windows startup script
└── README.md
```

## 🚀 Quick Start

### Option 1: Windows Users (Easiest)
1. Double-click `start_fluxcast.bat`
2. Wait for backend to start
3. Open another terminal and run the Flutter app

### Option 2: Manual Setup

#### Backend Setup
```bash
# Install Python dependencies
pip install -r backend/requirements.txt

# Start the backend server
python start_backend.py
```

The backend will be available at:
- API: http://localhost:8000
- Documentation: http://localhost:8000/docs

#### Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Run the app (requires Flutter SDK)
flutter run
```

## 🔧 Tech Stack

- **Frontend**: Flutter (Dart) - Cross-platform mobile development
- **Backend**: Python FastAPI - High-performance API framework
- **Weather Data**: OpenWeatherMap API - Real-time weather information
- **Mathematics**: NumPy, SciPy - Vector calculus computations
- **Visualization**: FL Chart, Syncfusion Charts - Data visualization
- **State Management**: Riverpod - Reactive state management

## 📱 App Screens

1. **Splash Screen**: App introduction with wind animation
2. **Home Dashboard**: Current weather and analysis options
3. **Gauss Analysis**: Divergence theorem calculations and flux visualization
4. **Stokes Analysis**: Circulation theorem and rotational pattern detection
5. **Forecast Screen**: Physics-based weather predictions
6. **About Screen**: Educational content about the theorems

## 🧮 Physics Implementation

### Gauss's Divergence Theorem
```
∮∮ F·n dS = ∭ ∇·F dV
```
- Computes atmospheric flux through selected volumes
- Detects air mass convergence/divergence
- Predicts pressure system development

### Stokes' Circulation Theorem
```
∮ F·dr = ∬ (∇ × F)·n dS
```
- Measures circulation around closed paths
- Detects rotational wind patterns
- Identifies storm formation potential

## 🌐 API Endpoints

- `GET /weather/current` - Current weather data
- `POST /analysis/gauss` - Perform Gauss divergence analysis
- `POST /analysis/stokes` - Perform Stokes circulation analysis
- `GET /forecast` - Weather forecast with physics insights

## 📋 Requirements

### Backend
- Python 3.8+
- FastAPI
- NumPy, SciPy
- Requests, aiohttp

### Frontend
- Flutter SDK 3.10+
- Dart 3.0+
- Android Studio / VS Code

## 🔑 API Configuration

The app uses OpenWeatherMap API with the key: `aa19ff4b6a01ff024adcd554b6c22198`

For production use, replace this with your own API key in:
- `backend/services/weather_service.py`
- `frontend/lib/services/api_service.dart`

## 🎯 Usage Examples

### Gauss Analysis
1. Select a geographic region on the map
2. Choose grid resolution (5-20 points)
3. Analyze atmospheric flux patterns
4. Interpret convergence/divergence results

### Stokes Analysis
1. Draw or select a closed path on the map
2. Set analysis resolution
3. Compute circulation and curl values
4. Detect potential storm formation

## 🚧 Development Status

This is a functional prototype demonstrating:
- ✅ Complete backend API with theorem implementations
- ✅ Flutter frontend with all major screens
- ✅ Real weather data integration
- ✅ Educational content and visualizations
- 🔄 Interactive map features (placeholder implementation)
- 🔄 Advanced visualization components
- 🔄 Production deployment configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is for educational purposes, demonstrating the application of vector calculus in meteorology.

## 🙏 Acknowledgments

- OpenWeatherMap for weather data API
- Flutter team for the excellent mobile framework
- FastAPI for the high-performance backend framework
- NumPy/SciPy communities for mathematical computing tools