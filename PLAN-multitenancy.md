# Multi-tenancy Fix Plan

## Huidige Status

### ✅ Al gescheiden per gebruiker:
- **Trips** - GET/POST /trips filtert op user_id
- **Stats** - GET /stats filtert op user_id
- **Car Settings** - Opgeslagen in `users/{email}/settings/car`
- **Car Data** - Haalt data op met user's eigen car credentials

### ❌ Nog NIET gescheiden (kan interfereren):

1. **Webhook Cache** (`cache/trip_start`)
   - Globaal document voor actieve rit tracking
   - Als Boris een rit start, ziet Tim dit ook
   - Probleem: iPhone automation stuurt geen user_id mee

2. **Locaties** (`locations` collection)
   - Alle gebruikers delen dezelfde bekende locaties
   - Thuis/Kantoor/etc zijn globaal

3. **Odometer Readings** (`odometer_readings` collection)
   - Globale collection voor km-stand verificatie

4. **Scheduler** (Cloud Scheduler job)
   - Pollt alleen Boris's auto
   - Geen support voor meerdere auto's/gebruikers

---

## Fix Plan

### Stap 1: Webhook Cache per User
**Probleem**: De cache voor actieve ritten is globaal.

**Oplossing**:
- Cache verplaatsen naar `users/{email}/cache/trip_start`
- Webhook endpoints user_id parameter toevoegen
- iPhone automation moet user_id meesturen (via URL parameter?)

**Aanpassingen**:
```python
# api/main.py
def get_trip_cache(user_id: str) -> dict | None:
    doc = db.collection("users").document(user_id).collection("cache").document("trip_start").get()
    ...

def set_trip_cache(user_id: str, cache: dict):
    db.collection("users").document(user_id).collection("cache").document("trip_start").set(cache)
```

**Webhook URL wordt**:
```
POST /webhook/start?user=boris@example.com
POST /webhook/end?user=boris@example.com
```

### Stap 2: Locaties per User (optioneel)
**Probleem**: Locaties zijn gedeeld.

**Oplossing A** (simpel): Locaties blijven gedeeld - dit is misschien wenselijk voor zakelijke locaties.

**Oplossing B** (volledig gescheiden):
- Locaties verplaatsen naar `users/{email}/locations`
- Thuis/Kantoor config per user in settings

### Stap 3: Scheduler per User
**Probleem**: Cloud Scheduler pollt alleen 1 auto.

**Oplossing**:
- Scheduler endpoint wijzigen om alle actieve gebruikers te pollen
- Of: aparte scheduler job per gebruiker (complex)
- Of: Scheduler alleen voor Boris, Tim gebruikt alleen handmatige ritten

**Simpelste aanpak**:
```python
@app.post("/scheduler/poll-all")
def poll_all_users():
    # Get all users with active trips
    users_with_trips = get_users_with_active_trips()
    for user_id in users_with_trips:
        poll_user_car(user_id)
```

### Stap 4: Odometer Readings per User
**Probleem**: Km-stand verificatie is globaal.

**Oplossing**:
- Readings verplaatsen naar `users/{email}/odometer_readings`
- `/audi/compare` endpoint user_id parameter toevoegen

---

## Implementatie Volgorde

1. **Webhook Cache per User** (prioriteit hoog)
   - Voorkomt dat ritten door elkaar lopen
   - ~30 min werk

2. **Scheduler aanpassen** (prioriteit hoog)
   - Nodig voor automatische trip tracking per user
   - ~1 uur werk

3. **Odometer Readings per User** (prioriteit medium)
   - Km verificatie werkt dan per user
   - ~30 min werk

4. **Locaties per User** (prioriteit laag)
   - Kan ook gedeeld blijven
   - ~30 min werk indien gewenst

---

## iPhone Automation Aanpassing

Tim moet z'n eigen iPhone automation instellen met z'n email in de URL:

```
POST https://mileage-api-xxx.run.app/webhook/start?user=tim.zwart@nextnovate.com
Body: {"lat": ..., "lng": ...}
```

Of via header:
```
POST https://mileage-api-xxx.run.app/webhook/start
Header: X-User-Email: tim.zwart@nextnovate.com
Body: {"lat": ..., "lng": ...}
```
