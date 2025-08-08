from pydantic import BaseModel
from typing import List, Tuple, Optional
from datetime import datetime

class WeatherData(BaseModel):
    temperature: float
    humidity: float
    pressure: float
    wind_speed: float
    wind_direction: float
    timestamp: datetime
    location: Tuple[float, float]  # (lat, lon)

class VectorField(BaseModel):
    u_component: List[List[float]]  # Wind velocity x-component
    v_component: List[List[float]]  # Wind velocity y-component
    w_component: List[List[float]]  # Wind velocity z-component (estimated)
    coordinates: List[List[Tuple[float, float]]]  # Grid coordinates
    
class GeographicBounds(BaseModel):
    north: float
    south: float
    east: float
    west: float
    altitude_min: float = 0.0
    altitude_max: float = 1000.0  # meters

class GaussAnalysisRequest(BaseModel):
    bounds: GeographicBounds
    resolution: int = 10  # Grid resolution

class GaussAnalysisResult(BaseModel):
    net_flux: float
    flux_unit: str
    interpretation: str
    visualization_data: dict
    computation_details: dict

class StokesAnalysisRequest(BaseModel):
    path_points: List[Tuple[float, float]]  # Closed loop coordinates
    resolution: int = 10

class StokesAnalysisResult(BaseModel):
    circulation: float
    circulation_unit: str
    curl_magnitude: float
    interpretation: str
    storm_detection: bool
    visualization_data: dict
    computation_details: dict

class ForecastData(BaseModel):
    current_weather: WeatherData
    hourly_forecast: List[WeatherData]
    gauss_insights: List[str]
    stokes_insights: List[str]
    storm_probability: float