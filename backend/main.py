from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Tuple
import numpy as np
import requests
import asyncio
from datetime import datetime

from services.weather_service import WeatherService
from services.gauss_service import GaussService
from services.stokes_service import StokesService
from models.weather_models import WeatherData, GaussAnalysisRequest, StokesAnalysisRequest

app = FastAPI(title="FluxCast API", description="Weather analysis using vector calculus")

# CORS middleware for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
weather_service = WeatherService()
gauss_service = GaussService()
stokes_service = StokesService()

@app.get("/")
async def root():
    return {"message": "FluxCast API - Weather prediction through physics"}

@app.get("/weather/current")
async def get_current_weather(lat: float, lon: float):
    """Get current weather data for given coordinates"""
    try:
        weather_data = await weather_service.get_current_weather(lat, lon)
        return weather_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/analysis/gauss")
async def gauss_analysis(request: GaussAnalysisRequest):
    """Perform Gauss Divergence Theorem analysis"""
    try:
        # Get weather vector field data
        vector_field = await weather_service.get_vector_field(
            request.bounds, request.resolution
        )
        
        # Compute divergence using Gauss theorem
        result = gauss_service.compute_divergence(vector_field, request.bounds)
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/analysis/stokes")
async def stokes_analysis(request: StokesAnalysisRequest):
    """Perform Stokes Theorem circulation analysis"""
    try:
        # Get weather vector field data for the region
        vector_field = await weather_service.get_vector_field_for_path(
            request.path_points, request.resolution
        )
        
        # Compute circulation using Stokes theorem
        result = stokes_service.compute_circulation(vector_field, request.path_points)
        
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/forecast")
async def get_forecast(lat: float, lon: float):
    """Get weather forecast with theorem-based insights"""
    try:
        forecast_data = await weather_service.get_forecast(lat, lon)
        return forecast_data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)