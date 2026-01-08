#!/usr/bin/env python3
"""Simulate the morning trip at 50x speed to test GPS trail fix."""

import requests
import time
from datetime import datetime

API_URL = "https://mileage-api-269285054406.europe-west4.run.app"
USER = "borismulder91@gmail.com"

# GPS pings from the morning trip (extracted from logs)
GPS_PINGS = [
    (51.927670199999994, 4.362096616666666),
    (51.92770846666667, 4.3622444),
    (51.92798936666666, 4.365775683333333),
    (51.928346866666665, 4.3682577333333334),
    (51.93089615, 4.368684916666667),
    (51.93333317561921, 4.368272632249427),
    (51.93735583333334, 4.369760933333333),
    (51.94109385, 4.368764033333333),
    (51.94347675, 4.368797649999999),
    (51.94502881666667, 4.373787833333334),
    (51.94879672242612, 4.372205504397632),
    (51.953862051796115, 4.369006749229076),
    (51.95867051105576, 4.366004047333928),
    (51.96437903390347, 4.36217909954217),
    (51.96908856666667, 4.359755533333333),
    (51.973046322809296, 4.358377703620077),
    (51.97772601666667, 4.35639905),
    (51.9789062132946, 4.356992409329969),
    # Stopped at Abtswoude (school drop-off) - same location for ~7 pings
    (51.97890759439698, 4.357000624673655),
    (51.97890759439698, 4.357000624673655),
    (51.97890759439698, 4.357000624673655),
    (51.97890759439698, 4.357000624673655),
    (51.97890759439698, 4.357000624673655),
    (51.97890759439698, 4.357000624673655),
    # Started moving again
    (51.9788688008186, 4.356769861453547),
    (51.978839150000006, 4.355981483333333),
    (51.98160023333333, 4.3549191),
    (51.98494965, 4.353658783333334),
    (51.98675507351105, 4.351085671006856),
    (51.98584123333333, 4.348178699999999),
    (51.98489407805055, 4.345445357374393),
    (51.9858872, 4.3448767833333335),
    (51.986955699999996, 4.3514913),
    (51.98777240003144, 4.355321723853557),
    (51.98856256666666, 4.357820783333334),
    (51.990298716666665, 4.364015283333333),
    (51.993104816666666, 4.375580683333332),
    (51.995538016666664, 4.387981033333333),
    (51.99591055, 4.390281233333334),
    (51.99692689808048, 4.390560991149087),
    (52.00018929648209, 4.387849838851114),
    (52.00451005, 4.3855991),
    (52.008955633333336, 4.380842833333333),
    (52.0137224, 4.375284733333333),
    (52.01784806666666, 4.370481416666666),
    (52.0227376, 4.364781833333333),
    (52.02792765000001, 4.358734383333334),
    (52.0352502, 4.352968966666666),
    (52.0429682, 4.353006183333333),
    (52.04834536666667, 4.359672633333333),
    (52.053131216666664, 4.3671273500000005),
    (52.05860316666667, 4.372707699999999),
    (52.059142433333335, 4.382520633333333),
    (52.054739266666665, 4.397485866666667),
    (52.05256133333334, 4.413169316666667),
    (52.0514187, 4.429305483333333),
    (52.05032873333333, 4.443569566666667),
    (52.04932180000001, 4.456532716666667),
    (52.04844073333334, 4.467906966666666),
    (52.04791508333333, 4.474678233333334),
    (52.04659578333334, 4.47469375),
    (52.04722879999999, 4.472559),
    (52.04715121666666, 4.477759183333333),
    (52.04666293333333, 4.483620383333333),
    (52.046336783333324, 4.483298416666667),
    (52.046246216666674, 4.4827738833333335),
    # Final position at office
    (52.04624835, 4.4827758),
]

SPEEDUP = 50  # 50x faster
PING_INTERVAL = 50  # Original interval was ~50 seconds


def send_ping(lat: float, lng: float) -> dict:
    """Send a GPS ping to the API."""
    url = f"{API_URL}/webhook/ping"
    params = {"user": USER}
    data = {"lat": lat, "lng": lng}

    try:
        resp = requests.post(url, params=params, json=data, timeout=30)
        return resp.json()
    except Exception as e:
        return {"error": str(e)}


def send_start(lat: float, lng: float) -> dict:
    """Send a start event."""
    url = f"{API_URL}/webhook/start"
    params = {"user": USER}
    data = {"lat": lat, "lng": lng}

    try:
        resp = requests.post(url, params=params, json=data, timeout=30)
        return resp.json()
    except Exception as e:
        return {"error": str(e)}


def send_end(lat: float, lng: float) -> dict:
    """Send an end event."""
    url = f"{API_URL}/webhook/end"
    params = {"user": USER}
    data = {"lat": lat, "lng": lng}

    try:
        resp = requests.post(url, params=params, json=data, timeout=30)
        return resp.json()
    except Exception as e:
        return {"error": str(e)}


def main():
    print(f"=== Trip Simulation (50x speed) ===")
    print(f"API: {API_URL}")
    print(f"User: {USER}")
    print(f"Pings: {len(GPS_PINGS)}")
    print(f"Real interval: {PING_INTERVAL}s, Simulated: {PING_INTERVAL/SPEEDUP:.1f}s")
    print()

    sleep_time = PING_INTERVAL / SPEEDUP

    # Send start event
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Sending START...")
    result = send_start(GPS_PINGS[0][0], GPS_PINGS[0][1])
    print(f"  -> {result.get('status', result)}")

    # Send all pings
    for i, (lat, lng) in enumerate(GPS_PINGS):
        print(f"[{datetime.now().strftime('%H:%M:%S')}] Ping {i+1}/{len(GPS_PINGS)}: ({lat:.4f}, {lng:.4f})")
        result = send_ping(lat, lng)
        status = result.get('status', result.get('error', 'unknown'))
        extra = ""
        if 'parked_count' in result:
            extra = f" parked={result['parked_count']}"
        if 'total' in str(result):
            extra += f" gps={result.get('gps_count', '?')}"
        print(f"  -> {status}{extra}")

        if i < len(GPS_PINGS) - 1:
            time.sleep(sleep_time)

    # Send end event
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Sending END...")
    result = send_end(GPS_PINGS[-1][0], GPS_PINGS[-1][1])
    print(f"  -> {result}")

    print()
    print("=== Simulation Complete ===")


if __name__ == "__main__":
    main()
