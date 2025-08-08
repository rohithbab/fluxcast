@echo off
echo FluxCast - Weather Prediction Through Physics
echo ==========================================
echo.

echo Installing Python dependencies...
pip install -r backend/requirements.txt

echo.
echo Installing Flutter dependencies...
cd frontend
flutter pub get
cd ..

echo.
echo Starting backend server...
echo Backend will be available at: http://localhost:8000
echo.
echo IMPORTANT: After backend starts, open a NEW terminal and run:
echo   cd frontend
echo   flutter run
echo.
python start_backend.py

pause