# 07: Subscription Implementation

## Business Model Options

### Option A: Free with Premium (Recommended)
| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | Manual trips, 30-day history, basic stats |
| Pro Monthly | $4.99/mo | Auto-tracking, unlimited history, export |
| Pro Yearly | $39.99/yr | Same as monthly, 33% savings |

### Option B: One-Time Purchase
| Tier | Price | Features |
|------|-------|----------|
| Free | $0 | Limited features |
| Pro | $19.99 | All features, lifetime |

### Option C: Fully Free (Monetize Later)
Launch free to get users, add subscriptions later.

## Fastest Implementation: RevenueCat

RevenueCat handles all the complexity and is FREE up to $2,500/month revenue.

### Step 1: Create RevenueCat Account
1. Go to https://www.revenuecat.com
2. Sign up (free)
3. Create new project "Mileage Tracker"

### Step 2: Configure App Store Connect
1. Go to App Store Connect → My Apps → Your App
2. Go to **In-App Purchases** → **Manage**
3. Click **+** to create products:

#### Product 1: Monthly Subscription
- Reference Name: `Pro Monthly`
- Product ID: `mileage_pro_monthly`
- Type: Auto-Renewable Subscription
- Subscription Group: `Mileage Pro`
- Price: $4.99 (Tier 5)
- Duration: 1 Month

#### Product 2: Yearly Subscription
- Reference Name: `Pro Yearly`
- Product ID: `mileage_pro_yearly`
- Type: Auto-Renewable Subscription
- Subscription Group: `Mileage Pro`
- Price: $39.99 (Tier 40)
- Duration: 1 Year

### Step 3: Link RevenueCat to App Store Connect
1. In RevenueCat dashboard → Project Settings
2. Add iOS app with bundle ID `nl.borism.mileageTracker`
3. Add App Store Connect API key (create in App Store Connect → Users → Keys)

### Step 4: Add RevenueCat SDK to Flutter

Add to `mobile/pubspec.yaml`:
```yaml
dependencies:
  purchases_flutter: ^8.0.0
```

### Step 5: Initialize RevenueCat

Add to `mobile/lib/main.dart`:
```dart
import 'package:purchases_flutter/purchases_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Purchases.configure(
    PurchasesConfiguration('your_revenuecat_api_key')
      ..appUserID = null // RevenueCat generates anonymous ID
  );

  runApp(MyApp());
}
```

### Step 6: Create Paywall Screen

Create `mobile/lib/screens/paywall_screen.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallScreen extends StatefulWidget {
  @override
  _PaywallScreenState createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  Offerings? _offerings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      setState(() {
        _offerings = offerings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _purchase(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      if (result.entitlements.all['pro']?.isActive ?? false) {
        Navigator.pop(context, true); // Purchase successful
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Aankoop mislukt: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final offering = _offerings?.current;
    if (offering == null) {
      return Scaffold(body: Center(child: Text('Geen abonnementen beschikbaar')));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Upgrade naar Pro')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Mileage Tracker Pro',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 16),
          _buildFeatureList(),
          SizedBox(height: 24),
          ...offering.availablePackages.map((package) =>
            _buildPackageCard(package)
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              await Purchases.restorePurchases();
            },
            child: Text('Aankopen herstellen'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _featureRow('Automatische ritdetectie'),
        _featureRow('Onbeperkte rithistorie'),
        _featureRow('Export naar Google Sheets'),
        _featureRow('Apple Watch app'),
      ],
    );
  }

  Widget _featureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Package package) {
    return Card(
      child: ListTile(
        title: Text(package.storeProduct.title),
        subtitle: Text(package.storeProduct.description),
        trailing: ElevatedButton(
          onPressed: () => _purchase(package),
          child: Text(package.storeProduct.priceString),
        ),
      ),
    );
  }
}
```

### Step 7: Check Subscription Status

```dart
Future<bool> isPro() async {
  final customerInfo = await Purchases.getCustomerInfo();
  return customerInfo.entitlements.all['pro']?.isActive ?? false;
}
```

### Step 8: Gate Features

```dart
void onExportTapped() async {
  if (await isPro()) {
    // Allow export
    exportToSheets();
  } else {
    // Show paywall
    final purchased = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PaywallScreen()),
    );
    if (purchased == true) {
      exportToSheets();
    }
  }
}
```

## Alternative: Pure StoreKit 2 (No SDK)

For simpler needs, use StoreKit 2 directly with Flutter's `in_app_purchase` package:

```yaml
dependencies:
  in_app_purchase: ^3.2.0
```

This requires more code but has no third-party dependency.

## RevenueCat Dashboard

After setup, RevenueCat provides:
- Real-time revenue metrics
- Subscriber analytics
- Churn analysis
- A/B testing for paywalls
- Cross-platform support (if you add Android)

## Testing Subscriptions

1. Create Sandbox tester in App Store Connect → Users → Sandbox Testers
2. Sign out of App Store on device
3. Sign in with sandbox account when prompted during purchase
4. Subscriptions renew quickly in sandbox (1 month = 5 minutes)

## Checklist

- [ ] Choose business model
- [ ] Create RevenueCat account
- [ ] Create products in App Store Connect
- [ ] Link RevenueCat to App Store
- [ ] Add SDK to Flutter app
- [ ] Create paywall screen
- [ ] Gate premium features
- [ ] Add "Restore Purchases" button
- [ ] Test with sandbox account
