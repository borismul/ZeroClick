---
created: 2026-01-13T00:05
title: Show Live Activity on background trip start
area: ios
files:
  - mobile/ios/Runner/AppDelegate.swift
  - mobile/ios/TripLiveActivityExtension/TripLiveActivityExtensionLiveActivity.swift
---

## Problem

When a trip starts in the background (via motion detection or Bluetooth connection), the Live Activity card doesn't appear on the lock screen or Dynamic Island. The user only sees the Live Activity when they manually open the app.

This defeats the purpose of the "workout-style" live trip tracking experience - users should see the live km counter without having to open the app.

## Solution

TBD - Need to investigate:
- Check if `ActivityKit.startActivity()` is being called from background context
- Verify Live Activity entitlements allow background starts
- May need to use push notifications to trigger Live Activity updates
- Check if `NSSupportsLiveActivities` and background modes are configured correctly
