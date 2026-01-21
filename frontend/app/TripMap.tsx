'use client'

import { useEffect, useState } from 'react'
import { MapContainer, TileLayer, Polyline, Marker, Popup, useMap } from 'react-leaflet'
import L from 'leaflet'
import 'leaflet/dist/leaflet.css'

interface GpsPoint {
  lat: number
  lng: number
  timestamp: string
}

interface Trip {
  id: string
  from_address: string
  to_address: string
  from_lat: number | null
  from_lon: number | null
  to_lat: number | null
  to_lon: number | null
  gps_trail?: GpsPoint[]
  distance_km: number
  google_maps_km?: number | null
}

interface TripMapTranslations {
  routeLoading: string
  expected: string
  drivenRoute: string
}

interface TripMapProps {
  trip: Trip
  onClose: () => void
  translations?: TripMapTranslations
}

// Custom markers
const startIcon = new L.Icon({
  iconUrl: 'data:image/svg+xml;base64,' + btoa(`
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32">
      <path fill="#22c55e" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
      <circle fill="white" cx="12" cy="9" r="2.5"/>
    </svg>
  `),
  iconSize: [32, 32],
  iconAnchor: [16, 32],
  popupAnchor: [0, -32],
})

const endIcon = new L.Icon({
  iconUrl: 'data:image/svg+xml;base64,' + btoa(`
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="32" height="32">
      <path fill="#ef4444" d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7z"/>
      <circle fill="white" cx="12" cy="9" r="2.5"/>
    </svg>
  `),
  iconSize: [32, 32],
  iconAnchor: [16, 32],
  popupAnchor: [0, -32],
})

// Component to fit bounds
function FitBounds({ bounds }: { bounds: L.LatLngBoundsExpression }) {
  const map = useMap()
  useEffect(() => {
    map.fitBounds(bounds, { padding: [50, 50] })
  }, [map, bounds])
  return null
}

const defaultTranslations: TripMapTranslations = {
  routeLoading: 'Loading route...',
  expected: 'Expected',
  drivenRoute: 'Driven',
}

