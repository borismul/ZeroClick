// Car management screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/app_provider.dart';
import '../models/car.dart';
import '../utils/color_utils.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cars),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddCarDialog(context),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.cars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_car, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noCarsAdded,
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCarDialog(context),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addCar),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshCars(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.cars.length,
              itemBuilder: (context, index) {
                final car = provider.cars[index];
                return _CarCard(car: car);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCarDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCarDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEditCarScreen(),
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final Car car;

  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _editCar(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: parseHexColor(car.color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCarIcon(car.icon),
                  color: parseHexColor(car.color),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Car info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          car.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (car.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.defaultBadge,
                              style: const TextStyle(color: Colors.blue, fontSize: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.getBrandLabel(l10n),
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.route,
                          value: '${car.totalTrips} ${l10n.trips}',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.straighten,
                          value: '${car.totalKm.toStringAsFixed(0)} ${l10n.km}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(Icons.chevron_right, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  void _editCar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditCarScreen(car: car),
      ),
    );
  }

  IconData _getCarIcon(String icon) {
    switch (icon) {
      case 'car-suv':
        return Icons.directions_car;
      case 'car-sports':
        return Icons.sports_score;
      case 'car-van':
        return Icons.airport_shuttle;
      case 'car-hatchback':
        return Icons.directions_car_filled;
      default:
        return Icons.directions_car;
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const _StatChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(value, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      ],
    );
  }
}

class AddEditCarScreen extends StatefulWidget {
  final Car? car;

  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _deviceIdController;
  late String _brand;
  late String _color;
  late String _icon;
  bool _isDefault = false;
  bool _isSaving = false;

  // API credentials
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _countryController;
  bool _isTestingApi = false;
  String? _apiTestResult;

  bool get isEditing => widget.car != null;

  static const List<String> _colors = [
    '#3B82F6', // Blue
    '#22C55E', // Green
    '#EF4444', // Red
    '#F59E0B', // Orange
    '#8B5CF6', // Purple
    '#EC4899', // Pink
    '#6B7280', // Gray
    '#000000', // Black
  ];

  List<Map<String, dynamic>> _getIcons(AppLocalizations l10n) => [
    {'value': 'car', 'icon': Icons.directions_car, 'label': l10n.iconSedan},
    {'value': 'car-suv', 'icon': Icons.directions_car, 'label': l10n.iconSUV},
    {'value': 'car-hatchback', 'icon': Icons.directions_car_filled, 'label': l10n.iconHatchback},
    {'value': 'car-sports', 'icon': Icons.sports_score, 'label': l10n.iconSport},
    {'value': 'car-van', 'icon': Icons.airport_shuttle, 'label': l10n.iconVan},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.car?.name ?? '');
    _deviceIdController = TextEditingController(text: widget.car?.carplayDeviceId ?? '');
    _brand = widget.car?.brand ?? 'other';
    _color = widget.car?.color ?? '#3B82F6';
    _icon = widget.car?.icon ?? 'car';
    _isDefault = widget.car?.isDefault ?? false;

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _countryController = TextEditingController(text: 'NL');

    // Check if credentials already exist
    if (isEditing) {
      _checkExistingCredentials();
    }
  }

  Future<void> _checkExistingCredentials() async {
    final provider = context.read<AppProvider>();
    try {
      final creds = await provider.getCarCredentials(widget.car!.id);
      if (creds != null && mounted) {
        // Has credentials - show connected state
        setState(() => _apiTestResult = 'success');
      }
    } catch (e) {
      // No credentials or error - show login
    }
  }

  Future<void> _logout() async {
    final provider = context.read<AppProvider>();
    try {
      await provider.deleteCarCredentials(widget.car!.id);
      if (mounted) {
        setState(() => _apiTestResult = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Uitgelogd'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final icons = _getIcons(l10n);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editCar : l10n.addCar),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteCar,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Preview
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: parseHexColor(_color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getCarIcon(_icon),
                  color: parseHexColor(_color),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                hintText: l10n.nameHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.enterName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Brand
            DropdownButtonFormField<String>(
              initialValue: _brand,
              decoration: InputDecoration(
                labelText: l10n.brand,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.branding_watermark),
              ),
              items: [
                DropdownMenuItem(value: 'audi', child: Text(l10n.brandAudi)),
                DropdownMenuItem(value: 'volkswagen', child: Text(l10n.brandVolkswagen)),
                DropdownMenuItem(value: 'skoda', child: Text(l10n.brandSkoda)),
                DropdownMenuItem(value: 'seat', child: Text(l10n.brandSeat)),
                DropdownMenuItem(value: 'cupra', child: Text(l10n.brandCupra)),
                DropdownMenuItem(value: 'renault', child: Text(l10n.brandRenault)),
                DropdownMenuItem(value: 'tesla', child: Text(l10n.brandTesla)),
                DropdownMenuItem(value: 'bmw', child: Text(l10n.brandBMW)),
                DropdownMenuItem(value: 'mercedes', child: Text(l10n.brandMercedes)),
                DropdownMenuItem(value: 'other', child: Text(l10n.brandOther)),
              ],
              onChanged: (value) {
                setState(() => _brand = value ?? 'other');
              },
            ),
            const SizedBox(height: 24),

            // Color picker
            Text(l10n.color, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _colors.map((color) {
                final isSelected = _color == color;
                return GestureDetector(
                  onTap: () => setState(() => _color = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: parseHexColor(color),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [BoxShadow(color: parseHexColor(color), blurRadius: 8)]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Icon picker
            Text(l10n.icon, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: icons.map((item) {
                final isSelected = _icon == item['value'];
                return GestureDetector(
                  onTap: () => setState(() => _icon = item['value']),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? parseHexColor(_color).withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: parseHexColor(_color), width: 2)
                              : null,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? parseHexColor(_color) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? parseHexColor(_color) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Default toggle
            SwitchListTile(
              title: Text(l10n.defaultCar),
              subtitle: Text(l10n.defaultCarSubtitle),
              value: _isDefault,
              onChanged: (value) => setState(() => _isDefault = value),
            ),

            const SizedBox(height: 24),

            // Bluetooth Device ID
            TextFormField(
              controller: _deviceIdController,
              decoration: InputDecoration(
                labelText: l10n.bluetoothDevice,
                hintText: l10n.autoSetOnConnect,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.bluetooth),
                suffixIcon: _deviceIdController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _deviceIdController.clear());
                        },
                      )
                    : null,
              ),
              readOnly: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.autoSetOnConnectFull),
                  ),
                );
              },
            ),
            if (_deviceIdController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${l10n.autoSetOnConnectFull}: "${_deviceIdController.text}"',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),

            const SizedBox(height: 24),

            // API Credentials (only for editing)
            if (isEditing) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text(
                l10n.carApiConnection,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.connectWithBrand(_getBrandAppName(_brand, l10n)),
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Tesla and Audi use OAuth, others use username/password
              if (_brand == 'tesla') ...[
                _OAuthLoginCard(
                  brandName: 'Tesla',
                  brandColor: const Color(0xFFE82127),
                  icon: Icons.electric_car,
                  description: l10n.teslaLoginInfo,
                  buttonText: l10n.loginWithTesla,
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: _loginWithTesla,
                  onLogout: _logout,
                ),
              ] else if (_brand == 'audi') ...[
                // Audi OAuth-only login
                _OAuthLoginCard(
                  brandName: 'Audi',
                  brandColor: const Color(0xFFBB0A30),
                  icon: Icons.directions_car,
                  description: 'Log in met je myAudi account',
                  buttonText: 'Inloggen met Audi ID',
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: _loginWithAudi,
                  onLogout: _logout,
                ),
              ] else if (_brand == 'renault') ...[
                // Renault direct login (Gigya API)
                _RenaultLoginForm(
                  usernameController: _usernameController,
                  passwordController: _passwordController,
                  countryController: _countryController,
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: _loginWithRenault,
                  onLogout: _logout,
                ),
              ] else if (_brand == 'volkswagen') ...[
                // Volkswagen OAuth login
                _OAuthLoginCard(
                  brandName: 'Volkswagen',
                  brandColor: const Color(0xFF001E50), // VW dark blue
                  icon: Icons.directions_car,
                  description: 'Log in met je Volkswagen ID account',
                  buttonText: 'Inloggen met Volkswagen ID',
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: () => _loginWithVWGroup('volkswagen'),
                  onLogout: _logout,
                ),
              ] else if (_brand == 'skoda') ...[
                // Skoda OAuth login
                _OAuthLoginCard(
                  brandName: 'Skoda',
                  brandColor: const Color(0xFF4BA82E), // Skoda green
                  icon: Icons.eco,
                  description: 'Log in met je Skoda ID account',
                  buttonText: 'Inloggen met Skoda ID',
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: () => _loginWithVWGroup('skoda'),
                  onLogout: _logout,
                ),
              ] else if (_brand == 'seat') ...[
                // SEAT OAuth login
                _OAuthLoginCard(
                  brandName: 'SEAT',
                  brandColor: const Color(0xFFE5007D), // SEAT magenta
                  icon: Icons.flash_on,
                  description: 'Log in met je SEAT ID account',
                  buttonText: 'Inloggen met SEAT ID',
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: () => _loginWithVWGroup('seat'),
                  onLogout: _logout,
                ),
              ] else if (_brand == 'cupra') ...[
                // CUPRA OAuth login
                _OAuthLoginCard(
                  brandName: 'CUPRA',
                  brandColor: const Color(0xFF95572B), // CUPRA copper
                  icon: Icons.speed,
                  description: 'Log in met je CUPRA ID account',
                  buttonText: 'Inloggen met CUPRA ID',
                  isLoading: _isTestingApi,
                  isConnected: _apiTestResult == 'success',
                  onLogin: () => _loginWithVWGroup('cupra'),
                  onLogout: _logout,
                ),
              ] else ...[
                // Generic login for other brands (BMW, Mercedes, etc.)
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: l10n.usernameEmail,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _countryController,
                  decoration: InputDecoration(
                    labelText: l10n.country,
                    hintText: l10n.countryHint,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isTestingApi ? null : _testApi,
                        icon: _isTestingApi
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                _apiTestResult == 'success'
                                    ? Icons.check_circle
                                    : _apiTestResult == 'error'
                                        ? Icons.error
                                        : Icons.verified,
                              ),
                        label: Text(l10n.testApi),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _apiTestResult == 'success'
                              ? Colors.green
                              : _apiTestResult == 'error'
                                  ? Colors.red
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _saveCredentials,
                        icon: const Icon(Icons.save),
                        label: Text(l10n.save),
                      ),
                    ),
                  ],
                ),
              ],
            ],

            // Only show save button section when NOT connected via OAuth
            // (OAuth saves automatically, this button is only for car details)
            if (!isEditing || !_isOAuthBrand(_brand) || _apiTestResult != 'success') ...[
              const SizedBox(height: 32),

              // Save button for car details
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : Text(isEditing ? l10n.save : l10n.add),
              ),
            ] else ...[
              // When OAuth connected, show minimal hint that changes auto-save
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Wijzigingen in naam/kleur/icoon? Druk terug en wijzig.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getBrandAppName(String brand, AppLocalizations l10n) {
    switch (brand) {
      case 'audi':
        return 'myAudi';
      case 'volkswagen':
        return 'We Connect';
      case 'skoda':
        return 'Skoda Connect';
      case 'seat':
        return 'SEAT Connect';
      case 'cupra':
        return 'CUPRA Connect';
      case 'renault':
        return 'MY Renault';
      case 'tesla':
        return 'Tesla';
      default:
        return l10n.brandOther;
    }
  }

  bool _isOAuthBrand(String brand) {
    return ['tesla', 'audi', 'volkswagen', 'skoda', 'seat', 'cupra', 'renault'].contains(brand);
  }

  IconData _getCarIcon(String icon) {
    switch (icon) {
      case 'car-suv':
        return Icons.directions_car;
      case 'car-sports':
        return Icons.sports_score;
      case 'car-van':
        return Icons.airport_shuttle;
      case 'car-hatchback':
        return Icons.directions_car_filled;
      default:
        return Icons.directions_car;
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<AppProvider>();

    try {
      if (isEditing) {
        await provider.updateCar(
          widget.car!.id,
          name: _nameController.text.trim(),
          brand: _brand,
          color: _color,
          icon: _icon,
          isDefault: _isDefault,
          carplayDeviceId: _deviceIdController.text.trim().isEmpty ? null : _deviceIdController.text.trim(),
        );
      } else {
        await provider.createCar(
          name: _nameController.text.trim(),
          brand: _brand,
          color: _color,
          icon: _icon,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? l10n.carUpdated : l10n.carAdded),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteCar() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteCar),
        content: Text(l10n.deleteCarConfirmation(widget.car!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final provider = context.read<AppProvider>();

    try {
      await provider.deleteCar(widget.car!.id);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.carDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'.replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testApi() async {
    final l10n = AppLocalizations.of(context);
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterUsernamePassword),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isTestingApi = true;
      _apiTestResult = null;
    });

    final provider = context.read<AppProvider>();

    try {
      final result = await provider.testCarCredentials(
        widget.car!.id,
        CarCredentials(
          brand: _brand,
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          country: _countryController.text.trim(),
        ),
      );

      setState(() => _apiTestResult = 'success');

      if (mounted) {
        final odometer = result['odometer_km'];
        final battery = result['battery_level'];
        String message = 'API OK!';
        if (odometer != null) {
          message += ' ${(odometer as num).toStringAsFixed(0)} ${l10n.km}';
        }
        if (battery != null) {
          message += ' $battery%';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      setState(() => _apiTestResult = 'error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$e'.replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
    }
  }

  Future<void> _saveCredentials() async {
    final l10n = AppLocalizations.of(context);
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterUsernamePassword),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final provider = context.read<AppProvider>();

    try {
      await provider.saveCarCredentials(
        widget.car!.id,
        CarCredentials(
          brand: _brand,
          username: _usernameController.text.trim(),
          password: _passwordController.text,
          country: _countryController.text.trim(),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.apiSettingsSaved),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorMessage(e.toString())), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loginWithTesla() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isTestingApi = true);

    final provider = context.read<AppProvider>();

    try {
      // Get Tesla auth URL from API
      final authUrl = await provider.getTeslaAuthUrl(widget.car!.id);

      if (authUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.teslaAlreadyLinked),
              backgroundColor: Colors.green,
            ),
          );
        }
        return;
      }

      // Open Tesla login in WebView and capture callback
      if (mounted) {
        final callbackUrl = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => TeslaLoginScreen(authUrl: authUrl),
          ),
        );

        if (callbackUrl != null && callbackUrl.isNotEmpty) {
          // Complete the OAuth flow
          final success = await provider.completeTeslaAuth(
            widget.car!.id,
            callbackUrl,
          );

          if (mounted) {
            if (success) {
              // Set success state to show green connected card
              setState(() => _apiTestResult = 'success');
              // Refresh car data so dashboard shows updated info
              provider.refreshCarData();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? l10n.teslaLinked
                    : l10n.teslaLinkFailed),
                backgroundColor: success ? Colors.green : Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
    }
  }

  Future<void> _loginWithAudi() async {
    setState(() => _isTestingApi = true);

    final provider = context.read<AppProvider>();

    try {
      // Get Audi auth URL from API
      final authUrl = await provider.getAudiAuthUrl(widget.car!.id);

      if (authUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kon Audi login URL niet ophalen'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Open Audi login in WebView and capture callback
      if (mounted) {
        final redirectUrl = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => AudiLoginScreen(authUrl: authUrl),
          ),
        );

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          // Complete the OAuth flow
          final result = await provider.completeAudiAuth(
            widget.car!.id,
            redirectUrl,
          );

          if (mounted) {
            final success = result['status'] == 'success';
            final vin = result['vin'] as String?;

            if (success) {
              // Set success state to show green connected card
              setState(() => _apiTestResult = 'success');
              // Refresh car data so dashboard shows updated info
              provider.refreshCarData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Audi gekoppeld${vin != null ? ' (VIN: $vin)' : ''}'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Audi koppelen mislukt'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
    }
  }

  Future<void> _loginWithVWGroup(String brand) async {
    setState(() => _isTestingApi = true);

    final provider = context.read<AppProvider>();

    // Brand display names for UI
    final brandNames = {
      'volkswagen': 'Volkswagen',
      'skoda': 'Skoda',
      'seat': 'SEAT',
      'cupra': 'CUPRA',
    };
    final displayName = brandNames[brand] ?? brand;

    try {
      // Get VW Group auth URL from API
      final authData = await provider.getVWGroupAuthUrl(widget.car!.id, brand);
      final authUrl = authData['auth_url'] as String?;
      final redirectUri = authData['redirect_uri'] as String?;

      if (authUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Kon $displayName login URL niet ophalen'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Open VW Group login in WebView and capture callback
      if (mounted) {
        final redirectUrl = await Navigator.push<String>(
          context,
          MaterialPageRoute(
            builder: (context) => VWGroupLoginScreen(
              authUrl: authUrl,
              redirectUri: redirectUri ?? '',
              brandName: displayName,
              brandColor: _getBrandColor(brand),
            ),
          ),
        );

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          // Complete the OAuth flow
          final result = await provider.completeVWGroupAuth(
            widget.car!.id,
            brand,
            redirectUrl,
          );

          if (mounted) {
            final success = result['status'] == 'success';

            if (success) {
              // Set success state to show green connected card
              setState(() => _apiTestResult = 'success');
              // Refresh car data so dashboard shows updated info
              provider.refreshCarData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$displayName gekoppeld'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$displayName koppelen mislukt'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
    }
  }

  Future<void> _loginWithRenault() async {
    // Validate inputs
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul je e-mail en wachtwoord in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isTestingApi = true);

    final provider = context.read<AppProvider>();

    try {
      // Direct login via Gigya API
      final result = await provider.renaultDirectLogin(
        widget.car!.id,
        _usernameController.text.trim(),
        _passwordController.text,
        locale: _countryController.text.isEmpty ? 'nl_NL' : _countryController.text,
      );

      if (mounted) {
        final success = result['status'] == 'success';

        if (success) {
          setState(() => _apiTestResult = 'success');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('MY Renault gekoppeld'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Renault koppelen mislukt'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
    }
  }

  Color _getBrandColor(String brand) {
    switch (brand) {
      case 'volkswagen':
        return const Color(0xFF001E50);
      case 'skoda':
        return const Color(0xFF4BA82E);
      case 'seat':
        return const Color(0xFFE5007D);
      case 'cupra':
        return const Color(0xFF95572B);
      default:
        return Colors.blue;
    }
  }
}

class TeslaLoginScreen extends StatefulWidget {
  final String authUrl;

  const TeslaLoginScreen({super.key, required this.authUrl});

  @override
  State<TeslaLoginScreen> createState() => _TeslaLoginScreenState();
}

class _TeslaLoginScreenState extends State<TeslaLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  void _popWithResult(String? url) {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.of(context).pop(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // Check if this is the callback URL
            if (url.contains('auth.tesla.com/void/callback')) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Callback URL will show as error - that's fine
            if (error.url?.contains('void/callback') == true) {
              _popWithResult(error.url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesla Login'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class AudiLoginScreen extends StatefulWidget {
  final String authUrl;

  const AudiLoginScreen({super.key, required this.authUrl});

  @override
  State<AudiLoginScreen> createState() => _AudiLoginScreenState();
}

class _AudiLoginScreenState extends State<AudiLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false; // Prevent multiple pops

  void _popWithResult(String? url) {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.of(context).pop(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Intercept myaudi:// redirects
            if (request.url.startsWith('myaudi://')) {
              _popWithResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Also check on page start (some redirects don't trigger onNavigationRequest)
            if (url.startsWith('myaudi://')) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // myaudi:// scheme will cause an error - capture the URL
            if (error.url?.startsWith('myaudi://') == true) {
              _popWithResult(error.url);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audi Login'),
        backgroundColor: const Color(0xFFBB0A30),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

/// Renault branded login form (username/password via Gigya)
class _RenaultLoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController countryController;
  final bool isLoading;
  final bool isConnected;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;

  const _RenaultLoginForm({
    required this.usernameController,
    required this.passwordController,
    required this.countryController,
    required this.isLoading,
    required this.isConnected,
    required this.onLogin,
    this.onLogout,
  });

  static const _renaultYellow = Color(0xFFFFCC33);

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      // Show connected status
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 16),
            const Text(
              'MY Renault verbonden',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Je account is succesvol gekoppeld',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            if (onLogout != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Uitloggen'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ],
        ),
      );
    }

    // Show branded login form
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _renaultYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _renaultYellow.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: _renaultYellow,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.diamond_outlined, color: Colors.black, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            'MY Renault',
            style: TextStyle(
              color: Color(0xFFFFCC33),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Log in met je MY Renault account',
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Form fields
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.email),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Wachtwoord',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: countryController.text.isEmpty ? 'nl_NL' : countryController.text,
            decoration: InputDecoration(
              labelText: 'Land',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.flag),
              filled: true,
              fillColor: Colors.grey[900],
            ),
            items: const [
              DropdownMenuItem(value: 'nl_NL', child: Text('Nederland')),
              DropdownMenuItem(value: 'be_BE', child: Text('België')),
              DropdownMenuItem(value: 'de_DE', child: Text('Deutschland')),
              DropdownMenuItem(value: 'fr_FR', child: Text('France')),
              DropdownMenuItem(value: 'en_GB', child: Text('United Kingdom')),
              DropdownMenuItem(value: 'es_ES', child: Text('España')),
              DropdownMenuItem(value: 'it_IT', child: Text('Italia')),
              DropdownMenuItem(value: 'pt_PT', child: Text('Portugal')),
            ],
            onChanged: (value) {
              countryController.text = value ?? 'nl_NL';
            },
          ),
          const SizedBox(height: 20),

          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onLogin,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Icon(Icons.login),
              label: const Text('Inloggen met Renault ID'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: _renaultYellow,
                foregroundColor: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// OAuth login card for Tesla/Audi/VW Group - shows connected status or login button
class _OAuthLoginCard extends StatelessWidget {
  final String brandName;
  final Color brandColor;
  final Color textColor;
  final IconData icon;
  final String description;
  final String buttonText;
  final bool isLoading;
  final bool isConnected;
  final VoidCallback onLogin;
  final VoidCallback? onLogout;

  const _OAuthLoginCard({
    required this.brandName,
    required this.brandColor,
    this.textColor = Colors.white,
    required this.icon,
    required this.description,
    required this.buttonText,
    required this.isLoading,
    required this.isConnected,
    required this.onLogin,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnected) {
      // Show connected status with logout option
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 56),
            const SizedBox(height: 16),
            Text(
              '$brandName verbonden',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Je account is succesvol gekoppeld',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            if (onLogout != null) ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Uitloggen'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Show login card
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: brandColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: brandColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: brandColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            '$brandName koppelen',
            style: TextStyle(
              color: brandColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onLogin,
              icon: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor,
                      ),
                    )
                  : const Icon(Icons.login),
              label: Text(buttonText),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: brandColor,
                foregroundColor: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// VW Group OAuth login screen (Volkswagen, Skoda, SEAT, CUPRA)
class VWGroupLoginScreen extends StatefulWidget {
  final String authUrl;
  final String redirectUri;
  final String brandName;
  final Color brandColor;

  const VWGroupLoginScreen({
    super.key,
    required this.authUrl,
    required this.redirectUri,
    required this.brandName,
    required this.brandColor,
  });

  @override
  State<VWGroupLoginScreen> createState() => _VWGroupLoginScreenState();
}

class _VWGroupLoginScreenState extends State<VWGroupLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  // Redirect URI schemes for each brand
  static const _redirectSchemes = [
    'weconnect://',
    'myskoda://',
    'cupraconnect://',
    'seatconnect://',
  ];

  void _popWithResult(String? url) {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.of(context).pop(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Intercept redirect URIs
            for (final scheme in _redirectSchemes) {
              if (request.url.startsWith(scheme)) {
                _popWithResult(request.url);
                return NavigationDecision.prevent;
              }
            }
            // Also check for specific redirect URI
            if (widget.redirectUri.isNotEmpty &&
                request.url.startsWith(widget.redirectUri)) {
              _popWithResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Also check on page start
            for (final scheme in _redirectSchemes) {
              if (url.startsWith(scheme)) {
                _popWithResult(url);
                return;
              }
            }
            if (widget.redirectUri.isNotEmpty &&
                url.startsWith(widget.redirectUri)) {
              _popWithResult(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Custom schemes will cause errors - capture the URL
            final errorUrl = error.url;
            if (errorUrl != null) {
              for (final scheme in _redirectSchemes) {
                if (errorUrl.startsWith(scheme)) {
                  _popWithResult(errorUrl);
                  return;
                }
              }
              if (widget.redirectUri.isNotEmpty &&
                  errorUrl.startsWith(widget.redirectUri)) {
                _popWithResult(errorUrl);
              }
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.brandName} Login'),
        backgroundColor: widget.brandColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

/// Renault OAuth login screen (Gigya-based)
class RenaultLoginScreen extends StatefulWidget {
  final String authUrl;
  final String gigyaApiKey;

  const RenaultLoginScreen({
    super.key,
    required this.authUrl,
    required this.gigyaApiKey,
  });

  @override
  State<RenaultLoginScreen> createState() => _RenaultLoginScreenState();
}

class _RenaultLoginScreenState extends State<RenaultLoginScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasPopped = false;

  void _popWithResult(String? url) {
    if (!_hasPopped && mounted) {
      _hasPopped = true;
      Navigator.of(context).pop(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // Intercept Renault app redirects
            if (request.url.startsWith('renault://') ||
                request.url.startsWith('myrenault://') ||
                request.url.contains('accounts.renault.com/callback')) {
              // Extract token from URL if present
              final uri = Uri.parse(request.url);
              final token = uri.queryParameters['id_token'] ??
                  uri.queryParameters['access_token'] ??
                  uri.fragment;
              if (token.isNotEmpty) {
                _popWithResult(token);
              } else {
                _popWithResult(request.url);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            // Check for redirects
            if (url.startsWith('renault://') ||
                url.startsWith('myrenault://')) {
              final uri = Uri.parse(url);
              final token = uri.queryParameters['id_token'] ??
                  uri.queryParameters['access_token'];
              _popWithResult(token ?? url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Custom schemes will cause errors
            final errorUrl = error.url;
            if (errorUrl != null &&
                (errorUrl.startsWith('renault://') ||
                    errorUrl.startsWith('myrenault://'))) {
              _popWithResult(errorUrl);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY Renault Login'),
        backgroundColor: const Color(0xFFFFCC33),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
