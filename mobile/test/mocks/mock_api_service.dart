import 'package:mocktail/mocktail.dart';

import 'package:zero_click/services/api_service.dart';

/// Mock API service for testing webhook flows.
///
/// Usage:
/// ```dart
/// final mockApi = MockApiService();
/// when(() => mockApi.sendPing(any(), any())).thenAnswer(
///   (_) async => ApiResponses.drivingResponse(),
/// );
/// ```
///
/// For stubbing methods that return model types, import the models:
/// - package:zero_click/models/trip.dart (Trip, ActiveTrip, Stats)
/// - package:zero_click/models/car.dart (Car, CarData, CarCredentials, CarStats)
/// - package:zero_click/models/location.dart (UserLocation)
class MockApiService extends Mock implements ApiService {}

/// Register fallback values for mocktail any() matchers.
///
/// Call this in setUpAll() before using any() matchers:
/// ```dart
/// setUpAll(() {
///   registerApiServiceFallbacks();
/// });
/// ```
void registerApiServiceFallbacks() {
  registerFallbackValue(0.0); // for lat/lng
  registerFallbackValue(''); // for strings
  registerFallbackValue(<String, dynamic>{}); // for maps
}