export default function TripMap({ trip, onClose, translations = defaultTranslations }: TripMapProps) {
  const t = translations
  const [actualRoute, setActualRoute] = useState<[number, number][] | null>(null)
  const [expectedRoute, setExpectedRoute] = useState<[number, number][] | null>(null)
  const [loading, setLoading] = useState(true)

  // Load both routes from OSRM
  useEffect(() => {
    async function loadRoutes() {
      await Promise.all([loadActualRoute(), loadExpectedRoute()])
      setLoading(false)
    }

    async function loadExpectedRoute() {
      // Expected route: shortest path from start to end only
      const fromLat = trip.from_lat ?? trip.gps_trail?.[0]?.lat
      const fromLng = trip.from_lon ?? trip.gps_trail?.[0]?.lng
      const toLat = trip.to_lat ?? trip.gps_trail?.[trip.gps_trail!.length - 1]?.lat
      const toLng = trip.to_lon ?? trip.gps_trail?.[trip.gps_trail!.length - 1]?.lng

      if (!fromLat || !fromLng || !toLat || !toLng) return

      try {
        const url = `https://router.project-osrm.org/route/v1/driving/${fromLng},${fromLat};${toLng},${toLat}?overview=full&geometries=geojson`
        const response = await fetch(url)
        if (response.ok) {
          const data = await response.json()
          if (data.code === 'Ok' && data.routes?.[0]?.geometry) {
            const coordinates = data.routes[0].geometry.coordinates
            setExpectedRoute(coordinates.map((c: number[]) => [c[1], c[0]] as [number, number]))
          }
        }
      } catch (e) {
        console.error('Expected route error:', e)
      }
    }

    async function loadActualRoute() {
      const gpsTrail = trip.gps_trail
      if (!gpsTrail || gpsTrail.length < 2) return

      try {
        // Sample waypoints (OSRM has URL length limits)
        let waypoints = gpsTrail
        if (gpsTrail.length > 25) {
          waypoints = [gpsTrail[0]]
          const step = (gpsTrail.length - 2) / 22
          for (let i = 1; i < 23; i++) {
            waypoints.push(gpsTrail[Math.floor(i * step)])
          }
          waypoints.push(gpsTrail[gpsTrail.length - 1])
        }

        const coords = waypoints.map(p => `${p.lng},${p.lat}`).join(';')
        const url = `https://router.project-osrm.org/route/v1/driving/${coords}?overview=full&geometries=geojson`

        const response = await fetch(url)
        if (response.ok) {
          const data = await response.json()
          if (data.code === 'Ok' && data.routes?.[0]?.geometry) {
            const coordinates = data.routes[0].geometry.coordinates
            const routePoints: [number, number][] = coordinates.map((c: number[]) => [c[1], c[0]])
            const firstGps: [number, number] = [gpsTrail[0].lat, gpsTrail[0].lng]
            const lastGps: [number, number] = [gpsTrail[gpsTrail.length - 1].lat, gpsTrail[gpsTrail.length - 1].lng]
            setActualRoute([firstGps, ...routePoints, lastGps])
          }
        }
      } catch (e) {
        console.error('Actual route error:', e)
      }
    }

    loadRoutes()
  }, [trip])

  // Build route points
  const routePoints: [number, number][] = actualRoute ||
    (trip.gps_trail?.map(p => [p.lat, p.lng] as [number, number]) || [])

  // Calculate bounds
  const getBounds = (): L.LatLngBoundsExpression => {
    const points: [number, number][] = []

    if (trip.gps_trail && trip.gps_trail.length > 0) {
      trip.gps_trail.forEach(p => points.push([p.lat, p.lng]))
    } else {
      if (trip.from_lat && trip.from_lon) points.push([trip.from_lat, trip.from_lon])
      if (trip.to_lat && trip.to_lon) points.push([trip.to_lat, trip.to_lon])
    }

    if (points.length === 0) {
      return [[52.0, 4.4], [52.1, 4.5]] // Default Netherlands
    }

    const lats = points.map(p => p[0])
    const lngs = points.map(p => p[1])
    const padding = 0.01

    return [
      [Math.min(...lats) - padding, Math.min(...lngs) - padding],
      [Math.max(...lats) + padding, Math.max(...lngs) + padding]
    ]
  }

  // Get start/end coordinates
  const startPos: [number, number] | null = trip.gps_trail?.[0]
    ? [trip.gps_trail[0].lat, trip.gps_trail[0].lng]
    : (trip.from_lat && trip.from_lon ? [trip.from_lat, trip.from_lon] : null)

  const endPos: [number, number] | null = trip.gps_trail?.length
    ? [trip.gps_trail[trip.gps_trail.length - 1].lat, trip.gps_trail[trip.gps_trail.length - 1].lng]
    : (trip.to_lat && trip.to_lon ? [trip.to_lat, trip.to_lon] : null)

  const defaultCenter: [number, number] = startPos || [52.0, 4.4]

  return (
    <div className="map-modal-overlay" onClick={onClose}>
      <div className="map-modal" onClick={e => e.stopPropagation()}>
        <div className="map-header">
          <h3>{trip.from_address} → {trip.to_address}</h3>
          <span className="map-distance">{trip.distance_km} km</span>
          <button className="map-close" onClick={onClose}>×</button>
        </div>
        <div className="map-container">
          {loading && (
            <div className="map-loading">
              <div className="spinner"></div>
              <span>{t.routeLoading}</span>
            </div>
          )}
          <MapContainer
            center={defaultCenter}
            zoom={13}
            style={{ height: '100%', width: '100%' }}
            scrollWheelZoom={true}
          >
            <TileLayer
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
              url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            <FitBounds bounds={getBounds()} />

            {/* Expected route (orange, underneath) */}
            {expectedRoute && expectedRoute.length > 0 && (
              <Polyline
                positions={expectedRoute}
                color="#f97316"
                weight={6}
                opacity={0.8}
              />
            )}

            {/* Actual route (blue, on top) */}
            {routePoints.length > 0 && (
              <Polyline
                positions={routePoints}
                color="#3b82f6"
                weight={4}
                opacity={0.9}
              />
            )}

            {/* GPS trail dots */}
            {trip.gps_trail?.map((point, i) => {
              const isFirst = i === 0
              const isLast = i === trip.gps_trail!.length - 1
              if (isFirst || isLast) return null // Handled by markers
              return (
                <Marker
                  key={i}
                  position={[point.lat, point.lng]}
                  icon={new L.DivIcon({
                    className: 'gps-dot',
                    iconSize: [10, 10],
                    iconAnchor: [5, 5],
                  })}
                />
              )
            })}

            {/* Start marker */}
            {startPos && (
              <Marker position={startPos} icon={startIcon}>
                <Popup>{trip.from_address}</Popup>
              </Marker>
            )}

            {/* End marker */}
            {endPos && (
              <Marker position={endPos} icon={endIcon}>
                <Popup>{trip.to_address}</Popup>
              </Marker>
            )}
          </MapContainer>
          {/* Legend */}
          <div className="map-legend">
            <div className="legend-item">
              <span className="legend-line" style={{ backgroundColor: '#f97316' }}></span>
              <span>{t.expected} ({trip.google_maps_km?.toFixed(1) ?? '?'} km)</span>
            </div>
            <div className="legend-item">
              <span className="legend-line" style={{ backgroundColor: '#3b82f6' }}></span>
              <span>{t.drivenRoute} ({trip.distance_km.toFixed(1)} km)</span>
            </div>
          </div>
        </div>
      </div>
      <style jsx global>{`
        .map-modal-overlay {
          position: fixed;
          top: 0;
          left: 0;
          right: 0;
          bottom: 0;
          background: rgba(0, 0, 0, 0.8);
          display: flex;
          align-items: center;
          justify-content: center;
          z-index: 1000;
        }
        .map-modal {
          background: #1a1a1a;
          border-radius: 12px;
          width: 90vw;
          max-width: 900px;
          height: 80vh;
          display: flex;
          flex-direction: column;
          overflow: hidden;
        }
        .map-header {
          display: flex;
          align-items: center;
          gap: 12px;
          padding: 16px 20px;
          border-bottom: 1px solid #333;
        }
        .map-header h3 {
          flex: 1;
          margin: 0;
          font-size: 16px;
          color: #fff;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
        .map-distance {
          background: #3b82f6;
          color: white;
          padding: 4px 10px;
          border-radius: 12px;
          font-size: 13px;
          font-weight: 500;
        }
        .map-close {
          background: none;
          border: none;
          color: #888;
          font-size: 24px;
          cursor: pointer;
          padding: 0 8px;
        }
        .map-close:hover {
          color: #fff;
        }
        .map-container {
          flex: 1;
          position: relative;
        }
        .map-loading {
          position: absolute;
          top: 50%;
          left: 50%;
          transform: translate(-50%, -50%);
          z-index: 1000;
          display: flex;
          flex-direction: column;
          align-items: center;
          gap: 10px;
          color: #888;
        }
        .map-legend {
          position: absolute;
          bottom: 16px;
          left: 16px;
          background: white;
          padding: 10px 12px;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.2);
          z-index: 1000;
        }
        .legend-item {
          display: flex;
          align-items: center;
          gap: 8px;
          color: #1a1a1a;
          font-size: 13px;
          font-weight: 500;
        }
        .legend-item + .legend-item {
          margin-top: 6px;
        }
        .legend-line {
          width: 20px;
          height: 4px;
          border-radius: 2px;
        }
        .gps-dot {
          background: #3b82f6;
          border: 2px solid white;
          border-radius: 50%;
          box-shadow: 0 1px 3px rgba(0,0,0,0.3);
        }
        .leaflet-container {
          background: #1a1a1a;
        }
      `}</style>
    </div>
  )
}
