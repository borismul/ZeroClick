'use client'

import { useState, useEffect } from 'react'
import { useSession, signOut } from 'next-auth/react'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from 'recharts'

const API_URL = process.env.NEXT_PUBLIC_API_URL || ''

// Helper to create headers with auth token
function apiHeaders(idToken: string | null | undefined, userEmail?: string | null): HeadersInit {
  const headers: HeadersInit = { 'Content-Type': 'application/json' }
  if (idToken) {
    headers['Authorization'] = `Bearer ${idToken}`
  }
  // Fallback to email header for backwards compatibility
  if (userEmail) {
    headers['X-User-Email'] = userEmail
  }
  return headers
}

interface Trip {
  id: string
  date: string
  start_time: string
  end_time: string
  from_address: string
  to_address: string
  from_lat: number | null
  from_lon: number | null
  to_lat: number | null
  to_lon: number | null
  distance_km: number
  trip_type: string
  business_km: number
  private_km: number
  car_id?: string | null
  gps_trail?: Array<{lat: number, lng: number, timestamp: string}>
  google_maps_km?: number | null
  route_deviation_percent?: number | null
  route_flag?: string | null
}

interface Stats {
  total_km: number
  business_km: number
  private_km: number
  trip_count: number
}

interface OdometerComparison {
  start_odometer: number
  trips_timeline: Array<{timestamp: string, date: string, cumulative_km: number, distance_km: number, trip_id: string, from: string, to: string}>
  odometer_readings: Array<{timestamp: string, odometer_km: number}>
  comparison: {
    actual_odometer_km: number
    calculated_km: number
    difference_km: number
    difference_percent: number
    status: 'ok' | 'warning'
  } | null
  warnings: Array<{type: string, message: string, suggestion: string}>
}

// CarSettings removed - now per-car via /cars/{car_id}/credentials

interface Car {
  id: string
  name: string
  brand: string
  color: string
  icon: string
  is_default: boolean
  carplay_device_id: string | null
  start_odometer: number
  created_at: string | null
  last_used: string | null
  total_trips: number
  total_km: number
}

interface CarData {
  car_id: string
  car_name: string
  brand: string
  vin: string | null
  odometer_km: number | null
  latitude: number | null
  longitude: number | null
  state: string | null
  battery_level: number | null
  range_km: number | null
  is_charging: boolean
  is_plugged_in: boolean
  charging_power_kw: number | null
  charging_remaining_minutes: number | null
  battery_temp_celsius: number | null
  climate_state: string | null
  climate_target_temp: number | null
  seat_heating: boolean | null
  window_heating: boolean | null
  connection_state: string | null
  lights_state: string | null
  fetched_at: string
}

type Tab = 'status' | 'ritten' | 'instellingen'

