import numpy as np
from typing import List, Tuple
from models.weather_models import VectorField, StokesAnalysisResult

class StokesService:
    def __init__(self):
        self.earth_radius = 6371000  # meters
    
    def compute_circulation(self, vector_field: VectorField, path_points: List[Tuple[float, float]]) -> StokesAnalysisResult:
        """
        Compute circulation using Stokes' Theorem
        ∮ F·dr = ∬ (∇ × F)·n dS
        """
        u = np.array(vector_field.u_component)
        v = np.array(vector_field.v_component)
        w = np.array(vector_field.w_component)
        coordinates = vector_field.coordinates
        
        # Compute curl of the vector field
        curl_z = self._compute_curl_z(u, v, coordinates)
        
        # Compute line integral around the path
        line_integral = self._compute_line_integral(vector_field, path_points)
        
        # Compute surface integral of curl
        surface_integral = self._compute_surface_integral_curl(curl_z, path_points, coordinates)
        
        # Detect storm/vortex patterns
        storm_detection = self._detect_storm_patterns(curl_z, line_integral)
        
        # Generate interpretation
        interpretation = self._interpret_circulation(line_integral, np.mean(curl_z))
        
        # Create visualization data
        visualization_data = self._create_visualization_data(
            curl_z, coordinates, u, v, path_points, line_integral
        )
        
        return StokesAnalysisResult(
            circulation=float(line_integral),
            circulation_unit="m²/s",
            curl_magnitude=float(np.mean(np.abs(curl_z))),
            interpretation=interpretation,
            storm_detection=storm_detection,
            visualization_data=visualization_data,
            computation_details={
                "line_integral": float(line_integral),
                "surface_integral": float(surface_integral),
                "max_curl": float(np.max(curl_z)),
                "min_curl": float(np.min(curl_z)),
                "path_length": len(path_points),
                "theorem_applied": "Stokes' Theorem: ∮ F·dr = ∬ (∇ × F)·n dS"
            }
        )
    
    def _compute_curl_z(self, u: np.ndarray, v: np.ndarray, coordinates: list) -> np.ndarray:
        """Compute z-component of curl (∂v/∂x - ∂u/∂y)"""
        # Calculate grid spacing
        if len(coordinates) < 2 or len(coordinates[0]) < 2:
            return np.zeros_like(u)
        
        lat1, lon1 = coordinates[0][0]
        lat2, lon2 = coordinates[0][1] if len(coordinates[0]) > 1 else coordinates[0][0]
        lat3, lon3 = coordinates[1][0] if len(coordinates) > 1 else coordinates[0][0]
        
        # Convert to meters
        dx = self._haversine_distance(lat1, lon1, lat1, lon2)
        dy = self._haversine_distance(lat1, lon1, lat3, lon1)
        
        if dx == 0 or dy == 0:
            return np.zeros_like(u)
        
        # Compute gradients
        dv_dx = np.gradient(v, dx, axis=1)
        du_dy = np.gradient(u, dy, axis=0)
        
        # Curl z-component
        curl_z = dv_dx - du_dy
        
        return curl_z
    
    def _compute_line_integral(self, vector_field: VectorField, path_points: List[Tuple[float, float]]) -> float:
        """Compute line integral ∮ F·dr around the closed path"""
        if len(path_points) < 3:
            return 0.0
        
        circulation = 0.0
        u = np.array(vector_field.u_component)
        v = np.array(vector_field.v_component)
        coordinates = vector_field.coordinates
        
        # Ensure path is closed
        if path_points[0] != path_points[-1]:
            path_points.append(path_points[0])
        
        for i in range(len(path_points) - 1):
            lat1, lon1 = path_points[i]
            lat2, lon2 = path_points[i + 1]
            
            # Find nearest grid point
            u_val, v_val = self._interpolate_vector_at_point(lat1, lon1, u, v, coordinates)
            
            # Path segment vector
            dx = self._haversine_distance(lat1, lon1, lat1, lon2)
            dy = self._haversine_distance(lat1, lon1, lat2, lon1)
            
            if lon2 < lon1:
                dx = -dx
            if lat2 < lat1:
                dy = -dy
            
            # F·dr
            circulation += u_val * dx + v_val * dy
        
        return circulation
    
    def _compute_surface_integral_curl(self, curl_z: np.ndarray, path_points: List[Tuple[float, float]], 
                                     coordinates: list) -> float:
        """Compute surface integral of curl over the area enclosed by path"""
        # Simple approximation: sum curl values inside the path
        inside_points = self._points_inside_polygon(coordinates, path_points)
        
        total_curl = 0.0
        count = 0
        
        for i, row in enumerate(coordinates):
            for j, (lat, lon) in enumerate(row):
                if self._point_in_polygon(lat, lon, path_points):
                    total_curl += curl_z[i, j]
                    count += 1
        
        if count > 0:
            # Approximate area calculation
            area = self._polygon_area(path_points)
            return total_curl * area / count
        
        return 0.0
    
    def _detect_storm_patterns(self, curl_z: np.ndarray, circulation: float) -> bool:
        """Detect potential storm/vortex patterns"""
        max_curl = np.max(np.abs(curl_z))
        mean_curl = np.mean(np.abs(curl_z))
        
        # Storm detection criteria
        high_circulation = abs(circulation) > 1000  # Threshold for significant circulation
        high_curl = max_curl > 0.01  # Threshold for significant rotation
        consistent_rotation = mean_curl > 0.005  # Consistent rotational pattern
        
        return high_circulation and (high_curl or consistent_rotation)
    
    def _interpret_circulation(self, circulation: float, mean_curl: float) -> str:
        """Generate human-readable interpretation"""
        if abs(circulation) > 2000:
            circ_strength = "Strong"
        elif abs(circulation) > 500:
            circ_strength = "Moderate"
        else:
            circ_strength = "Weak"
        
        direction = "clockwise" if circulation < 0 else "counterclockwise"
        
        if abs(mean_curl) > 0.01:
            curl_interpretation = "High rotational activity detected - possible storm formation"
        elif abs(mean_curl) > 0.005:
            curl_interpretation = "Moderate rotational patterns present"
        else:
            curl_interpretation = "Low rotational activity - stable conditions"
        
        return f"{circ_strength} {direction} circulation detected. {curl_interpretation}"
    
    def _create_visualization_data(self, curl_z: np.ndarray, coordinates: list, 
                                 u: np.ndarray, v: np.ndarray, path_points: List[Tuple[float, float]], 
                                 circulation: float) -> dict:
        """Create data for frontend visualization"""
        # Curl field visualization
        curl_data = []
        vector_data = []
        
        for i in range(len(coordinates)):
            for j in range(len(coordinates[i])):
                lat, lon = coordinates[i][j]
                curl_data.append({
                    "lat": lat,
                    "lon": lon,
                    "curl": float(curl_z[i, j])
                })
                
                # Rotational arrows
                magnitude = np.sqrt(u[i, j]**2 + v[i, j]**2)
                if magnitude > 0:
                    vector_data.append({
                        "lat": lat,
                        "lon": lon,
                        "u": float(u[i, j]),
                        "v": float(v[i, j]),
                        "magnitude": float(magnitude),
                        "rotation": float(curl_z[i, j])
                    })
        
        return {
            "curl_field": curl_data,
            "rotation_arrows": vector_data,
            "path": [{"lat": lat, "lon": lon} for lat, lon in path_points],
            "circulation_value": float(circulation),
            "color_scale": {
                "min": float(np.min(curl_z)),
                "max": float(np.max(curl_z)),
                "colormap": "RdYlBu_r"
            }
        }
    
    def _haversine_distance(self, lat1: float, lon1: float, lat2: float, lon2: float) -> float:
        """Calculate distance between two points on Earth"""
        lat1, lon1, lat2, lon2 = map(np.radians, [lat1, lon1, lat2, lon2])
        dlat = lat2 - lat1
        dlon = lon2 - lon1
        a = np.sin(dlat/2)**2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon/2)**2
        c = 2 * np.arcsin(np.sqrt(a))
        return self.earth_radius * c
    
    def _interpolate_vector_at_point(self, lat: float, lon: float, u: np.ndarray, 
                                   v: np.ndarray, coordinates: list) -> Tuple[float, float]:
        """Interpolate vector field values at a specific point"""
        # Find nearest grid point (simple nearest neighbor)
        min_dist = float('inf')
        best_i, best_j = 0, 0
        
        for i in range(len(coordinates)):
            for j in range(len(coordinates[i])):
                grid_lat, grid_lon = coordinates[i][j]
                dist = self._haversine_distance(lat, lon, grid_lat, grid_lon)
                if dist < min_dist:
                    min_dist = dist
                    best_i, best_j = i, j
        
        return float(u[best_i, best_j]), float(v[best_i, best_j])
    
    def _point_in_polygon(self, lat: float, lon: float, polygon: List[Tuple[float, float]]) -> bool:
        """Check if point is inside polygon using ray casting algorithm"""
        x, y = lon, lat
        n = len(polygon)
        inside = False
        
        p1x, p1y = polygon[0]
        for i in range(1, n + 1):
            p2x, p2y = polygon[i % n]
            if y > min(p1y, p2y):
                if y <= max(p1y, p2y):
                    if x <= max(p1x, p2x):
                        if p1y != p2y:
                            xinters = (y - p1y) * (p2x - p1x) / (p2y - p1y) + p1x
                        if p1x == p2x or x <= xinters:
                            inside = not inside
            p1x, p1y = p2x, p2y
        
        return inside
    
    def _polygon_area(self, polygon: List[Tuple[float, float]]) -> float:
        """Calculate approximate area of polygon"""
        if len(polygon) < 3:
            return 0.0
        
        area = 0.0
        for i in range(len(polygon)):
            j = (i + 1) % len(polygon)
            area += polygon[i][0] * polygon[j][1]
            area -= polygon[j][0] * polygon[i][1]
        
        return abs(area) / 2.0
    
    def _points_inside_polygon(self, coordinates: list, polygon: List[Tuple[float, float]]) -> List[Tuple[int, int]]:
        """Find grid points inside the polygon"""
        inside_points = []
        for i in range(len(coordinates)):
            for j in range(len(coordinates[i])):
                lat, lon = coordinates[i][j]
                if self._point_in_polygon(lat, lon, polygon):
                    inside_points.append((i, j))
        return inside_points