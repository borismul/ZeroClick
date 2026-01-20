# Changelog

All notable changes to Zero Click will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-20

### Added
- Firebase Analytics for usage insights (privacy-respecting)
- Firebase Crashlytics for crash reporting
- In-app privacy policy and terms of service
- Firestore read optimization (99% reduction)
- Watch app smart refresh (reduces battery usage)
- Cursor-based trip pagination
- Denormalized car statistics

### Changed
- Improved error handling with user-friendly messages
- Split monolithic AppProvider into focused providers
- Extracted iOS services from AppDelegate
- Refactored oversized screen files

### Fixed
- Motion detection hysteresis for reliable trip detection
- GPS-only fallback when car API unavailable

## [1.0.0] - 2025-12-01

### Added
- Initial development version
- Automatic trip detection via iOS motion sensors
- Multi-car support (Audi, VW, Tesla, Renault, generic)
- Live Activity during trips
- Apple Watch companion app
- Google Sheets export
- Business/private trip classification
