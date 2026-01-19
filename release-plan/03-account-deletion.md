# 03: Account Deletion Feature

## Why Required
Apple requires that any app allowing account creation MUST also provide a way to delete the account. This is a common rejection reason.

Your app uses Google Sign-In = account creation = MUST have deletion.

## What Needs to Happen on Deletion

1. **Frontend (Mobile App)**
   - Add "Delete Account" button in Settings
   - Show confirmation dialog
   - Call API to delete account
   - Sign out user
   - Clear local data

2. **Backend (API)**
   - Delete all user trips from Firestore
   - Delete all user locations from Firestore
   - Delete user cache entries
   - Revoke authentication tokens

## Implementation

### Step 1: Add API Endpoint

Add to `api/main.py`:

```python
@app.delete("/account")
async def delete_account(user: dict = Depends(get_current_user)):
    """Delete user account and all associated data."""
    user_id = user["user_id"]

    # Delete all trips
    trips_ref = db.collection("trips").where("user_id", "==", user_id)
    for doc in trips_ref.stream():
        doc.reference.delete()

    # Delete all locations
    locations_ref = db.collection("locations").where("user_id", "==", user_id)
    for doc in locations_ref.stream():
        doc.reference.delete()

    # Delete cache entries
    cache_ref = db.collection("cache").where("user_id", "==", user_id)
    for doc in cache_ref.stream():
        doc.reference.delete()

    # Delete user document if exists
    user_doc = db.collection("users").document(user_id)
    if user_doc.get().exists:
        user_doc.delete()

    return {"status": "deleted", "message": "Account and all data deleted"}
```

### Step 2: Add to Mobile App

Add to `mobile/lib/services/api_service.dart`:

```dart
Future<void> deleteAccount() async {
  final response = await _authenticatedRequest(
    'DELETE',
    '/account',
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to delete account');
  }
}
```

### Step 3: Add UI in Settings Screen

Add to `mobile/lib/screens/settings_screen.dart`:

```dart
// Add this in the settings list
ListTile(
  leading: Icon(Icons.delete_forever, color: Colors.red),
  title: Text('Account verwijderen'),
  subtitle: Text('Verwijder je account en alle gegevens'),
  onTap: () => _showDeleteAccountDialog(context),
),

// Add this method
void _showDeleteAccountDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Account verwijderen?'),
      content: Text(
        'Dit verwijdert permanent al je ritten en gegevens. '
        'Deze actie kan niet ongedaan worden gemaakt.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuleren'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await _deleteAccount(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text('Verwijderen'),
        ),
      ],
    ),
  );
}

Future<void> _deleteAccount(BuildContext context) async {
  try {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Delete account via API
    await ApiService().deleteAccount();

    // Sign out
    await AuthService().signOut();

    // Clear local data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account verwijderd')),
    );
  } catch (e) {
    Navigator.pop(context); // Dismiss loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fout bij verwijderen: $e')),
    );
  }
}
```

### Step 4: Add to Watch App Settings

Add to `watch/MileageWatch/MileageWatch/Views/SettingsView.swift`:

```swift
Button(role: .destructive) {
    showingDeleteConfirmation = true
} label: {
    Label("Account verwijderen", systemImage: "trash")
}
.alert("Account verwijderen?", isPresented: $showingDeleteConfirmation) {
    Button("Annuleren", role: .cancel) { }
    Button("Verwijderen", role: .destructive) {
        Task {
            await viewModel.deleteAccount()
        }
    }
} message: {
    Text("Dit verwijdert permanent al je gegevens.")
}
```

## Testing Checklist

- [ ] Delete button visible in Settings
- [ ] Confirmation dialog appears
- [ ] API call succeeds
- [ ] All Firestore data deleted
- [ ] User signed out
- [ ] Local storage cleared
- [ ] Redirected to login screen
- [ ] Can create new account after deletion

## Apple's Requirements

From App Store Review Guidelines 5.1.1:
> Apps that offer account creation must also offer account deletion.
> The account deletion option must be easy to find.
> Temporary deactivation is not sufficient - must be full deletion.
