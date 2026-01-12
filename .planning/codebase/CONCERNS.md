# Codebase Concerns

**Analysis Date:** 2026-01-12

## Tech Debt

**Hardcoded API Credentials in Configuration:**
- Issue: Multiple Renault Gigya API keys and VW Group OAuth client IDs hardcoded in source
- File: `api/config.py` lines 166-183
- Why: Rapid development, credentials needed for multi-locale support
- Impact: Credentials exposed in git history, accessible to anyone with repo access
- Fix approach: Move all credentials to environment variables or Secret Manager

**Dual Configuration Pattern:**
- Issue: Both `Config` dataclass and legacy `CONFIG` dict maintained in parallel
- File: `api/config.py` lines 83-111
- Why: Incremental migration from dict-based config
- Impact: Dual maintenance burden, risk of version skew
- Fix approach: Complete migration to dataclass, remove dict

**Print Statements in Production Code:**
- Issue: Debug print() statements instead of structured logging
- Files: `watch/MileageWatch/MileageWatch/APIClient.swift` lines 40, 42, 45; `watch/MileageWatch/MileageWatch/MileageViewModel.swift` line 29
- Why: Quick debugging during development
- Impact: Uncontrolled output, not captured in error tracking
- Fix approach: Replace with os.Logger or proper logging framework

## Known Bugs

**Bare Exception Handling:**
- Symptoms: Catches all exceptions including KeyboardInterrupt, SystemExit
- Trigger: Token refresh flow error handling
- File: `api/main.py` line 191
- Workaround: None - errors silently swallowed
- Root cause: Bare `except:` clause without specific exception type
- Fix: Change to `except Exception as e:` with proper logging

**Undefined Variable Reference:**
- Symptoms: Could cause NameError at runtime
- Trigger: Specific auth fallback conditions
- File: `api/main.py` line 177
- Workaround: Not triggered in normal flow
- Root cause: `x_user_email` used but not in function signature
- Fix: Add proper parameter or remove reference

## Security Considerations

**Overly Permissive CORS Configuration:**
- Risk: Enables CSRF attacks, allows any origin to make credentialed requests
- File: `api/main.py` lines 46-52
- Current mitigation: AUTH_ENABLED feature flag
- Recommendations:
  - Replace `allow_origins=["*"]` with specific frontend domains
  - Remove `allow_credentials=True` with wildcard origin
  - Restrict `allow_methods` and `allow_headers`

**Webhook Authentication Gap:**
- Risk: Anyone knowing a user's email can trigger trip events
- File: `api/routes/webhooks.py`
- Current mitigation: None
- Recommendations:
  - Add API key or HMAC signature verification
  - Implement rate limiting
  - Consider IP allowlisting for automation sources

**Unencrypted Token Storage Fallback:**
- Risk: Auth tokens visible to any code on Watch
- File: `watch/MileageWatch/MileageWatch/WatchConnectivityManager.swift` lines 25-27
- Current mitigation: iCloud Keychain is preferred path
- Recommendations:
  - Remove UserDefaults fallback
  - Ensure Keychain-only storage

## Performance Bottlenecks

**N+1 Query Pattern in Car Stats:**
- Problem: Individual stat query for each car in a loop
- File: `api/services/car_service.py` lines 26-41
- Measurement: With 10 cars: 10+ Firestore reads per request
- Cause: `get_car_stats(user_id, doc.id)` called per car
- Improvement: Batch query or aggregation, consider caching

**Inefficient Trip Pagination:**
- Problem: Loads 3x limit documents then filters in-memory
- File: `api/services/trip_service.py` lines 54-56
- Measurement: O(n*3) document reads for pagination
- Cause: Workaround for Firestore query limitations with car_id filter
- Improvement: Add composite indexes, restructure queries

**Excessive Logging in Hot Paths:**
- Problem: Every GPS ping generates multiple log lines
- Files: `api/services/webhook_service.py` lines 32, 59, 62, 79
- Measurement: 1000s of pings/day = 1000s of log writes
- Cause: Debug logging left in place
- Improvement: Use debug level, add sampling, or remove

## Fragile Areas

**Webhook State Machine:**
- File: `api/services/webhook_service.py` (643 lines)
- Why fragile: Complex state transitions (gps_only_mode, no_driving_count, api_error_count)
- Common failures: Race conditions between ping/end events
- Safe modification: Add state diagram documentation, comprehensive tests
- Test coverage: No tests exist

**Authentication Middleware Chain:**
- File: `api/auth/middleware.py`
- Why fragile: Multiple public path exemptions, feature flag logic
- Common failures: New routes not added to PUBLIC_PATHS
- Safe modification: Test all auth paths, document exemptions
- Test coverage: No tests exist

## Scaling Limits

**Firestore Document Limits:**
- Current capacity: 1 MB per document, 20k writes/sec per database
- Limit: Trip with very long GPS trail could exceed document size
- Symptoms at limit: Write failures, data truncation
- Scaling path: Subcollection for GPS points if needed

**Cloud Run Cold Starts:**
- Current capacity: Unknown response time impact
- Limit: Webhook timeouts during cold start
- Symptoms at limit: Missed trip events
- Scaling path: Minimum instances > 0, optimize startup

## Dependencies at Risk

**next-auth Beta Version:**
- Risk: Using ^5.0.0-beta.30, not stable release
- File: `frontend/package.json`
- Impact: Breaking changes possible in minor versions
- Migration plan: Monitor for stable release, pin to specific version

**carconnectivity Libraries:**
- Risk: Third-party car API wrappers, may lag behind API changes
- File: `api/pyproject.toml`
- Impact: Car integrations could break without warning
- Migration plan: Monitor upstream releases, have fallback OAuth flows

## Missing Critical Features

**Automated Test Suite:**
- Problem: No unit tests for critical business logic
- Current workaround: Manual testing
- Blocks: Confident refactoring, regression prevention
- Implementation: Add pytest for API, expand flutter_test coverage

**.env.example File:**
- Problem: Environment variables not documented
- Current workaround: Reverse-engineer from config.py
- Blocks: Developer onboarding, deployment setup
- Implementation: Create .env.example with all required vars

## Test Coverage Gaps

**Trip Finalization Logic:**
- What's not tested: Distance calculation, classification, odometer validation
- Files: `api/services/trip_service.py`
- Risk: Calculation bugs create incorrect records
- Priority: High
- Difficulty: Need mocked Firestore, car providers

**Webhook State Transitions:**
- What's not tested: Start/ping/end flow, state recovery
- Files: `api/services/webhook_service.py`
- Risk: Trip data corruption, lost events
- Priority: High
- Difficulty: Complex state machine requires integration tests

**Car Provider OAuth Flows:**
- What's not tested: Token refresh, multi-brand auth
- Files: `api/car_providers/*.py`, `api/routes/oauth/*.py`
- Risk: Auth failures break car data fetching
- Priority: Medium
- Difficulty: Need mock OAuth servers

---

*Concerns audit: 2026-01-12*
*Update as issues are fixed or new ones discovered*
