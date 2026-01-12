# Coding Conventions

**Analysis Date:** 2026-01-12

## Naming Patterns

**Files:**
- Python: snake_case (`trip_service.py`, `car_service.py`, `location_service.py`)
- TypeScript/React: PascalCase for components (`TripMap.tsx`), camelCase for utils (`auth-actions.ts`)
- Dart: snake_case (`app_provider.dart`, `api_service.dart`, `trip.dart`)
- Swift: PascalCase (`MileageViewModel.swift`, `ContentView.swift`, `APIClient.swift`)
- Test files: `*_test.dart` for Flutter

**Functions:**
- Python: snake_case (`get_trips()`, `create_manual_trip()`, `finalize_trip()`)
- TypeScript: camelCase (`apiHeaders()`, `parseLocale()`)
- Dart: camelCase (`startTrip()`, `endTrip()`, `requestPermissions()`)
- Swift: camelCase (`fetchTrips()`, `refreshData()`)

**Variables:**
- Python: snake_case, UPPER_SNAKE_CASE for constants
- Dart: camelCase, leading underscore for private (`_api`, `_isLoading`)
- Swift: camelCase, leading underscore for private

**Types:**
- All languages: PascalCase for classes/interfaces/enums
- Python: No `I` prefix for abstract classes
- TypeScript: No `I` prefix for interfaces
- Dart: Factory constructors: `Trip.fromJson()`

## Code Style

**Python:**
- Indentation: 4 spaces
- Quotes: Double quotes for strings
- Type hints: Modern Python 3.10+ union syntax (`str | None` not `Optional[str]`)
- Line length: ~80-100 chars (PEP 8)

**TypeScript:**
- Indentation: 2 spaces
- Quotes: Single quotes
- Semicolons: Present
- Strict mode: Enabled in `tsconfig.json`

**Dart:**
- Indentation: 2 spaces
- Quotes: Single quotes preferred
- Semicolons: Required
- Trailing commas: Required (`require_trailing_commas: true`)
- Strict analysis: Enabled (`strict-casts`, `strict-inference`, `strict-raw-types`)

**Swift:**
- Indentation: 4 spaces
- Quotes: Double quotes
- MARK comments: `// MARK: - SectionName` for organization

## Import Organization

**Python:**
1. Standard library (`import os`, `import logging`)
2. Third-party (`from fastapi import...`, `from google.cloud import...`)
3. Local modules (`from config import...`, `from .google import...`)

**TypeScript:**
1. External packages (`import { ... } from 'next'`)
2. Internal modules (`import { ... } from '@/lib/...'`)
3. Relative imports (`import { ... } from './...'`)

**Dart:**
1. Dart SDK (`import 'dart:async'`)
2. Package imports (`import 'package:flutter/material.dart'`)
3. Relative imports (`import '../services/api_service.dart'`)

**Swift:**
- Foundation and system frameworks first
- Grouped by framework

## Error Handling

**Python Patterns:**
```python
try:
    result = await some_operation()
except ValueError as e:
    logger.error(f"Operation failed: {e}")
    raise HTTPException(status_code=400, detail=str(e))
```
- Services throw exceptions with descriptive messages
- Routes catch and convert to HTTPException
- Use `logger.error()` before re-raising

**Dart Patterns:**
```dart
try {
  final result = await apiService.fetchData();
  return result;
} catch (e) {
  _log.error('Failed to fetch: $e');
  return null;
}
```
- Return null or default on failure
- Log errors with context

**Swift Patterns:**
```swift
do {
    let data = try await fetchData()
} catch {
    print("[Component] Error: \(error)")
}
```

## Logging

**Python:**
- Framework: `logging` module
- Pattern: `logger = logging.getLogger(__name__)`
- Levels: debug, info, warning, error
- Format: `logger.info(f"Message: {variable}")`

**Dart:**
- Framework: Custom `AppLogger` class
- Pattern: `static const _log = AppLogger('ServiceName')`
- Location: `mobile/lib/core/logging/app_logger.dart`
- `avoid_print: error` enforced in analysis_options

**Swift:**
- Current: `print()` statements (should be improved)
- Pattern: `print("[Component] Message")`

## Comments

**When to Comment:**
- Explain why, not what
- Document business rules and edge cases
- Mark sections with clear headers

**Python Docstrings:**
```python
def get_current_user(...) -> str:
    """
    Get authenticated user from token.

    Args:
        credentials: Bearer token from Authorization header
        x_user_email: User email from X-User-Email header

    Returns:
        User email string

    Raises:
        HTTPException 401: If authentication fails
    """
```

**Section Comments:**
- Python: `# === Section Name ===`
- Swift: `// MARK: - Section Name`
- Dart: `// --- Section ---` or just inline comments

## Function Design

**Size:**
- Keep under 50-100 lines
- Extract helpers for complex logic
- Services are larger (webhook_service.py: 643 lines) but modular

**Parameters:**
- Python: Type hints required, defaults at end
- Dart: Named parameters with `required` keyword
- Swift: External/internal parameter names

**Return Values:**
- Python: Explicit return types (`-> Trip | None`)
- Dart: Nullable returns (`Trip?`) for optional data
- Consistent patterns across similar functions

## Module Design

**Python:**
- Service classes with singleton instances: `trip_service = TripService()`
- `__init__.py` for package exports
- Relative imports within packages

**Dart:**
- One public class per file typically
- Private helpers with underscore prefix
- Factory constructors for JSON parsing

**TypeScript:**
- Named exports preferred
- Default exports for React components
- Type interfaces in separate `types/` directory

## API Design Patterns

**REST Endpoints:**
- Verbs: GET (list/read), POST (create), PATCH (update), DELETE (remove)
- Path: `/trips`, `/trips/{trip_id}`, `/cars/{car_id}/data`
- Query params: snake_case (`year`, `month`, `car_id`, `page`, `limit`)

**Response Models:**
- Explicit Pydantic types: `response_model=Sequence[Trip]`
- Consistent error format: `{"detail": "error message"}`

---

*Convention analysis: 2026-01-12*
*Update when patterns change*
