import aiohttp
import numpy as np
from typing import List, Tuple
from datetime import datetime
from models.weather_models import WeatherData, VectorField, GeographicBounds

class WeatherService:
    def __init__(self):
        self.api_key = "aa19ff4b6a01ff024adcd554b6c22198"
        self.base_url = "https://api.openweathermap.org/data/2.5"
        
    async def get_current_weather(self, lat: float, lon: float) -> WeatherData:
        """Fetch current weather data from OpenWeatherMap API"""
        url = f"{self.base_url}/weather"
        params = {
            "lat": lat,
            "lon": lon,
            "appid": self.api_key,
            "units": "metric"
        }
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url, params=params) as response:
                data = await response.json()
                
                return WeatherData(
                    temperature=data["main"]["temp"],
                    humidity=data["main"]["humidity"],
                    pressure=data["main"]["pressure"],
                    wind_speed=data["wind"]["speed"],
                    wind_direction=data["wind"].get("deg", 0),
                    timestamp=datetime.now(),
                    location=(lat, lon)
                )
    
    async def get_vector_field(self, bounds: GeographicBounds, resolution: int) -> VectorField:
        """Generate vector field data for Gauss analysis"""
        # Create grid points within bounds
        lat_points = np.linspace(bounds.south, bounds.north, resolution)
        lon_points = np.linspace(bounds.west, bounds.east, resolution)
        
        u_component = []
        v_component = []
        w_component = []
        coordinates = []
        
        for i, lat in enumerate(lat_points):
            u_row = []
            v_row = []
            w_row = []
            coord_row = []
            
            for j, lon in enumerate(lon_points):
                # Fetch weather data for each grid point
                try:
                    weather = await self.get_current_weather(lat, lon)
                    
                    # Convert wind speed and direction to u, v components
                    wind_rad = np.radians(weather.wind_direction)
                    u = weather.wind_speed * np.cos(wind_rad)
                    v = weather.wind_speed * np.sin(wind_rad)
                    
                    # Estimate w component based on pressure gradient
                    w = self._estimate_vertical_velocity(weather.pressure)
                    
                    u_row.append(u)
                    v_row.append(v)
                    w_row.append(w)
                    coord_row.append((lat, lon))
                    
                except Exception:
                    # Use interpolated values if API call fails
                    u_row.append(0.0)
                    v_row.append(0.0)
                    w_row.append(0.0)
                    coord_row.append((lat, lon))
            
            u_component.append(u_row)
            v_component.append(v_row)
            w_component.append(w_row)
            coordinates.append(coord_row)
        
        return VectorField(
            u_component=u_component,
            v_component=v_component,
            w_component=w_component,
            coordinates=coordinates
        )
    
    async def get_vector_field_for_path(self, path_points: List[Tuple[float, float]], resolution: int) -> VectorField:
        """Generate vector field data around a path for Stokes analysis"""
        # Find bounding box of the path
        lats = [point[0] for point in path_points]
        lons = [point[1] for point in path_points]
        
        bounds = GeographicBounds(
            north=max(lats) + 0.1,
            south=min(lats) - 0.1,
            east=max(lons) + 0.1,
            west=min(lons) - 0.1
        )
        
        return await self.get_vector_field(bounds, resolution)
    
    def _estimate_vertical_velocity(self, pressure: float) -> float:
        """Estimate vertical wind component from pressure"""
        # Simple estimation: higher pressure = downward motion
        standard_pressure = 1013.25  # hPa
        pressure_diff = pressure - standard_pressure
        # Convert to m/s (rough approximation)
        return -pressure_diff * 0.001
    
    async def get_forecast(self, lat: float, lon: float) -> dict:
        """Get weather forecast data"""
        url = f"{self.base_url}/forecast"
        params = {
            "lat": lat,
            "lon": lon,
            "appid": self.api_key,
            "units": "metric"
        }
        
        async with aiohttp.ClientSession() as session:
            async with session.get(url, params=params) as response:
                data = await response.json()
                
                forecast_list = []
                for item in data["list"][:8]:  # Next 24 hours (3-hour intervals)
                    forecast_list.append(WeatherData(
                        temperature=item["main"]["temp"],
                        humidity=item["main"]["humidity"],
                        pressure=item["main"]["pressure"],
                        wind_speed=item["wind"]["speed"],
                        wind_direction=item["wind"].get("deg", 0),
                        timestamp=datetime.fromtimestamp(item["dt"]),
                        location=(lat, lon)
                    ))
                
                return {
                    "forecast": forecast_list,
                    "location": data["city"]["name"]
                }