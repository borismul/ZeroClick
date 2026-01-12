---
created: 2026-01-12T23:25
title: Implement Google auth token refresh
area: auth
files:
  - mobile/lib/services/auth_service.dart
  - api/auth/google.py
  - frontend/auth.ts
  - watch/MileageWatch/MileageWatch/APIClient.swift
---

## Problem

The app requires users to re-authenticate via Google login every time their access token expires. This creates a poor user experience with repeated login prompts instead of seamless background token refresh.

Current flow:
1. User logs in with Google Sign-In
2. Access token stored (short-lived, typically 1 hour)
3. Token expires
4. User sees login prompt again

Expected flow:
1. User logs in with Google Sign-In
2. Access token AND refresh token stored
3. When access token expires, use refresh token to get new access token silently
4. User stays logged in indefinitely (until refresh token revoked)

Affected platforms:
- Mobile (Flutter) - `mobile/lib/services/auth_service.dart`
- Watch (SwiftUI) - `watch/MileageWatch/MileageWatch/APIClient.swift`
- Frontend - `frontend/auth.ts` (NextAuth may already handle this)

## Solution

Research latest Google OAuth 2.0 refresh token patterns (2025-2026 docs):

1. **Mobile (Flutter)**:
   - Check if `google_sign_in` package supports refresh tokens
   - May need to switch to `googleapis_auth` or manual OAuth flow
   - Store refresh token in secure storage (Keychain)

2. **Watch**:
   - Receive refresh token from iPhone via WatchConnectivity
   - Implement token refresh in APIClient before requests

3. **API**:
   - Verify backend can validate refreshed tokens
   - Consider adding token refresh endpoint if needed

Key questions to research:
- Does Google's current OAuth implementation provide refresh tokens for mobile apps?
- What scopes are needed to get refresh tokens?
- How long do refresh tokens last?
