#!/usr/bin/env python3
"""Simulate a complete trip by directly manipulating the cache as if Audi car was driving."""

import time
from datetime import datetime, timedelta
from google.cloud import firestore

# GPS pings from the morning trip
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
    (51.97890759439698, 4.357000624673655),
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
    (52.04624835, 4.4827758),
]

USER = "borismulder91@gmail.com"
CAR_ID = "URRmOkq43FZ5f81KOZI3"
START_ODO = 377.0
END_ODO = 405.0


def main():
    db = firestore.Client(project='mileage-tracker-482013')

    print("=== Simulating Complete Trip ===")
    print(f"User: {USER}")
    print(f"GPS points: {len(GPS_PINGS)}")
    print(f"Odometer: {START_ODO} -> {END_ODO} km")
    print()

    # Create GPS events with timestamps (simulated 50 seconds apart)
    start_time = datetime.utcnow()
    gps_events = []
    for i, (lat, lng) in enumerate(GPS_PINGS):
        ts = (start_time + timedelta(seconds=i*50)).isoformat() + "Z"
        gps_events.append({
            "lat": lat,
            "lng": lng,
            "timestamp": ts,
            "is_skip": False,
        })

    # Create Audi GPS trail (just start and end positions)
    audi_gps_trail = [
        {"lat": GPS_PINGS[0][0], "lng": GPS_PINGS[0][1], "timestamp": gps_events[0]["timestamp"]},
        {"lat": GPS_PINGS[-1][0], "lng": GPS_PINGS[-1][1], "timestamp": gps_events[-1]["timestamp"]},
    ]

    # Build the cache as it would be at trip end
    cache = {
        "active": True,
        "user_id": USER,
        "car_id": CAR_ID,
        "car_name": "Audi Q4 e-tron",
        "start_time": gps_events[0]["timestamp"],
        "start_odo": START_ODO,
        "last_odo": END_ODO,
        "no_driving_count": 0,
        "parked_count": 3,  # Trigger finalization
        "gps_events": gps_events,
        "gps_trail": audi_gps_trail,  # Audi GPS (sparse)
        "audi_gps": {"lat": GPS_PINGS[-1][0], "lng": GPS_PINGS[-1][1], "timestamp": gps_events[-1]["timestamp"]},
        "end_triggered": gps_events[-1]["timestamp"],
    }

    print(f"Created cache with {len(gps_events)} GPS events")
    print(f"Audi GPS trail: {len(audi_gps_trail)} points")

    # Save the cache
    db.collection("cache").document(f"active_trip_{USER}").set(cache)
    print("Saved cache to Firestore")

    # Now we need to call the safety net to finalize
    print()
    print("Calling safety net endpoint to finalize...")

    import requests
    url = "https://mileage-api-269285054406.europe-west4.run.app/webhook/safety-net"
    resp = requests.post(url, timeout=60)
    result = resp.json()
    print(f"Result: {result}")

    # Check the created trip
    print()
    print("Checking created trip...")
    trips = list(db.collection("trips").order_by("created_at", direction=firestore.Query.DESCENDING).limit(1).stream())
    if trips:
        trip = trips[0].to_dict()
        print(f"Trip ID: {trips[0].id}")
        print(f"  Route: {trip['from_address']} -> {trip['to_address']}")
        print(f"  Distance: {trip['distance_km']} km")
        print(f"  GPS trail: {len(trip.get('gps_trail', []))} points")
        if trip.get('gps_trail'):
            print(f"  First GPS: {trip['gps_trail'][0]}")
            print(f"  Last GPS: {trip['gps_trail'][-1]}")
    else:
        print("No trip found!")


if __name__ == "__main__":
    main()
