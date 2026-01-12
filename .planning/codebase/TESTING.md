# Testing Patterns

**Analysis Date:** 2026-01-12

## Test Framework

**Python (API):**
- Runner: No formal test framework configured
- Status: Minimal testing - only `api/test_audi.py` (debug script, not unit test)
- Dev dependencies: Empty (`dev = []` in pyproject.toml)
- Gap: No pytest, no unit tests for critical paths

**Flutter (Mobile):**
- Runner: flutter_test (built-in)
- Mocking: mocktail ^1.0.4
- Config: `mobile/analysis_options.yaml` with strict linting
- Status: Infrastructure configured but minimal actual tests

**TypeScript (Frontend):**
- Runner: None configured
- Status: No test files, no vitest/jest setup
- Gap: No component or integration tests

**Swift (Watch/iOS):**
- Runner: None configured
- Status: No XCTest targets visible
- Gap: No unit or UI tests

**Run Commands:**
```bash
# Flutter tests
cd mobile && flutter test

# Python (if pytest added)
cd api && pytest

# TypeScript (if vitest added)
cd frontend && npm test
```

## Test File Organization

**Current State:**
- Mobile: `mobile/test/widget_test.dart` (single file)
- API: `api/test_audi.py` (debug script, not proper test)
- Frontend: No test files
- Watch: No test files

**Expected Pattern (not yet implemented):**
```
api/
  tests/
    test_trips.py
    test_webhook.py
    test_car_providers/
      test_audi.py
      test_tesla.py

mobile/
  test/
    services/
      api_service_test.dart
    models/
      trip_test.dart
    widget_test.dart

frontend/
  __tests__/
    page.test.tsx
```

## Test Structure

**Flutter Pattern (from analysis_options):**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('TripService', () {
    test('should fetch trips successfully', () async {
      // arrange
      final mockApi = MockApiService();
      when(() => mockApi.fetchTrips()).thenAnswer((_) async => []);

      // act
      final result = await tripService.getTrips();

      // assert
      expect(result, isEmpty);
    });
  });
}
```

**Python Pattern (recommended):**
```python
import pytest
from unittest.mock import Mock, patch

class TestTripService:
    def test_get_trips_returns_list(self):
        # arrange
        mock_db = Mock()
        service = TripService()

        # act
        result = service.get_trips("user@test.com")

        # assert
        assert isinstance(result, list)
```

## Mocking

**Flutter (mocktail):**
```dart
class MockApiService extends Mock implements ApiService {}

// Usage
final mock = MockApiService();
when(() => mock.method()).thenReturn(value);
verify(() => mock.method()).called(1);
```

**Python (recommended):**
```python
from unittest.mock import Mock, patch

@patch('services.trip_service.get_db')
def test_function(mock_db):
    mock_db.return_value = Mock()
```

**What to Mock:**
- External APIs (Firestore, Google APIs, car provider APIs)
- Network calls
- File system operations
- Time/dates

**What NOT to Mock:**
- Pure functions, utilities
- Internal business logic
- Data model constructors

## Coverage

**Current Requirements:**
- No enforced coverage target
- No coverage reports configured

**Recommended Setup:**
```bash
# Python
pytest --cov=api --cov-report=html

# Flutter
flutter test --coverage
```

## Test Types

**Unit Tests (needed):**
- API services: trip_service, car_service, webhook_service
- Mobile services: api_service, auth_service
- Data models: JSON parsing, validation

**Integration Tests (needed):**
- API routes with mocked database
- End-to-end webhook flow
- OAuth flows per car brand

**E2E Tests (not implemented):**
- Full trip lifecycle
- Multi-device sync (mobile → watch)

## Linting & Static Analysis

**Dart (configured):**
- Base: `package:flutter_lints/flutter.yaml`
- Strict mode: `strict-casts`, `strict-inference`, `strict-raw-types`
- Key rules:
  - `avoid_print: error`
  - `prefer_single_quotes: true`
  - `require_trailing_commas: true`
  - `always_declare_return_types: true`
- Config: `mobile/analysis_options.yaml`

**TypeScript (configured):**
- Strict mode enabled in `frontend/tsconfig.json`
- No ESLint/Prettier configured

**Python (not configured):**
- No pylint, flake8, black, or ruff config
- Gap: Should add linting for consistency

**Swift (not configured):**
- No SwiftFormat or SwiftLint

## Test Coverage Gaps

**Critical Missing Tests:**

1. **Trip Finalization Logic** (`api/services/trip_service.py`)
   - Risk: Distance calculation bugs, classification errors
   - Priority: High

2. **Webhook State Machine** (`api/services/webhook_service.py`)
   - Risk: Trip state corruption, race conditions
   - Priority: High

3. **Car Provider Authentication** (`api/car_providers/*.py`)
   - Risk: OAuth flow failures, token refresh bugs
   - Priority: High

4. **Odometer Validation**
   - Risk: Negative distances, unrealistic values
   - Priority: Medium

5. **Offline Queue** (`mobile/lib/services/offline_queue.dart`)
   - Risk: Data loss when reconnecting
   - Priority: Medium

## Recommendations

**Immediate:**
1. Add pytest to API dev dependencies
2. Create `api/tests/` directory structure
3. Write tests for trip_service critical paths

**Short-term:**
1. Add vitest to frontend
2. Expand Flutter test coverage
3. Add coverage reporting to CI

**Long-term:**
1. Integration tests for car providers
2. E2E tests for webhook flows
3. Performance/load testing for API

---

*Testing analysis: 2026-01-12*
*Update when test patterns change*
