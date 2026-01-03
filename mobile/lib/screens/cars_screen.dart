// Car management screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../providers/app_provider.dart';
import '../models/car.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Auto's"),
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
                    "Nog geen auto's toegevoegd",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCarDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Auto toevoegen'),
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
                  color: _parseColor(car.color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCarIcon(car.icon),
                  color: _parseColor(car.color),
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
                            child: const Text(
                              'Standaard',
                              style: TextStyle(color: Colors.blue, fontSize: 11),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      car.brandLabel,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.route,
                          value: '${car.totalTrips} ritten',
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.straighten,
                          value: '${car.totalKm.toStringAsFixed(0)} km',
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

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
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

  static const List<Map<String, dynamic>> _icons = [
    {'value': 'car', 'icon': Icons.directions_car, 'label': 'Sedan'},
    {'value': 'car-suv', 'icon': Icons.directions_car, 'label': 'SUV'},
    {'value': 'car-hatchback', 'icon': Icons.directions_car_filled, 'label': 'Hatchback'},
    {'value': 'car-sports', 'icon': Icons.sports_score, 'label': 'Sport'},
    {'value': 'car-van', 'icon': Icons.airport_shuttle, 'label': 'Bus'},
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
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Auto bewerken' : 'Auto toevoegen'),
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
                  color: _parseColor(_color).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getCarIcon(_icon),
                  color: _parseColor(_color),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Naam',
                hintText: 'Bijv. Audi Q4 e-tron',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vul een naam in';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Brand
            DropdownButtonFormField<String>(
              value: _brand,
              decoration: const InputDecoration(
                labelText: 'Merk',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.branding_watermark),
              ),
              items: const [
                DropdownMenuItem(value: 'audi', child: Text('Audi')),
                DropdownMenuItem(value: 'volkswagen', child: Text('Volkswagen')),
                DropdownMenuItem(value: 'skoda', child: Text('Skoda')),
                DropdownMenuItem(value: 'seat', child: Text('Seat')),
                DropdownMenuItem(value: 'cupra', child: Text('Cupra')),
                DropdownMenuItem(value: 'renault', child: Text('Renault')),
                DropdownMenuItem(value: 'tesla', child: Text('Tesla')),
                DropdownMenuItem(value: 'bmw', child: Text('BMW')),
                DropdownMenuItem(value: 'mercedes', child: Text('Mercedes')),
                DropdownMenuItem(value: 'other', child: Text('Overig')),
              ],
              onChanged: (value) {
                setState(() => _brand = value ?? 'other');
              },
            ),
            const SizedBox(height: 24),

            // Color picker
            const Text('Kleur', style: TextStyle(fontWeight: FontWeight.bold)),
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
                      color: _parseColor(color),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [BoxShadow(color: _parseColor(color), blurRadius: 8)]
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
            const Text('Icoon', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: _icons.map((item) {
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
                              ? _parseColor(_color).withValues(alpha: 0.2)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: _parseColor(_color), width: 2)
                              : null,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isSelected ? _parseColor(_color) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? _parseColor(_color) : Colors.grey,
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
              title: const Text('Standaard auto'),
              subtitle: const Text('Nieuwe ritten worden aan deze auto gekoppeld'),
              value: _isDefault,
              onChanged: (value) => setState(() => _isDefault = value),
            ),

            const SizedBox(height: 24),

            // Bluetooth Device ID
            TextFormField(
              controller: _deviceIdController,
              decoration: InputDecoration(
                labelText: 'Bluetooth apparaat',
                hintText: 'Wordt automatisch ingesteld',
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
                  const SnackBar(
                    content: Text('Wordt automatisch ingesteld bij verbinding met CarPlay/Bluetooth'),
                  ),
                );
              },
            ),
            if (_deviceIdController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Ritten worden automatisch aan deze auto gekoppeld wanneer "${_deviceIdController.text}" verbonden is',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),

            const SizedBox(height: 24),

            // API Credentials (only for editing)
            if (isEditing) ...[
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Auto API Koppeling',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Koppel met ${_getBrandAppName(_brand)} voor kilometerstand en batterijstatus',
                style: TextStyle(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 16),

              // Tesla uses OAuth, others use username/password
              if (_brand == 'tesla') ...[
                ElevatedButton.icon(
                  onPressed: _isTestingApi ? null : _loginWithTesla,
                  icon: _isTestingApi
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: const Text('Inloggen met Tesla'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: const Color(0xFFE82127), // Tesla red
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Je wordt doorgestuurd naar Tesla om in te loggen.\nDaarna kun je je auto-data bekijken.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Gebruikersnaam / E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Wachtwoord',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Land',
                    hintText: 'NL',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
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
                        label: const Text('Test API'),
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
                        label: const Text('Opslaan'),
                      ),
                    ),
                  ],
                ),
              ],
            ],

            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : Text(isEditing ? 'Opslaan' : 'Toevoegen'),
            ),
          ],
        ),
      ),
    );
  }

  String _getBrandAppName(String brand) {
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
        return 'de fabrikant app';
    }
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
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
            content: Text(isEditing ? 'Auto bijgewerkt' : 'Auto toegevoegd'),
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
    } finally {
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteCar() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Auto verwijderen?'),
        content: Text(
          'Weet je zeker dat je "${widget.car!.name}" wilt verwijderen?\n\n'
          'Ritten blijven behouden maar worden niet meer aan deze auto gekoppeld.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
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
          const SnackBar(
            content: Text('Auto verwijderd'),
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
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul gebruikersnaam en wachtwoord in'),
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
          message += ' ${(odometer as num).toStringAsFixed(0)} km';
        }
        if (battery != null) {
          message += ' ${battery}%';
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
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vul gebruikersnaam en wachtwoord in'),
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
          const SnackBar(
            content: Text('API instellingen opgeslagen'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fout: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _loginWithTesla() async {
    setState(() => _isTestingApi = true);

    final provider = context.read<AppProvider>();

    try {
      // Get Tesla auth URL from API
      final authUrl = await provider.getTeslaAuthUrl(widget.car!.id);

      if (authUrl == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tesla is al gekoppeld!'),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(success
                    ? 'Tesla gekoppeld!'
                    : 'Tesla koppeling mislukt'),
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
            content: Text('Fout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isTestingApi = false);
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
              // Got the callback! Return it and close
              Navigator.of(context).pop(url);
            }
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (WebResourceError error) {
            // Callback URL will show as error - that's fine
            if (error.url?.contains('void/callback') == true) {
              Navigator.of(context).pop(error.url);
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
