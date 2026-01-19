# Project: Zero Click iOS App Store Release

## Core Value

Prepare the Zero Click autonomous trip tracking app for iOS App Store release by improving code quality, addressing technical debt, and meeting all compliance requirements.

## Overview

Zero Click is a personal-use autonomous trip tracking system. The mobile app (Flutter) detects driving via iOS motion sensors, tracks trips via GPS, and integrates with car brand APIs (Audi, VW, Tesla, Renault) for odometer readings. A watchOS companion app provides at-a-glance trip status.

**Current state:** Functional for personal use but has significant technical debt and missing App Store requirements.

## Goals

1. **Code Quality:** Refactor oversized files (AppDelegate 828 lines, cars_screen 2008 lines, app_provider 954 lines)
2. **iOS Native:** Extract services from monolithic AppDelegate, fix motion detection hysteresis
3. **Flutter Architecture:** Split AppProvider into focused providers
4. **Compliance:** Add privacy policy/terms screens, verify PrivacyInfo.xcprivacy
5. **Testing:** Establish baseline test coverage for critical flows
6. **Release:** Complete App Store Connect requirements, prepare screenshots

## Target Platform

- **Primary:** iOS App Store (iPhone + Apple Watch)
- **Secondary:** Android (not in this milestone scope)

## Constraints

- Personal project - no dedicated QA team
- Existing users (personal use) - maintain backwards compatibility
- Must continue working during refactoring (no feature freeze)

## Key Technical Debt (from codebase analysis)

| Area | Issue | Lines |
|------|-------|-------|
| iOS Native | AppDelegate.swift monolith | 828 |
| Flutter UI | cars_screen.dart does OAuth, WebView, UI | 2008 |
| Flutter State | app_provider.dart manages everything | 954 |
| Flutter UI | permission_onboarding_screen.dart | 969 |
| Testing | Only 1 test file exists | minimal |
| Compliance | No in-app privacy/terms | missing |

## Key Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2025-01-19 | iOS first, Android later | Focus resources on one platform |
| 2025-01-19 | Comprehensive depth | Thorough refactoring for maintainability |
| 2025-01-19 | Provider pattern retained | Working well, just needs splitting |

## Success Criteria

- [ ] All files under 500 lines (prefer under 300)
- [ ] AppDelegate responsibilities extracted to services
- [ ] AppProvider split into 3+ focused providers
- [ ] Privacy policy & terms screens accessible in-app
- [ ] Unit tests for authentication flow
- [ ] App Store submission ready
