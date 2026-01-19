# Motion Detection State Machine

## Overview

Motion detection uses iOS CMMotionActivity to detect when the user is driving.
The state machine has been hardened with debouncing to prevent false positives
from rapid motion state oscillation (e.g., walking to car, traffic stops).

## Architecture

```
CMMotionActivityManager
        |
        v
MotionActivityHandler (debounce logic)
        |
        +-- didDetectAutomotive (immediate, logging only)
        |
        +-- didConfirmAutomotive (after debounce, trip control)
        |
        v
    AppDelegate
        |
        +-- startDriveTracking()
        |
        +-- stopDriveTracking()
```

## States

| State | Description |
|-------|-------------|
| IDLE | Not tracking, monitoring for automotive motion |
| AUTOMOTIVE_PENDING | Automotive detected, awaiting debounce confirmation |
| TRACKING | Actively tracking trip (automotive confirmed) |
| END_PENDING | Non-automotive detected, awaiting debounce confirmation |

## State Diagram

```
                  +-----------+
                  |   IDLE    |
                  +-----------+
                       |
                       | [automotive detected]
                       v
              +------------------+
              | AUTOMOTIVE_PENDING |
              +------------------+
                 |           |
                 |           | [non-automotive before timeout]
                 |           +------------------------+
                 |                                    |
                 | [debounce timeout (2s)]            |
                 v                                    v
           +-----------+                        +-----------+
           | TRACKING  |                        |   IDLE    |
           +-----------+                        +-----------+
                 |
                 | [stationary/walking detected]
                 v
           +-------------+
           | END_PENDING |
           +-------------+
              |       |
              |       | [automotive before timeout]
              |       +------------------------+
              |                                |
              | [debounce timeout (3s)]        |
              v                                v
        +-----------+                   +-----------+
        |   IDLE    |                   | TRACKING  |
        | (trip ends)|                  | (continues)|
        +-----------+                   +-----------+
```

## Transitions

| From | Event | To | Action |
|------|-------|-----|--------|
| IDLE | automotive detected | AUTOMOTIVE_PENDING | Start 2s debounce timer |
| AUTOMOTIVE_PENDING | debounce timeout | TRACKING | Call didConfirmAutomotive(true), start trip |
| AUTOMOTIVE_PENDING | non-automotive detected | IDLE | Cancel debounce timer |
| TRACKING | stationary/walking detected | END_PENDING | Start 3s debounce timer |
| END_PENDING | debounce timeout | IDLE | Call didConfirmAutomotive(false), end trip |
| END_PENDING | automotive detected | TRACKING | Cancel debounce timer, continue trip |

## Configuration

| Parameter | Default | Description |
|-----------|---------|-------------|
| minimumConfidence | .medium | Minimum CMMotionActivityConfidence to accept |
| automotiveDebounceSeconds | 2.0 | Wait time before confirming trip start |
| nonAutomotiveDebounceSeconds | 3.0 | Wait time before confirming trip end |

## Confidence Levels

CMMotionActivityConfidence maps to:
- `.low` (0) - Unreliable, always ignored
- `.medium` (1) - Default minimum threshold
- `.high` (2) - Most reliable

Activities below the minimum confidence threshold are completely ignored.

## Edge Cases Handled

### 1. Walk to Car
**Scenario:** User walks to car, phone briefly detects automotive (getting in), then stationary.
**Behavior:** Automotive not confirmed (< 2s), no trip starts.
**Test:** `testWalkToCarDoesNotFalseStart()`

### 2. Traffic Stops
**Scenario:** Driving, stop at red light (stationary ~2s), continue driving.
**Behavior:** Stationary not confirmed (< 3s), trip continues.
**Test:** `testTrafficStopsContinueTrip()`

### 3. Brief Stops
**Scenario:** Quick stop at gas station entrance, drive through.
**Behavior:** Stationary debounce cancelled when automotive resumes.
**Test:** `testBriefStopDoesNotEndTrip()`

### 4. Actual Parking
**Scenario:** Driver parks, turns off engine, exits car.
**Behavior:** Stationary > 3s confirmed, trip ends.
**Test:** `testParkingEndsTrip()`

### 5. Walking After Driving
**Scenario:** Driver parks and walks away.
**Behavior:** Walking > 3s confirmed, trip ends.
**Test:** `testWalkingAfterDrivingEndsTrip()`

### 6. Low Confidence
**Scenario:** Phone detects low-confidence automotive (unreliable).
**Behavior:** Event ignored entirely, no state change.
**Test:** `testLowConfidenceDoesNotStartTrip()`

### 7. Rapid Oscillation
**Scenario:** Rapid changes between automotive/stationary/walking.
**Behavior:** Only confirmed states trigger trip changes.
**Test:** `testRapidOscillationPreventsMultipleTrips()`

## Delegate Methods

### didDetectAutomotive
Called immediately when automotive state changes (before debounce).
Use for logging, UI feedback.

```swift
func motionHandler(_ handler: MotionActivityHandlerProtocol, didDetectAutomotive isAutomotive: Bool) {
    debugLog("Motion", "Detected \(isAutomotive ? "automotive" : "non-automotive")")
}
```

### didConfirmAutomotive
Called after debounce period confirms state change.
Use for trip start/stop actions.

```swift
func motionHandler(_ handler: MotionActivityHandlerProtocol, didConfirmAutomotive isAutomotive: Bool) {
    if isAutomotive && !isDriving {
        isDriving = true
        startDriveTracking()
    } else if !isAutomotive && isDriving {
        isDriving = false
        stopDriveTracking()
    }
}
```

## Files

| File | Purpose |
|------|---------|
| `Runner/Services/MotionActivityHandlerProtocol.swift` | Protocol defining interface and delegate |
| `Runner/Services/MotionActivityHandler.swift` | Implementation with debounce logic |
| `Runner/AppDelegate.swift` | Responds to confirmed events for trip control |
| `RunnerTests/MotionDetectionTests.swift` | Unit tests for debounce logic |
| `RunnerTests/TripLifecycleTests.swift` | Integration tests for edge cases |
| `RunnerTests/Mocks/MockMotionActivityHandler.swift` | Mock for testing |

## Design Rationale

### Asymmetric Debounce Times
- **Start debounce (2s):** Shorter because false starts are quickly corrected
- **End debounce (3s):** Longer because false ends disrupt trip recording

### Separate Detection vs Confirmation
- **didDetectAutomotive:** Immediate feedback for debugging/logging
- **didConfirmAutomotive:** Stable state for trip control decisions

This separation allows:
1. Responsive logging without affecting trip logic
2. Clear test assertions for both immediate and debounced behavior
3. Future flexibility to add UI feedback on detection before confirmation
