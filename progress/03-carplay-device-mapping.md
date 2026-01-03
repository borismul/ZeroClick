# CarPlay Device ID Mapping - Progress

**Story:** Epic 1, Story 3 - Auto-detect car based on CarPlay/Bluetooth device ID
**Status:** Completed
**Date:** 2025-12-30

## Summary

Implemented automatic car detection based on Bluetooth device name. When the phone connects to a car's Bluetooth audio system (or CarPlay), the app detects the device name and matches it to a car's `carplay_device_id` field. If matched, the trip auto-starts for that car. If unknown, the user is prompted to link the device to a car.

## Completed Features

### API (`api/main.py`)

- [x] `get_car_id_by_device(user_id, device_id)` - Look up car by `carplay_device_id`
- [x] `webhook_ping` - Accepts `device_id` param
- [x] `webhook_start` - Accepts `device_id` param

### iOS Native (`ios/Runner/AppDelegate.swift`)

- [x] `AVAudioSession` setup for Bluetooth audio detection
- [x] `audioRouteChanged` listener for real-time connection events
- [x] `getBluetoothDeviceName()` - Returns connected Bluetooth audio device name
- [x] `FlutterMethodChannel` for Bluetooth → Flutter communication
- [x] Events: `onBluetoothConnected`, `onBluetoothDisconnected`

### Flutter Services

- [x] `BluetoothService` (`lib/services/bluetooth_service.dart`)
  - `getConnectedDevice()` - Get current Bluetooth device name
  - `setConnectionCallback()` - Listen for connection changes

### Flutter App Logic (`lib/providers/app_provider.dart`)

- [x] `_setupBluetoothListener()` - Initialize Bluetooth monitoring
- [x] `findCarByDeviceId(deviceId)` - Find car by device name (case-insensitive)
- [x] `_tryAutoStartTrip()` - Auto-start when CarPlay/Bluetooth connects
- [x] `startTripForCar(car, deviceId)` - Start trip with specific car
- [x] `linkDeviceAndStartTrip(deviceName, car)` - Link unknown device to car
- [x] `pendingUnknownDevice` - Track device waiting to be linked
- [x] `onUnknownDevice` callback for UI notification

### Flutter UI

- [x] `DeviceLinkDialog` (`lib/widgets/device_link_dialog.dart`)
  - Shows unknown device name
  - Lists available cars
  - One-tap to link and start trip
- [x] Car edit screen shows `carplay_device_id` field (read-only, auto-set)

## User Flow

### First Time (Unknown Device)
1. User gets in car, Bluetooth connects
2. App detects device: "Audi MMI 1234"
3. No matching car found
4. Dialog appears: "Onbekend apparaat: Audi MMI 1234"
5. User taps their car in the list
6. Device linked + trip started automatically
7. Future connections auto-detect this car

### Subsequent Times (Known Device)
1. User gets in car, Bluetooth connects
2. App detects device: "Audi MMI 1234"
3. Matches car: "Audi Q4 e-tron"
4. Trip auto-starts for that car

## Technical Notes

### Bluetooth Detection (iOS)
Uses `AVAudioSession` to detect Bluetooth audio devices:
```swift
func getBluetoothDeviceName() -> String? {
    let session = AVAudioSession.sharedInstance()
    for output in session.currentRoute.outputs {
        if output.portType == .bluetoothA2DP ||
           output.portType == .bluetoothHFP ||
           output.portType == .carAudio {
            return output.portName
        }
    }
    return nil
}
```

### Device Matching
Case-insensitive matching in Flutter:
```dart
Car? findCarByDeviceId(String deviceId) {
  return _cars.firstWhere(
    (car) => car.carplayDeviceId?.toLowerCase() == deviceId.toLowerCase(),
    orElse: () => null,
  );
}
```

### No Default Car Fallback
If device is unknown and not linked, trip does NOT start. User must explicitly link the device to a car. This prevents trips being assigned to wrong car.

## Files Changed

### API
- `api/main.py`: `get_car_id_by_device()`, webhook `device_id` params

### iOS Native
- `ios/Runner/AppDelegate.swift`: Full Bluetooth detection implementation

### Flutter
- `lib/services/bluetooth_service.dart` (new)
- `lib/widgets/device_link_dialog.dart` (new)
- `lib/providers/app_provider.dart`: Bluetooth handling, auto-start logic
- `lib/main.dart`: Unknown device callback setup
- `lib/services/api_service.dart`: `deviceId` parameter
- `lib/screens/cars_screen.dart`: Device ID field in car edit

## Next Steps

- [x] **Story 4: Car-specific odometer tracking**
  - See `progress/04-car-specific-odometer.md`

- [ ] **Story 5: Multi-car export to Google Sheets**
  - Export shows car name/column
  - Filter export by car
  - Separate sheets per car (optional)
