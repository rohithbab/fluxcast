#!/usr/bin/env pwsh
# FluxCast Startup Script for PowerShell
# This script starts both backend and frontend

Write-Host "FluxCast - Weather Prediction Through Physics" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python not found. Please install Python 3.8+" -ForegroundColor Red
    exit 1
}

# Check if Flutter is installed
try {
    $flutterVersion = flutter --version 2>&1 | Select-String "Flutter"
    Write-Host "✓ Flutter found: $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Flutter not found. Please install Flutter SDK" -ForegroundColor Red
    Write-Host "Download from: https://flutter.dev/docs/get-started/install" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Installing dependencies..." -ForegroundColor Yellow

# Install Python dependencies
Write-Host "Installing Python packages..." -ForegroundColor Blue
pip install -r backend/requirements.txt

# Install Flutter dependencies
Write-Host "Installing Flutter packages..." -ForegroundColor Blue
Set-Location frontend
flutter pub get
Set-Location ..

Write-Host ""
Write-Host "Starting FluxCast application..." -ForegroundColor Green
Write-Host ""

# Start backend in background
Write-Host "Starting backend server..." -ForegroundColor Blue
$backendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    python start_backend.py
}

# Wait a moment for backend to start
Start-Sleep -Seconds 3

Write-Host "Backend started! Available at: http://localhost:8000" -ForegroundColor Green
Write-Host "API Documentation: http://localhost:8000/docs" -ForegroundColor Green
Write-Host ""

# Start Flutter app
Write-Host "Starting Flutter app..." -ForegroundColor Blue
Write-Host "Choose your target device when prompted." -ForegroundColor Yellow
Write-Host ""

Set-Location frontend
flutter run

# Cleanup
Write-Host ""
Write-Host "Stopping backend server..." -ForegroundColor Yellow
Stop-Job $backendJob
Remove-Job $backendJob

Write-Host "FluxCast stopped. Thank you!" -ForegroundColor Cyan