#!/usr/bin/env python3
"""
FluxCast Backend Startup Script
"""

import subprocess
import sys
import os

def check_requirements():
    """Check if required packages are installed"""
    required_packages = [
        'fastapi', 'uvicorn', 'numpy', 'scipy', 
        'requests', 'aiohttp', 'pydantic', 'plotly', 'pandas'
    ]
    
    missing_packages = []
    
    for package in required_packages:
        try:
            __import__(package)
            print(f"✓ {package}")
        except ImportError:
            print(f"✗ {package}")
            missing_packages.append(package)
    
    if missing_packages:
        print(f"\nMissing packages: {', '.join(missing_packages)}")
        print("Installing missing packages...")
        
        try:
            import subprocess
            result = subprocess.run([
                sys.executable, '-m', 'pip', 'install', '-r', 'backend/requirements.txt'
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print("✓ Packages installed successfully!")
                return True
            else:
                print(f"✗ Installation failed: {result.stderr}")
                print("Please manually run: pip install -r backend/requirements.txt")
                return False
        except Exception as e:
            print(f"✗ Auto-installation failed: {e}")
            print("Please manually run: pip install -r backend/requirements.txt")
            return False
    
    print("✓ All required packages are installed")
    return True

def start_server():
    """Start the FastAPI server"""
    if not check_requirements():
        return
    
    print("Starting FluxCast Backend Server...")
    print("API will be available at: http://localhost:8000")
    print("API documentation at: http://localhost:8000/docs")
    print("\nPress Ctrl+C to stop the server\n")
    
    try:
        # Change to backend directory
        os.chdir('backend')
        
        # Start uvicorn server
        subprocess.run([
            sys.executable, '-m', 'uvicorn', 
            'main:app', 
            '--reload', 
            '--host', '0.0.0.0', 
            '--port', '8000'
        ])
    except KeyboardInterrupt:
        print("\n\nServer stopped by user")
    except Exception as e:
        print(f"Error starting server: {e}")

if __name__ == "__main__":
    start_server()