export default function Dashboard() {
  const { data: session } = useSession()
  const [activeTab, setActiveTab] = useState<Tab>('status')
  const [trips, setTrips] = useState<Trip[]>([])
  const [stats, setStats] = useState<Stats | null>(null)
  const [loading, setLoading] = useState(true)
  const [editingTrip, setEditingTrip] = useState<Trip | null>(null)
  const [showAddModal, setShowAddModal] = useState(false)
  const [spreadsheetId, setSpreadsheetId] = useState('')
  const [exporting, setExporting] = useState(false)
  const [exportCarId, setExportCarId] = useState<string>('')  // '' = all cars
  const [exportSeparateSheets, setExportSeparateSheets] = useState(false)
  const [page, setPage] = useState(1)
  const [hasMore, setHasMore] = useState(true)
  const [locations, setLocations] = useState<string[]>([])
  const [savingLocation, setSavingLocation] = useState<{lat: number, lon: number, current: string} | null>(null)
  const [newLocationName, setNewLocationName] = useState('')
  const [odometerData, setOdometerData] = useState<OdometerComparison | null>(null)
  const [fetchingOdo, setFetchingOdo] = useState(false)
  const [activeTrip, setActiveTrip] = useState<{
    active: boolean
    start_time?: string
    start_odo?: number
    last_odo?: number
  } | null>(null)
  // carSettings removed - now managed per-car via /cars/{car_id}/credentials
  const [carData, setCarData] = useState<CarData | null>(null)
  const [fetchingCarData, setFetchingCarData] = useState(false)
  const [showCarDetails, setShowCarDetails] = useState(false)
  const [showChargingDetails, setShowChargingDetails] = useState(false)
  const [showDebug, setShowDebug] = useState(false)

  // Multi-car state
  const [cars, setCars] = useState<Car[]>([])
  const [selectedCarId, setSelectedCarId] = useState<string | null>(null)
  const [showAddCarModal, setShowAddCarModal] = useState(false)
  const [editingCar, setEditingCar] = useState<Car | null>(null)

  const userEmail = session?.user?.email
  const idToken = session?.idToken

  // Only fetch data when session is loaded
  useEffect(() => {
    if (userEmail && idToken) {
      fetchData(); fetchLocations(); fetchOdometerComparison(); fetchActiveTrip(); fetchCarData(); fetchCars()
    }
  }, [userEmail, idToken])

  // Refetch data when selected car changes
  useEffect(() => {
    if (userEmail && idToken && selectedCarId) {
      fetchData()
      fetchCarData(selectedCarId)
    }
  }, [selectedCarId])
  useEffect(() => {
    if (!userEmail || !idToken) return
    // Only poll active trip status, NOT car data (too expensive)
    const interval = setInterval(() => {
      if (document.hidden) return
      fetchActiveTrip()
    }, 60000) // 1 minute for trip status only
    return () => clearInterval(interval)
  }, [userEmail, idToken])
  useEffect(() => { if (userEmail && idToken) fetchData() }, [page, userEmail, idToken])

  async function fetchData() {
    try {
      const headers = apiHeaders(idToken, userEmail)
      const carParam = selectedCarId ? `&car_id=${selectedCarId}` : ''
      const [tripsRes, statsRes] = await Promise.all([
        fetch(`${API_URL}/trips?page=${page}&limit=50${carParam}`, { headers }),
        fetch(`${API_URL}/stats${carParam ? `?car_id=${selectedCarId}` : ''}`, { headers })
      ])
      const tripsData = await tripsRes.json()
      setTrips(tripsData)
      setHasMore(tripsData.length === 50)
      setStats(await statsRes.json())
    } catch (e) {
      console.error('Failed to fetch:', e)
    } finally {
      setLoading(false)
    }
  }

  async function fetchCars() {
    try {
      const res = await fetch(`${API_URL}/cars`, { headers: apiHeaders(idToken, userEmail) })
      if (res.ok) {
        const carsData = await res.json()
        setCars(carsData)
        // Auto-select default car or first car if none selected
        if (!selectedCarId && carsData.length > 0) {
          const defaultCar = carsData.find((c: Car) => c.is_default) || carsData[0]
          setSelectedCarId(defaultCar.id)
        }
      }
    } catch (e) {
      console.error('Failed to fetch cars:', e)
    }
  }

  async function createCar(name: string, brand: string, color: string, credentials?: { username: string, password: string, country: string }) {
    try {
      const res = await fetch(`${API_URL}/cars`, {
        method: 'POST',
        headers: apiHeaders(idToken, userEmail),
        body: JSON.stringify({ name, brand, color, icon: 'car' })
      })
      if (res.ok) {
        const newCar = await res.json()
        // Save credentials if provided
        if (credentials && newCar.id) {
          await saveCarCredentials(newCar.id, { brand, ...credentials })
        }
        await fetchCars()
        setShowAddCarModal(false)
      }
    } catch (e) {
      console.error('Failed to create car:', e)
    }
  }

  async function updateCarDetails(carId: string, updates: Partial<Car>) {
    try {
      const res = await fetch(`${API_URL}/cars/${carId}`, {
        method: 'PATCH',
        headers: apiHeaders(idToken, userEmail),
        body: JSON.stringify(updates)
      })
      if (res.ok && userEmail) {
        await fetchCars()
        setEditingCar(null)
      }
    } catch (e) {
      console.error('Failed to update car:', e)
    }
  }

  async function deleteCar(carId: string) {
    if (!confirm('Weet je zeker dat je deze auto wilt verwijderen?')) return
    try {
      const res = await fetch(`${API_URL}/cars/${carId}`, {
        method: 'DELETE',
        headers: apiHeaders(idToken, userEmail)
      })
      if (res.ok && userEmail) {
        if (selectedCarId === carId) setSelectedCarId(null)
        await fetchCars()
        setEditingCar(null)
      } else {
        const data = await res.json()
        alert(data.detail || 'Kon auto niet verwijderen')
      }
    } catch (e) {
      console.error('Failed to delete car:', e)
    }
  }

  async function saveCarCredentials(carId: string, creds: { brand: string, username: string, password: string, country: string }) {
    const res = await fetch(`${API_URL}/cars/${carId}/credentials`, {
      method: 'PUT',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify(creds)
    })
    if (!res.ok) {
      const data = await res.json()
      throw new Error(data.detail || 'Opslaan mislukt')
    }
  }

  async function testCarCredentials(carId: string, creds: { brand: string, username: string, password: string, country: string }) {
    const res = await fetch(`${API_URL}/cars/${carId}/credentials/test`, {
      method: 'POST',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify(creds)
    })
    const data = await res.json()
    if (!res.ok) {
      throw new Error(data.detail || 'Test mislukt')
    }
    return data
  }

  async function fetchLocations() {
    try {
      const res = await fetch(`${API_URL}/locations`, { headers: apiHeaders(idToken, userEmail) })
      const data = await res.json()
      setLocations(['Thuis', 'Kantoor', ...data.map((l: {name: string}) => l.name)])
    } catch (e) {
      console.error('Failed to fetch locations:', e)
    }
  }

  async function saveLocation(name: string, lat: number, lon: number) {
    await fetch(`${API_URL}/locations`, {
      method: 'POST',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify({ name, lat, lng: lon })
    })
    setSavingLocation(null)
    setNewLocationName('')
    fetchLocations()
    if (userEmail && idToken) fetchData()
  }

  async function fetchOdometerComparison() {
    try {
      const res = await fetch(`${API_URL}/audi/compare`, { headers: apiHeaders(idToken, userEmail) })
      if (res.ok) setOdometerData(await res.json())
    } catch (e) {
      console.error('Failed to fetch odometer comparison:', e)
    }
  }

  async function fetchActiveTrip() {
    try {
      const res = await fetch(`${API_URL}/webhook/status`, { headers: apiHeaders(idToken, userEmail) })
      if (res.ok) setActiveTrip(await res.json())
    } catch (e) {
      console.error('Failed to fetch active trip:', e)
    }
  }

  async function fetchOdometer() {
    setFetchingOdo(true)
    try {
      // Fetch car data (which also stores odometer reading per-user)
      await fetch(`${API_URL}/car/data`, { headers: apiHeaders(idToken, userEmail) })
      await fetchOdometerComparison()
    } catch (e) {
      console.error('Failed to fetch odometer:', e)
    } finally {
      setFetchingOdo(false)
    }
  }

  // fetchCarSettings removed - now per-car via /cars/{car_id}/credentials

  async function fetchCarData(carId?: string | null) {
    const targetCarId = carId ?? selectedCarId
    if (!targetCarId) {
      setCarData(null)
      return
    }
    setFetchingCarData(true)
    try {
      const res = await fetch(`${API_URL}/cars/${targetCarId}/data`, { headers: apiHeaders(idToken, userEmail) })
      if (res.ok) {
        setCarData(await res.json())
      } else {
        // Car might not have API credentials
        setCarData(null)
      }
    } catch (e) {
      console.error('Failed to fetch car data:', e)
      setCarData(null)
    } finally {
      setFetchingCarData(false)
    }
  }

  // saveCarSettings removed - now per-car via /cars/{car_id}/credentials

  function isKnownLocation(address: string) {
    return locations.includes(address)
  }

  async function updateTrip(tripId: string, updates: Partial<Trip>) {
    await fetch(`${API_URL}/trips/${tripId}`, {
      method: 'PATCH',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify(updates)
    })
    setEditingTrip(null)
    if (userEmail && idToken) fetchData()
  }

  async function deleteTrip(tripId: string) {
    if (!confirm('Weet je zeker dat je deze rit wilt verwijderen?')) return
    await fetch(`${API_URL}/trips/${tripId}`, { method: 'DELETE', headers: apiHeaders(idToken, userEmail) })
    if (userEmail && idToken) fetchData()
  }

  async function toggleRouteFlag(tripId: string, currentFlag: string | null | undefined) {
    const newFlag = currentFlag === 'long_route' ? null : 'long_route'
    await fetch(`${API_URL}/trips/${tripId}`, {
      method: 'PATCH',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify({ route_flag: newFlag })
    })
    if (userEmail && idToken) fetchData()
  }

  async function addTrip(trip: Partial<Trip>) {
    await fetch(`${API_URL}/trips`, {
      method: 'POST',
      headers: apiHeaders(idToken, userEmail),
      body: JSON.stringify(trip)
    })
    setShowAddModal(false)
    if (userEmail && idToken) fetchData()
  }

  async function exportToSheet() {
    if (!spreadsheetId) return
    setExporting(true)
    try {
      const payload: Record<string, unknown> = { spreadsheet_id: spreadsheetId }
      if (exportCarId) payload.car_id = exportCarId
      if (exportSeparateSheets) payload.separate_sheets = true

      const res = await fetch(`${API_URL}/export`, {
        method: 'POST',
        headers: apiHeaders(idToken, userEmail),
        body: JSON.stringify(payload)
      })
      const data = await res.json()
      if (data.separate_sheets) {
        alert(`Export succesvol! ${data.rows} ritten geëxporteerd naar ${data.cars?.length || 0} sheets`)
      } else {
        alert(`Export succesvol! ${data.rows} ritten geëxporteerd`)
      }
    } catch {
      alert('Export mislukt')
    } finally {
      setExporting(false)
    }
  }

  if (loading) return <div className="container"><div className="loading">Laden...</div></div>

  return (
    <div className="container">
      <header>
        <h1>Kilometerregistratie</h1>
        <nav className="tabs">
          <button className={activeTab === 'status' ? 'active' : ''} onClick={() => setActiveTab('status')}>Status</button>
          <button className={activeTab === 'ritten' ? 'active' : ''} onClick={() => setActiveTab('ritten')}>Ritten</button>
          <button className={activeTab === 'instellingen' ? 'active' : ''} onClick={() => setActiveTab('instellingen')}>Instellingen</button>
        </nav>
        <div className="header-actions">
          {cars.length > 0 && (
            <select
              className="car-selector-main"
              value={selectedCarId || ''}
              onChange={(e) => setSelectedCarId(e.target.value || null)}
            >
              {cars.map(car => (
                <option key={car.id} value={car.id}>
                  {car.name}
                </option>
              ))}
            </select>
          )}
          {session?.user && (
            <>
              <span className="user-email">{session.user.email}</span>
              <button className="logout-btn" onClick={() => signOut()}>Uitloggen</button>
            </>
          )}
        </div>
      </header>

      {/* STATUS TAB */}
      {activeTab === 'status' && (
        <div className="tab-content">
          {/* Active Trip Banner */}
          {activeTrip?.active && (
            <div className="active-trip-banner">
              <div className="pulse"></div>
              <div className="active-trip-info">
                <strong>Actieve rit</strong>
                <span>Gestart: {activeTrip.start_time ? new Date(activeTrip.start_time).toLocaleTimeString('nl-NL', {hour: '2-digit', minute: '2-digit'}) : '-'}</span>
                {activeTrip.start_odo && activeTrip.last_odo && (
                  <span className="trip-km">{(activeTrip.last_odo - activeTrip.start_odo).toFixed(1)} km gereden</span>
                )}
              </div>
            </div>
          )}

          {/* Car Status */}
          <div className="car-status-card">
            <div className="car-status-header">
              <h2>{cars.find(c => c.id === selectedCarId)?.name || carData?.car_name || 'Auto'}</h2>
              <button onClick={() => userEmail && fetchCarData(selectedCarId)} disabled={fetchingCarData || !userEmail || !selectedCarId} className="refresh-btn">
                {fetchingCarData ? '...' : '↻'}
              </button>
            </div>
            {carData ? (
              <>
                <div className="car-status-grid">
                  <div className="car-stat clickable" onClick={() => setShowChargingDetails(true)}>
                    <span className="label">Batterij</span>
                    <span className="value">{carData.battery_level != null ? `${carData.battery_level}%` : '—'} · {carData.range_km != null ? `${carData.range_km} km` : '—'}</span>
                  </div>
                  <div className="car-stat">
                    <span className="label">Status</span>
                    <span className={`value state-${carData.state}`}>
                      {carData.state === 'parked' ? 'Geparkeerd' : carData.state === 'driving' ? 'Rijdend' : carData.state === 'charging' ? 'Laden' : carData.state}
                    </span>
                  </div>
                  {carData.is_charging ? (
                    <>
                      <div className="car-stat charging-main clickable" onClick={() => setShowChargingDetails(true)}>
                        <span className="label">⚡ Laden</span>
                        <span className="value">{carData.charging_power_kw} kW</span>
                      </div>
                      <div className="car-stat clickable" onClick={() => setShowChargingDetails(true)}>
                        <span className="label">Klaar om</span>
                        <span className="value">
                          {carData.charging_remaining_minutes != null
                            ? new Date(Date.now() + carData.charging_remaining_minutes * 60000).toLocaleTimeString('nl-NL', {hour: '2-digit', minute: '2-digit'})
                            : '—'}
                        </span>
                      </div>
                    </>
                  ) : carData.is_plugged_in && (
                    <div className="car-stat charged clickable" onClick={() => setShowChargingDetails(true)}>
                      <span className="label">✓ Laden klaar</span>
                      <span className="value">{carData.battery_level}%</span>
                    </div>
                  )}
                  <div className="car-stat clickable" onClick={() => setShowCarDetails(true)}>
                    <span className="label">Details</span>
                    <span className="value">→</span>
                  </div>
                </div>

                {/* Batterij popup */}
                {showChargingDetails && (
                  <div className="popup-overlay" onClick={() => setShowChargingDetails(false)}>
                    <div className="popup" onClick={e => e.stopPropagation()}>
                      <div className="popup-header">
                        <h3>{carData.is_charging ? '⚡ Laden' : 'Batterij'}</h3>
                        <button onClick={() => setShowChargingDetails(false)}>×</button>
                      </div>
                      <div className="popup-content">
                        {/* Battery progress bar */}
                        <div className="battery-bar-container">
                          <div className="battery-bar" style={{width: `${carData.battery_level || 0}%`}}></div>
                          <span className="battery-bar-text">{carData.battery_level != null ? `${carData.battery_level}%` : '—'}</span>
                        </div>

                        <div className="popup-row">
                          <span>Bereik</span>
                          <span>{carData.range_km != null ? `${carData.range_km} km` : 'Onbekend'}</span>
                        </div>
                        {carData.battery_temp_celsius !== null && (
                          <div className="popup-row">
                            <span>Batterij temp</span>
                            <span>{carData.battery_temp_celsius}°C</span>
                          </div>
                        )}
                        <div className="popup-row">
                          <span>Stekker</span>
                          <span className={carData.is_plugged_in ? 'plugged' : ''}>{carData.is_plugged_in ? 'Aangesloten' : 'Niet aangesloten'}</span>
                        </div>
                        {carData.is_charging ? (
                          <>
                            <div className="popup-divider"></div>
                            <div className="popup-row highlight">
                              <span>Laadvermogen</span>
                              <span>{carData.charging_power_kw || 0} kW</span>
                            </div>
                            <div className="popup-row highlight">
                              <span>Klaar over</span>
                              <span>
                                {carData.charging_remaining_minutes != null
                                  ? `${Math.floor(carData.charging_remaining_minutes / 60)}u ${carData.charging_remaining_minutes % 60}m`
                                  : 'Onbekend'}
                              </span>
                            </div>
                            <div className="popup-row highlight">
                              <span>Klaar om</span>
                              <span>
                                {carData.charging_remaining_minutes != null
                                  ? new Date(Date.now() + carData.charging_remaining_minutes * 60000).toLocaleTimeString('nl-NL', {hour: '2-digit', minute: '2-digit'})
                                  : 'Onbekend'}
                              </span>
                            </div>
                          </>
                        ) : carData.is_plugged_in && (
                          <div className="popup-row">
                            <span>Status</span>
                            <span className="plugged">✓ Laden klaar</span>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                )}

                {/* Details popup */}
                {showCarDetails && (
                  <div className="popup-overlay" onClick={() => setShowCarDetails(false)}>
                    <div className="popup" onClick={e => e.stopPropagation()}>
                      <div className="popup-header">
                        <h3>Auto details</h3>
                        <button onClick={() => setShowCarDetails(false)}>×</button>
                      </div>
                      <div className="popup-content">
                        <div className="popup-row">
                          <span>Kilometerstand</span>
                          <span>{carData.odometer_km?.toLocaleString()} km</span>
                        </div>
                        <div className="popup-row">
                          <span>Stekker</span>
                          <span className={carData.is_plugged_in ? 'plugged' : ''}>{carData.is_plugged_in ? 'Aangesloten' : 'Niet aangesloten'}</span>
                        </div>
                        <div className="popup-row">
                          <span>Airco</span>
                          <span className={carData.climate_state === 'on' ? 'active' : ''}>{carData.climate_state === 'on' ? `Aan (${carData.climate_target_temp}°C)` : 'Uit'}</span>
                        </div>
                        <div className="popup-row">
                          <span>Stoelverwarming</span>
                          <span className={carData.seat_heating ? 'active' : ''}>{carData.seat_heating ? 'Aan' : 'Uit'}</span>
                        </div>
                        <div className="popup-row">
                          <span>Ruitverwarming</span>
                          <span className={carData.window_heating ? 'active' : ''}>{carData.window_heating ? 'Aan' : 'Uit'}</span>
                        </div>
                        <div className="popup-row">
                          <span>Connectie</span>
                          <span className={carData.connection_state === 'reachable' ? 'connected' : ''}>{carData.connection_state === 'reachable' ? 'Online' : carData.connection_state || 'Onbekend'}</span>
                        </div>
                        <div className="popup-row">
                          <span>Lampen</span>
                          <span>{carData.lights_state === 'off' ? 'Uit' : carData.lights_state || 'Onbekend'}</span>
                        </div>
                        {carData.latitude && carData.longitude && (
                          <div className="popup-row">
                            <a href={`https://www.google.com/maps?q=${carData.latitude},${carData.longitude}`} target="_blank" rel="noopener noreferrer">
                              Bekijk locatie →
                            </a>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                )}
              </>
            ) : fetchingCarData ? (
              <div className="car-status-loading">
                <div className="spinner"></div>
                <span>Laden...</span>
              </div>
            ) : (
              <div className="car-status-empty">Geen data beschikbaar</div>
            )}
            {carData && <div className="car-status-footer">Bijgewerkt: {new Date(carData.fetched_at).toLocaleTimeString('nl-NL')}</div>}
          </div>

          {/* Stats */}
          {stats && (
            <div className="stats">
              <div className="stat-card">
                <h3>Totaal ritten</h3>
                <div className="value">{stats.trip_count}</div>
              </div>
              <div className="stat-card">
                <h3>Totaal km</h3>
                <div className="value">{stats.total_km}</div>
              </div>
              <div className="stat-card business">
                <h3>Zakelijk km</h3>
                <div className="value">{stats.business_km}</div>
              </div>
              <div className="stat-card private">
                <h3>Privé km</h3>
                <div className="value">{stats.private_km}</div>
              </div>
            </div>
          )}

          {/* Recent Trips */}
          <div className="recent-trips">
            <h2>Laatste ritten</h2>
            <div className="trips-list">
              {trips.slice(0, 5).map(trip => (
                <div key={trip.id} className="trip-item">
                  <div className="trip-date">{trip.date}</div>
                  <div className="trip-route">{trip.from_address} → {trip.to_address}</div>
                  <div className="trip-meta">
                    <span>{trip.distance_km} km</span>
                    <span className={`badge ${trip.trip_type}`}>
                      {trip.trip_type === 'B' ? 'Zakelijk' : trip.trip_type === 'P' ? 'Privé' : 'Gemengd'}
                    </span>
                  </div>
                </div>
              ))}
            </div>
            <button className="view-all-btn" onClick={() => setActiveTab('ritten')}>Alle ritten bekijken →</button>
          </div>
        </div>
      )}

      {/* RITTEN TAB */}
      {activeTab === 'ritten' && (
        <div className="tab-content">
          <div className="ritten-header">
            <h2>Ritten</h2>
            <button className="add-btn" onClick={() => setShowAddModal(true)}>+ Rit toevoegen</button>
          </div>

          <div className="trips-table">
            <table>
              <thead>
                <tr>
                  <th>Datum</th>
                  <th>Tijd</th>
                  <th>Van</th>
                  <th>Naar</th>
                  <th>Afstand</th>
                  <th>Route</th>
                  <th>Type</th>
                  <th>Actie</th>
                </tr>
              </thead>
              <tbody>
                {trips.map(trip => (
                  <tr key={trip.id} className={`${trip.car_id === 'unknown' ? 'unknown-car' : ''} ${trip.route_flag === 'long_route' ? 'flagged-route' : ''}`}>
                    <td>{trip.date}</td>
                    <td>{trip.start_time} - {trip.end_time}</td>
                    <td className="address-cell">
                      {trip.from_address}
                      {!isKnownLocation(trip.from_address) && trip.from_lat && (
                        <button className="save-loc-btn" title="Locatie opslaan" onClick={() => setSavingLocation({lat: trip.from_lat!, lon: trip.from_lon!, current: trip.from_address})}>+</button>
                      )}
                    </td>
                    <td className="address-cell">
                      {trip.to_address}
                      {!isKnownLocation(trip.to_address) && trip.to_lat && (
                        <button className="save-loc-btn" title="Locatie opslaan" onClick={() => setSavingLocation({lat: trip.to_lat!, lon: trip.to_lon!, current: trip.to_address})}>+</button>
                      )}
                    </td>
                    <td>{trip.distance_km} km</td>
                    <td className="route-cell">
                      {trip.google_maps_km ? (
                        <div className={`route-comparison ${trip.route_flag === 'long_route' ? 'flagged' : ''}`}>
                          <span className="route-detail" title={`Gereden: ${trip.distance_km} km / Google Maps: ${trip.google_maps_km} km`}>
                            {trip.google_maps_km} km
                            {trip.route_deviation_percent !== null && trip.route_deviation_percent !== undefined && (
                              <span className={`deviation ${trip.route_deviation_percent > 5 ? 'high' : ''}`}>
                                {trip.route_deviation_percent > 0 ? '+' : ''}{trip.route_deviation_percent}%
                              </span>
                            )}
                          </span>
                          <button
                            className={`flag-btn ${trip.route_flag === 'long_route' ? 'flagged' : ''}`}
                            onClick={() => toggleRouteFlag(trip.id, trip.route_flag)}
                            title={trip.route_flag === 'long_route' ? 'Vlag verwijderen' : 'Markeer als afwijkend'}
                          >
                            ⚑
                          </button>
                        </div>
                      ) : (
                        <span className="no-route">-</span>
                      )}
                    </td>
                    <td>
                      <span className={`badge ${trip.trip_type}`}>
                        {trip.trip_type === 'B' ? 'Zakelijk' : trip.trip_type === 'P' ? 'Privé' : 'Gemengd'}
                      </span>
                    </td>
                    <td className="actions">
                      <button className="icon-btn" title="Route" onClick={() => {
                        let url = `https://www.google.com/maps/dir/?api=1&origin=${trip.from_lat},${trip.from_lon}&destination=${trip.to_lat},${trip.to_lon}`
                        if (trip.gps_trail && trip.gps_trail.length > 2) {
                          const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent)
                          const maxWaypoints = isMobile ? 3 : 9
                          const middle = trip.gps_trail.slice(1, -1)
                          const count = Math.min(maxWaypoints, middle.length)
                          const waypoints = []
                          for (let i = 0; i < count; i++) {
                            const idx = Math.floor((i + 0.5) * middle.length / count)
                            waypoints.push(middle[idx])
                          }
                          if (waypoints.length > 0) {
                            url += `&waypoints=${waypoints.map(p => `${p.lat},${p.lng}`).join('|')}`
                          }
                        }
                        window.open(url, '_blank')
                      }}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M3 12h4l3-9 4 18 3-9h4"/></svg>
                      </button>
                      <button className="icon-btn" title="Bewerken" onClick={() => setEditingTrip(trip)}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
                      </button>
                      <button className="icon-btn delete" title="Verwijderen" onClick={() => deleteTrip(trip.id)}>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M3 6h18"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6"/><path d="M8 6V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="pagination">
            <button disabled={page === 1} onClick={() => setPage(p => p - 1)}>← Vorige</button>
            <span>Pagina {page}</span>
            <button disabled={!hasMore} onClick={() => setPage(p => p + 1)}>Volgende →</button>
          </div>

          {/* Debug toggle */}
          <button className="debug-toggle" onClick={() => setShowDebug(!showDebug)}>
            {showDebug ? '▼ Debug' : '▶ Debug'}
          </button>

          {showDebug && (
            <div className="settings-section debug-section">
              <div className="section-header">
                <h2>Kilometerstand Verificatie</h2>
                <button onClick={() => userEmail && fetchOdometer()} disabled={fetchingOdo || !userEmail} className="fetch-btn">
                  {fetchingOdo ? 'Ophalen...' : 'Uitlezen'}
                </button>
              </div>

              {odometerData?.comparison && (
                <div className={`odometer-comparison ${odometerData.comparison.status}`}>
                  <div className="odo-stat">
                    <span className="label">Werkelijke km-stand</span>
                    <span className="value">{odometerData.comparison.actual_odometer_km} km</span>
                  </div>
                  <div className="odo-stat">
                    <span className="label">Berekend uit ritten</span>
                    <span className="value">{odometerData.comparison.calculated_km} km</span>
                  </div>
                  <div className="odo-stat diff">
                    <span className="label">Verschil</span>
                    <span className={`value ${odometerData.comparison.status}`}>
                      {odometerData.comparison.difference_km > 0 ? '+' : ''}{odometerData.comparison.difference_km} km
                      ({odometerData.comparison.difference_percent}%)
                    </span>
                  </div>
                </div>
              )}

              {odometerData?.warnings && odometerData.warnings.length > 0 && (
                <div className="odo-warnings">
                  {odometerData.warnings.map((w, i) => (
                    <div key={i} className="warning-item">
                      <span className="warning-icon">⚠️</span>
                      <div>
                        <div className="warning-msg">{w.message}</div>
                        <div className="warning-hint">{w.suggestion}</div>
                      </div>
                    </div>
                  ))}
                </div>
              )}

              {odometerData && odometerData.trips_timeline.length > 0 && (
                <div className="odometer-chart">
                  <OdometerChart data={odometerData} />
                </div>
              )}
            </div>
          )}
        </div>
      )}

      {/* INSTELLINGEN TAB */}
      {activeTab === 'instellingen' && (
        <div className="tab-content">
          {/* My Cars Section */}
          <div className="settings-section">
            <div className="section-header">
              <h2>Mijn Auto's</h2>
              <button className="add-btn" onClick={() => setShowAddCarModal(true)}>+ Auto toevoegen</button>
            </div>

            {cars.length === 0 ? (
              <div className="empty-state">
                <p>Nog geen auto's toegevoegd</p>
                <button className="add-btn" onClick={() => setShowAddCarModal(true)}>+ Eerste auto toevoegen</button>
              </div>
            ) : (
              <div className="cars-list">
                {cars.map(car => (
                  <div key={car.id} className="car-card" onClick={() => setEditingCar(car)}>
                    <div className="car-color" style={{ backgroundColor: car.color }}></div>
                    <div className="car-info">
                      <div className="car-name">
                        {car.name}
                        {car.is_default && <span className="default-badge">Standaard</span>}
                      </div>
                      <div className="car-meta">
                        {car.brand.charAt(0).toUpperCase() + car.brand.slice(1)} · {car.total_trips} ritten · {car.total_km.toFixed(0)} km
                      </div>
                    </div>
                    <div className="car-actions">
                      <button className="icon-btn" title="Bewerken">→</button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Export */}
          <div className="settings-section">
            <h2>Exporteren naar Google Sheets</h2>
            <div className="export-form">
              <input
                type="text"
                placeholder="Spreadsheet ID (uit URL)"
                value={spreadsheetId}
                onChange={e => setSpreadsheetId(e.target.value)}
              />
              <select
                value={exportCarId}
                onChange={e => setExportCarId(e.target.value)}
                style={{ padding: '8px', borderRadius: '6px', border: '1px solid #ddd' }}
              >
                <option value="">Alle auto&apos;s</option>
                {cars.map(car => (
                  <option key={car.id} value={car.id}>{car.name}</option>
                ))}
              </select>
              <label style={{ display: 'flex', alignItems: 'center', gap: '6px', fontSize: '14px' }}>
                <input
                  type="checkbox"
                  checked={exportSeparateSheets}
                  onChange={e => setExportSeparateSheets(e.target.checked)}
                />
                Aparte sheets per auto
              </label>
              <button onClick={exportToSheet} disabled={exporting || !spreadsheetId}>
                {exporting ? 'Bezig...' : 'Exporteren'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* MODALS */}
      {editingTrip && (
        <EditModal
          trip={editingTrip}
          onSave={(updates) => updateTrip(editingTrip.id, updates)}
          onClose={() => setEditingTrip(null)}
          cars={cars}
        />
      )}

      {showAddModal && (
        <AddModal
          onSave={addTrip}
          onClose={() => setShowAddModal(false)}
          cars={cars}
          selectedCarId={selectedCarId}
        />
      )}

      {savingLocation && (
        <div className="edit-modal" onClick={() => setSavingLocation(null)}>
          <div className="edit-modal-content small" onClick={e => e.stopPropagation()}>
            <h2>Locatie opslaan</h2>
            <p className="current-address">{savingLocation.current}</p>
            <div className="form-group">
              <label>Naam voor deze locatie</label>
              <input
                type="text"
                value={newLocationName}
                onChange={e => setNewLocationName(e.target.value)}
                placeholder="Bijv. Klant ABC"
                autoFocus
              />
            </div>
            <div className="modal-actions">
              <button onClick={() => saveLocation(newLocationName, savingLocation.lat, savingLocation.lon)} disabled={!newLocationName.trim()}>Opslaan</button>
              <button className="cancel" onClick={() => setSavingLocation(null)}>Annuleren</button>
            </div>
          </div>
        </div>
      )}

      {/* Add Car Modal */}
      {showAddCarModal && (
        <AddCarModal
          onSave={(name, brand, color, credentials) => createCar(name, brand, color, credentials)}
          onClose={() => setShowAddCarModal(false)}
        />
      )}

      {/* Edit Car Modal */}
      {editingCar && (
        <EditCarModal
          car={editingCar}
          onSave={(updates) => updateCarDetails(editingCar.id, updates)}
          onDelete={() => deleteCar(editingCar.id)}
          onClose={() => setEditingCar(null)}
          onSaveCredentials={saveCarCredentials}
          onTestCredentials={testCarCredentials}
        />
      )}
    </div>
  )
}

function EditModal({ trip, onSave, onClose, cars }: {
  trip: Trip
  onSave: (updates: Partial<Trip>) => void
  onClose: () => void
  cars: Car[]
}) {
  const dateForInput = trip.date.split('-').reverse().join('-')
  const [date, setDate] = useState(dateForInput)
  const [startTime, setStartTime] = useState(trip.start_time)
  const [endTime, setEndTime] = useState(trip.end_time)
  const [fromAddress, setFromAddress] = useState(trip.from_address)
  const [toAddress, setToAddress] = useState(trip.to_address)
  const [distanceKm, setDistanceKm] = useState(trip.distance_km)
  const [tripType, setTripType] = useState(trip.trip_type)
  const [businessKm, setBusinessKm] = useState(trip.business_km)
  const [privateKm, setPrivateKm] = useState(trip.private_km)
  const [carId, setCarId] = useState(trip.car_id || '')

  function handleTypeChange(type: string) {
    setTripType(type)
    if (type === 'B') { setBusinessKm(distanceKm); setPrivateKm(0) }
    else if (type === 'P') { setBusinessKm(0); setPrivateKm(distanceKm) }
    else { setBusinessKm(distanceKm / 2); setPrivateKm(distanceKm / 2) }
  }

  function handleDistanceChange(km: number) {
    setDistanceKm(km)
    if (tripType === 'B') { setBusinessKm(km); setPrivateKm(0) }
    else if (tripType === 'P') { setBusinessKm(0); setPrivateKm(km) }
    else { setBusinessKm(km / 2); setPrivateKm(km / 2) }
  }

  function handleSave() {
    onSave({
      date: date.split('-').reverse().join('-'),
      start_time: startTime,
      end_time: endTime,
      from_address: fromAddress,
      to_address: toAddress,
      distance_km: distanceKm,
      trip_type: tripType,
      business_km: businessKm,
      private_km: privateKm,
      car_id: carId || undefined
    })
  }

  return (
    <div className="edit-modal" onClick={onClose}>
      <div className="edit-modal-content" onClick={e => e.stopPropagation()}>
        <h2>Rit bewerken</h2>
        <div className="form-row">
          <div className="form-group">
            <label>Datum</label>
            <input type="date" value={date} onChange={e => setDate(e.target.value)} />
          </div>
          <div className="form-group">
            <label>Van</label>
            <input type="time" value={startTime} onChange={e => setStartTime(e.target.value)} />
          </div>
          <div className="form-group">
            <label>Tot</label>
            <input type="time" value={endTime} onChange={e => setEndTime(e.target.value)} />
          </div>
        </div>
        <div className="form-group">
          <label>Van adres</label>
          <input type="text" value={fromAddress} onChange={e => setFromAddress(e.target.value)} />
        </div>
        <div className="form-group">
          <label>Naar adres</label>
          <input type="text" value={toAddress} onChange={e => setToAddress(e.target.value)} />
        </div>
        <div className="form-row">
          <div className="form-group">
            <label>Afstand (km)</label>
            <input type="number" step="0.1" value={distanceKm} onChange={e => handleDistanceChange(+e.target.value)} />
          </div>
          <div className="form-group">
            <label>Type</label>
            <select value={tripType} onChange={e => handleTypeChange(e.target.value)}>
              <option value="B">Zakelijk</option>
              <option value="P">Privé</option>
              <option value="M">Gemengd</option>
            </select>
          </div>
        </div>
        {tripType === 'M' && (
          <div className="form-row">
            <div className="form-group">
              <label>Zakelijk km</label>
              <input type="number" step="0.1" value={businessKm}
                onChange={e => { setBusinessKm(+e.target.value); setPrivateKm(+(distanceKm - +e.target.value).toFixed(1)) }} />
            </div>
            <div className="form-group">
              <label>Privé km</label>
              <input type="number" step="0.1" value={privateKm}
                onChange={e => { setPrivateKm(+e.target.value); setBusinessKm(+(distanceKm - +e.target.value).toFixed(1)) }} />
            </div>
          </div>
        )}
        {cars.length > 0 && (
          <div className="form-group">
            <label>Auto</label>
            <select value={carId} onChange={e => setCarId(e.target.value)}>
              <option value="">-- Geen auto --</option>
              {cars.map(car => (
                <option key={car.id} value={car.id}>{car.name}</option>
              ))}
            </select>
          </div>
        )}
        <div className="modal-actions">
          <button onClick={handleSave}>Opslaan</button>
          <button className="cancel" onClick={onClose}>Annuleren</button>
        </div>
      </div>
    </div>
  )
}

function AddModal({ onSave, onClose, cars, selectedCarId }: {
  onSave: (trip: Partial<Trip>) => void
  onClose: () => void
  cars: Car[]
  selectedCarId: string | null
}) {
  const today = new Date().toISOString().split('T')[0]
  const now = new Date()
  const currentTime = `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`
  const [date, setDate] = useState(today)
  const [startTime, setStartTime] = useState(currentTime)
  const [endTime, setEndTime] = useState(currentTime)
  const [fromAddress, setFromAddress] = useState('')
  const [toAddress, setToAddress] = useState('')
  const [distanceKm, setDistanceKm] = useState(0)
  const [tripType, setTripType] = useState('B')
  const [carId, setCarId] = useState(selectedCarId || '')

  function handleSave() {
    onSave({
      date: date.split('-').reverse().join('-'),
      start_time: startTime,
      end_time: endTime,
      from_address: fromAddress,
      to_address: toAddress,
      distance_km: distanceKm,
      trip_type: tripType,
      business_km: tripType === 'B' ? distanceKm : tripType === 'P' ? 0 : distanceKm / 2,
      private_km: tripType === 'P' ? distanceKm : tripType === 'B' ? 0 : distanceKm / 2,
      car_id: carId || undefined,
    })
  }

  return (
    <div className="edit-modal" onClick={onClose}>
      <div className="edit-modal-content" onClick={e => e.stopPropagation()}>
        <h2>Rit toevoegen</h2>
        <div className="form-row">
          <div className="form-group">
            <label>Datum</label>
            <input type="date" value={date} onChange={e => setDate(e.target.value)} />
          </div>
          <div className="form-group">
            <label>Van</label>
            <input type="time" value={startTime} onChange={e => setStartTime(e.target.value)} />
          </div>
          <div className="form-group">
            <label>Tot</label>
            <input type="time" value={endTime} onChange={e => setEndTime(e.target.value)} />
          </div>
        </div>
        <div className="form-group">
          <label>Van adres</label>
          <input type="text" value={fromAddress} onChange={e => setFromAddress(e.target.value)} placeholder="Bijv. Thuis" />
        </div>
        <div className="form-group">
          <label>Naar adres</label>
          <input type="text" value={toAddress} onChange={e => setToAddress(e.target.value)} placeholder="Bijv. Klant ABC" />
        </div>
        <div className="form-row">
          <div className="form-group">
            <label>Afstand (km)</label>
            <input type="number" step="0.1" value={distanceKm} onChange={e => setDistanceKm(+e.target.value)} />
          </div>
          <div className="form-group">
            <label>Type</label>
            <select value={tripType} onChange={e => setTripType(e.target.value)}>
              <option value="B">Zakelijk</option>
              <option value="P">Privé</option>
              <option value="M">Gemengd</option>
            </select>
          </div>
        </div>
        {cars.length > 0 && (
          <div className="form-group">
            <label>Auto</label>
            <select value={carId} onChange={e => setCarId(e.target.value)}>
              {cars.map(car => (
                <option key={car.id} value={car.id}>{car.name}</option>
              ))}
            </select>
          </div>
        )}
        <div className="modal-actions">
          <button onClick={handleSave}>Toevoegen</button>
          <button className="cancel" onClick={onClose}>Annuleren</button>
        </div>
      </div>
    </div>
  )
}

interface ChartPoint {
  timestamp: number
  date?: string
  tripKm?: number
  odoKm?: number
  label?: string
  distance?: number
  type: string
}

function OdometerChart({ data }: { data: OdometerComparison }) {
  const chartData: ChartPoint[] = [
    ...data.trips_timeline.map(t => ({
      timestamp: new Date(t.timestamp).getTime(),
      date: t.date,
      tripKm: t.cumulative_km,
      label: `${t.from} → ${t.to}`,
      distance: t.distance_km,
      type: 'trip',
    })),
    ...data.odometer_readings.map(r => ({
      timestamp: new Date(r.timestamp).getTime(),
      odoKm: r.odometer_km,
      type: 'odometer',
    })),
  ].sort((a, b) => a.timestamp - b.timestamp)

  let lastTrip = data.start_odometer
  let lastOdo: number | undefined = undefined
  for (const d of chartData) {
    if (d.tripKm !== undefined) lastTrip = d.tripKm
    else d.tripKm = lastTrip
    if (d.odoKm !== undefined) lastOdo = d.odoKm
    else if (lastOdo !== undefined) d.odoKm = lastOdo
  }

  const formatDate = (ts: number) => {
    const d = new Date(ts)
    return `${d.getDate()}/${d.getMonth() + 1}`
  }

  const CustomTooltip = ({ active, payload }: any) => {
    if (!active || !payload?.length) return null
    const d = payload[0].payload
    const date = new Date(d.timestamp)
    const dateStr = `${date.getDate()}-${date.getMonth()+1}-${date.getFullYear()} ${date.getHours()}:${String(date.getMinutes()).padStart(2,'0')}`

    return (
      <div style={{
        background: '#1a1a1a',
        border: '1px solid #444',
        borderRadius: '8px',
        padding: '10px 14px',
        fontSize: '13px',
        color: '#fff',
        boxShadow: '0 4px 12px rgba(0,0,0,0.5)',
      }}>
        <div style={{fontWeight: 600, marginBottom: 4}}>{dateStr}</div>
        {d.label && <div style={{color: '#3b82f6'}}>🚗 {d.label}</div>}
        {d.distance && <div style={{color: '#888'}}>Rit: {d.distance} km</div>}
        {d.tripKm && <div>Berekend: <b>{d.tripKm} km</b></div>}
        {d.odoKm && <div style={{color: '#22c55e'}}>Odometer: <b>{d.odoKm} km</b></div>}
        {d.tripKm && d.odoKm && (
          <div style={{color: Math.abs(d.odoKm - d.tripKm) > d.odoKm * 0.02 ? '#ef4444' : '#888', marginTop: 4}}>
            Verschil: {(d.odoKm - d.tripKm).toFixed(1)} km
          </div>
        )}
      </div>
    )
  }

  return (
    <ResponsiveContainer width="100%" height={350}>
      <LineChart data={chartData} margin={{ top: 20, right: 30, left: 20, bottom: 20 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#333" />
        <XAxis
          dataKey="timestamp"
          type="number"
          scale="time"
          domain={['dataMin', 'dataMax']}
          tickFormatter={formatDate}
          stroke="#888"
          fontSize={12}
        />
        <YAxis
          stroke="#888"
          fontSize={12}
          domain={['dataMin - 10', 'dataMax + 10']}
          tickFormatter={(v) => `${v} km`}
        />
        <Tooltip content={<CustomTooltip />} />
        <Legend />
        <Line
          type="monotone"
          dataKey="tripKm"
          name="Berekend uit ritten"
          stroke="#3b82f6"
          strokeWidth={2}
          dot={false}
          activeDot={{ r: 4, fill: '#3b82f6' }}
        />
        <Line
          type="monotone"
          dataKey="odoKm"
          name="Odometer uitlezing"
          stroke="#22c55e"
          strokeWidth={2}
          dot={false}
          activeDot={{ r: 4, fill: '#22c55e' }}
          connectNulls={false}
        />
      </LineChart>
    </ResponsiveContainer>
  )
}

const CAR_COLORS = ['#3B82F6', '#22C55E', '#EF4444', '#F59E0B', '#8B5CF6', '#EC4899', '#6B7280', '#000000']
const CAR_BRANDS = ['audi', 'volkswagen', 'skoda', 'seat', 'cupra', 'renault', 'tesla', 'bmw', 'mercedes', 'other']

function AddCarModal({ onSave, onClose }: {
  onSave: (name: string, brand: string, color: string, credentials?: { username: string, password: string, country: string }) => void
  onClose: () => void
}) {
  const [name, setName] = useState('')
  const [brand, setBrand] = useState('audi')
  const [color, setColor] = useState('#3B82F6')
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [country, setCountry] = useState('NL')

  const handleSave = () => {
    const creds = username && password ? { username, password, country } : undefined
    onSave(name, brand, color, creds)
  }

  return (
    <div className="edit-modal" onClick={onClose}>
      <div className="edit-modal-content" onClick={e => e.stopPropagation()}>
        <h2>Auto toevoegen</h2>
        <div className="form-group">
          <label>Naam</label>
          <input type="text" value={name} onChange={e => setName(e.target.value)} placeholder="Bijv. Audi Q4 e-tron" autoFocus />
        </div>
        <div className="form-group">
          <label>Merk</label>
          <select value={brand} onChange={e => setBrand(e.target.value)}>
            {CAR_BRANDS.map(b => (
              <option key={b} value={b}>{b.charAt(0).toUpperCase() + b.slice(1)}</option>
            ))}
          </select>
        </div>
        <div className="form-group">
          <label>Kleur</label>
          <div className="color-picker">
            {CAR_COLORS.map(c => (
              <button
                key={c}
                className={`color-btn ${color === c ? 'selected' : ''}`}
                style={{ backgroundColor: c }}
                onClick={() => setColor(c)}
              />
            ))}
          </div>
        </div>

        <h3 style={{marginTop: '1.5rem', marginBottom: '0.5rem'}}>API Inloggegevens (optioneel)</h3>
        <div className="form-group">
          <label>Gebruikersnaam</label>
          <input type="text" value={username} onChange={e => setUsername(e.target.value)} placeholder="email@example.com" />
        </div>
        <div className="form-group">
          <label>Wachtwoord</label>
          <input type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Wachtwoord" />
        </div>
        <div className="form-group">
          <label>Land</label>
          <input type="text" value={country} onChange={e => setCountry(e.target.value)} placeholder="NL" />
        </div>

        <div className="modal-actions">
          <button onClick={handleSave} disabled={!name.trim()}>Toevoegen</button>
          <button className="cancel" onClick={onClose}>Annuleren</button>
        </div>
      </div>
    </div>
  )
}

function EditCarModal({ car, onSave, onDelete, onClose, onSaveCredentials, onTestCredentials }: {
  car: { id: string, name: string, brand: string, color: string, is_default: boolean, start_odometer?: number }
  onSave: (updates: Partial<{ name: string, brand: string, color: string, is_default: boolean, start_odometer: number }>) => void
  onDelete: () => void
  onClose: () => void
  onSaveCredentials?: (carId: string, creds: { brand: string, username: string, password: string, country: string }) => Promise<void>
  onTestCredentials?: (carId: string, creds: { brand: string, username: string, password: string, country: string }) => Promise<{ odometer_km?: number, battery_level?: number }>
}) {
  const [name, setName] = useState(car.name)
  const [brand, setBrand] = useState(car.brand)
  const [color, setColor] = useState(car.color)
  const [isDefault, setIsDefault] = useState(car.is_default)
  const [startOdometer, setStartOdometer] = useState(car.start_odometer || 0)

  // API credentials
  const [username, setUsername] = useState('')
  const [password, setPassword] = useState('')
  const [country, setCountry] = useState('NL')
  const [testing, setTesting] = useState(false)
  const [testResult, setTestResult] = useState<string | null>(null)

  const handleTestApi = async () => {
    if (!username || !password || !onTestCredentials) return
    setTesting(true)
    setTestResult(null)
    try {
      const result = await onTestCredentials(car.id, { brand, username, password, country })
      setTestResult(`OK! ${result.odometer_km?.toFixed(0) || '?'} km, ${result.battery_level || '?'}%`)
    } catch (e) {
      setTestResult(`Fout: ${e}`)
    } finally {
      setTesting(false)
    }
  }

  const handleSaveCredentials = async () => {
    if (!username || !password || !onSaveCredentials) return
    try {
      await onSaveCredentials(car.id, { brand, username, password, country })
      setTestResult('Opgeslagen!')
    } catch (e) {
      setTestResult(`Fout: ${e}`)
    }
  }

  return (
    <div className="edit-modal" onClick={onClose}>
      <div className="edit-modal-content" onClick={e => e.stopPropagation()}>
        <h2>Auto bewerken</h2>
        <div className="form-group">
          <label>Naam</label>
          <input type="text" value={name} onChange={e => setName(e.target.value)} />
        </div>
        <div className="form-group">
          <label>Merk</label>
          <select value={brand} onChange={e => setBrand(e.target.value)}>
            {CAR_BRANDS.map(b => (
              <option key={b} value={b}>{b.charAt(0).toUpperCase() + b.slice(1)}</option>
            ))}
          </select>
        </div>
        <div className="form-group">
          <label>Kleur</label>
          <div className="color-picker">
            {CAR_COLORS.map(c => (
              <button
                key={c}
                className={`color-btn ${color === c ? 'selected' : ''}`}
                style={{ backgroundColor: c }}
                onClick={() => setColor(c)}
              />
            ))}
          </div>
        </div>
        <div className="form-group">
          <label>
            <input type="checkbox" checked={isDefault} onChange={e => setIsDefault(e.target.checked)} />
            {' '}Standaard auto
          </label>
        </div>
        <div className="form-group">
          <label>Start kilometerstand</label>
          <input
            type="number"
            value={startOdometer || ''}
            onChange={e => setStartOdometer(parseFloat(e.target.value) || 0)}
            placeholder="0"
            step="0.1"
          />
          <small style={{ color: '#888', fontSize: '0.8rem' }}>Voor km verificatie - kilometerstand bij eerste rit</small>
        </div>

        <hr style={{ margin: '1.5rem 0', borderColor: '#333' }} />

        <h3 style={{ marginBottom: '1rem' }}>API Koppeling ({brand.charAt(0).toUpperCase() + brand.slice(1)})</h3>
        <div className="form-group">
          <label>E-mail / Gebruikersnaam</label>
          <input type="text" value={username} onChange={e => setUsername(e.target.value)} placeholder="myaudi@email.com" />
        </div>
        <div className="form-group">
          <label>Wachtwoord</label>
          <input type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="••••••••" />
        </div>
        <div className="form-group">
          <label>Land</label>
          <input type="text" value={country} onChange={e => setCountry(e.target.value)} placeholder="NL" />
        </div>
        {testResult && (
          <div className={`test-result ${testResult.startsWith('OK') || testResult.startsWith('Opgeslagen') ? 'success' : 'error'}`}>
            {testResult}
          </div>
        )}
        <div className="api-actions" style={{ display: 'flex', gap: '0.5rem', marginBottom: '1rem' }}>
          <button onClick={handleTestApi} disabled={testing || !username || !password}>
            {testing ? 'Testen...' : 'Test API'}
          </button>
          <button onClick={handleSaveCredentials} disabled={!username || !password}>
            API Opslaan
          </button>
        </div>

        <div className="modal-actions">
          <button onClick={() => onSave({ name, brand, color, is_default: isDefault, start_odometer: startOdometer })} disabled={!name.trim()}>Auto Opslaan</button>
          <button className="cancel" onClick={onClose}>Sluiten</button>
          <button className="delete" onClick={onDelete}>Verwijderen</button>
        </div>
      </div>
    </div>
  )
}
