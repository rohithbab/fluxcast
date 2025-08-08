import numpy as np
from scipy import ndimage
from models.weather_models import VectorField, GeographicBounds, GaussAnalysisResult

class GaussService:
    def __init__(self):
        self.earth_radius = 6371000  # meters
    
    def compute_divergence(self, vector_field: VectorField, bounds: GeographicBounds) -> GaussAnalysisResult:
        """
        Compute divergence using Gauss's Divergence Theorem
        ∇ · F = ∂u/∂x + ∂v/∂y + ∂w/∂z
        """
        u = np.array(vector_field.u_component)
        v = np.array(vector_field.v_component)
        w = np.array(vector_field.w_component)
        
        # Calculate grid spacing
        lat_spacing = np.radians(bounds.north - bounds.south) / u.shape[0]
        lon_spacing = np.radians(bounds.east - bounds.west) / u.shape[1]
        alt_spacing = (bounds.altitude_max - bounds.altitude_min) / 10  # Assume 10 levels
        
        # Convert to meters
        lat_spacing_m = lat_spacing * self.earth_radius
        lon_spacing_m = lon_spacing * self.earth_radius * np.cos(np.radians((bounds.north + bounds.south) / 2))
        
        # Compute partial derivatives
        du_dx = np.gradient(u, lon_spacing_m, axis=1)
        dv_dy = np.gradient(v, lat_spacing_m, axis=0)
        dw_dz = np.gradient(w, alt_spacing, axis=0) if w.ndim > 2 else np.zeros_like(u)
        
        # Divergence field
        divergence = du_dx + dv_dy + dw_dz
        
        # Net flux through the volume (surface integral)
        net_flux = self._compute_surface_integral(u, v, w, bounds)
        
        # Generate interpretation
        interpretation = self._interpret_divergence(net_flux, divergence)
        
        # Create visualization data
        visualization_data = self._create_visualization_data(
            divergence, vector_field.coordinates, u, v, w
        )
        
        return GaussAnalysisResult(
            net_flux=float(net_flux),
            flux_unit="m³/s",
            interpretation=interpretation,
            visualization_data=visualization_data,
            computation_details={
                "mean_divergence": float(np.mean(divergence)),
                "max_divergence": float(np.max(divergence)),
                "min_divergence": float(np.min(divergence)),
                "grid_resolution": u.shape,
                "theorem_applied": "Gauss Divergence Theorem: ∮∮ F·n dS = ∭ ∇·F dV"
            }
        )
    
    def _compute_surface_integral(self, u: np.ndarray, v: np.ndarray, w: np.ndarray, bounds: GeographicBounds) -> float:
        """Compute surface integral for net flux"""
        # Simplified calculation - sum of outward flux through all faces
        # Top and bottom faces (w component)
        top_flux = np.sum(w) if w.ndim > 0 else 0
        bottom_flux = -np.sum(w) if w.ndim > 0 else 0
        
        # Side faces (u and v components)
        left_flux = -np.sum(u[:, 0])  # West face
        right_flux = np.sum(u[:, -1])  # East face
        south_flux = -np.sum(v[0, :])  # South face
        north_flux = np.sum(v[-1, :])  # North face
        
        total_flux = top_flux + bottom_flux + left_flux + right_flux + south_flux + north_flux
        
        # Scale by area approximation
        area_scale = ((bounds.north - bounds.south) * (bounds.east - bounds.west)) * 1e6  # rough scaling
        
        return total_flux * area_scale
    
    def _interpret_divergence(self, net_flux: float, divergence: np.ndarray) -> str:
        """Generate human-readable interpretation"""
        mean_div = np.mean(divergence)
        
        if net_flux > 1000:
            flux_interpretation = "Strong outflow detected - air mass is expanding/rising"
        elif net_flux < -1000:
            flux_interpretation = "Strong inflow detected - air mass is converging/sinking"
        else:
            flux_interpretation = "Balanced flow - minimal net air movement"
        
        if mean_div > 0.1:
            div_interpretation = "Positive divergence indicates air expansion (low pressure formation)"
        elif mean_div < -0.1:
            div_interpretation = "Negative divergence indicates air convergence (high pressure formation)"
        else:
            div_interpretation = "Low divergence indicates stable atmospheric conditions"
        
        return f"{flux_interpretation}. {div_interpretation}"
    
    def _create_visualization_data(self, divergence: np.ndarray, coordinates: list, 
                                 u: np.ndarray, v: np.ndarray, w: np.ndarray) -> dict:
        """Create data for frontend visualization"""
        # Flatten arrays for easier processing
        flat_coords = []
        flat_divergence = []
        arrows = []
        
        for i in range(len(coordinates)):
            for j in range(len(coordinates[i])):
                lat, lon = coordinates[i][j]
                flat_coords.append({"lat": lat, "lon": lon})
                flat_divergence.append(float(divergence[i, j]))
                
                # Arrow data for vector field visualization
                arrows.append({
                    "lat": lat,
                    "lon": lon,
                    "u": float(u[i, j]),
                    "v": float(v[i, j]),
                    "w": float(w[i, j]) if w.ndim > 0 else 0.0,
                    "magnitude": float(np.sqrt(u[i, j]**2 + v[i, j]**2))
                })
        
        return {
            "divergence_field": {
                "coordinates": flat_coords,
                "values": flat_divergence
            },
            "vector_arrows": arrows,
            "color_scale": {
                "min": float(np.min(divergence)),
                "max": float(np.max(divergence)),
                "colormap": "RdBu_r"  # Red for positive, Blue for negative
            }
        }