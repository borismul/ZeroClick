// Trip edit/add screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip.dart';
import '../providers/app_provider.dart';

class TripEditScreen extends StatefulWidget {
  final Trip? trip; // null = create new trip

  const TripEditScreen({super.key, this.trip});

  @override
  State<TripEditScreen> createState() => _TripEditScreenState();
}

class _TripEditScreenState extends State<TripEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _fromAddressController;
  late TextEditingController _toAddressController;
  late TextEditingController _distanceController;
  late String _tripType;
  late TextEditingController _businessKmController;
  late TextEditingController _privateKmController;
  String? _carId;

  bool get isEditing => widget.trip != null;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    final now = DateTime.now();

    if (trip != null) {
      // Parse date (format: dd-MM-yyyy)
      final parts = trip.date.split('-');
      _date = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      _startTime = _parseTime(trip.startTime);
      _endTime = _parseTime(trip.endTime);
      _fromAddressController = TextEditingController(text: trip.fromAddress);
      _toAddressController = TextEditingController(text: trip.toAddress);
      _distanceController = TextEditingController(text: trip.distanceKm.toString());
      _tripType = trip.tripType;
      _businessKmController = TextEditingController(text: trip.businessKm.toString());
      _privateKmController = TextEditingController(text: trip.privateKm.toString());
      _carId = trip.carId;
    } else {
      _date = now;
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
      _fromAddressController = TextEditingController();
      _toAddressController = TextEditingController();
      _distanceController = TextEditingController(text: '0');
      _tripType = 'B';
      _businessKmController = TextEditingController(text: '0');
      _privateKmController = TextEditingController(text: '0');

      // Use selected car as default
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<AppProvider>();
        setState(() {
          _carId = provider.selectedCarId ?? provider.defaultCar?.id;
        });
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _updateKmSplit() {
    final distance = double.tryParse(_distanceController.text) ?? 0;
    if (_tripType == 'B') {
      _businessKmController.text = distance.toString();
      _privateKmController.text = '0';
    } else if (_tripType == 'P') {
      _businessKmController.text = '0';
      _privateKmController.text = distance.toString();
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final distance = double.tryParse(_distanceController.text) ?? 0;
    final businessKm = double.tryParse(_businessKmController.text) ?? 0;
    final privateKm = double.tryParse(_privateKmController.text) ?? 0;

    final tripData = {
      'date': _formatDate(_date),
      'start_time': _formatTime(_startTime),
      'end_time': _formatTime(_endTime),
      'from_address': _fromAddressController.text,
      'to_address': _toAddressController.text,
      'distance_km': distance,
      'trip_type': _tripType,
      'business_km': businessKm,
      'private_km': privateKm,
      if (_carId != null) 'car_id': _carId,
    };

    bool success;
    if (isEditing) {
      success = await provider.updateTrip(widget.trip!.id, tripData);
    } else {
      success = await provider.createTrip(tripData);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Er ging iets mis')),
      );
    }
  }

  Future<void> _delete() async {
    if (!isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rit verwijderen?'),
        content: const Text('Weet je zeker dat je deze rit wilt verwijderen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuleren'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Verwijderen'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final success = await provider.deleteTrip(widget.trip!.id);

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
      Navigator.pop(context); // Also pop the detail screen
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Kon niet verwijderen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Rit bewerken' : 'Rit toevoegen'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _isLoading ? null : _delete,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Date & Time
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Datum & Tijd', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Datum'),
                                  subtitle: Text(_formatDate(_date)),
                                  trailing: const Icon(Icons.calendar_today),
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _date,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime.now().add(const Duration(days: 1)),
                                    );
                                    if (date != null) setState(() => _date = date);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Start'),
                                  subtitle: Text(_formatTime(_startTime)),
                                  trailing: const Icon(Icons.access_time),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _startTime,
                                    );
                                    if (time != null) setState(() => _startTime = time);
                                  },
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Eind'),
                                  subtitle: Text(_formatTime(_endTime)),
                                  trailing: const Icon(Icons.access_time),
                                  onTap: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: _endTime,
                                    );
                                    if (time != null) setState(() => _endTime = time);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Route
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Route', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _fromAddressController,
                            decoration: const InputDecoration(
                              labelText: 'Van',
                              prefixIcon: Icon(Icons.trip_origin, color: Colors.green),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v?.isEmpty == true ? 'Verplicht' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _toAddressController,
                            decoration: const InputDecoration(
                              labelText: 'Naar',
                              prefixIcon: Icon(Icons.location_on, color: Colors.red),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v?.isEmpty == true ? 'Verplicht' : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Distance & Type
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Afstand & Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _distanceController,
                            decoration: const InputDecoration(
                              labelText: 'Afstand (km)',
                              prefixIcon: Icon(Icons.straighten),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => _updateKmSplit(),
                            validator: (v) {
                              final val = double.tryParse(v ?? '');
                              if (val == null || val < 0) return 'Ongeldige afstand';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text('Type', style: TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'B', label: Text('Zakelijk')),
                              ButtonSegment(value: 'P', label: Text('Privé')),
                              ButtonSegment(value: 'M', label: Text('Gemengd')),
                            ],
                            selected: {_tripType},
                            onSelectionChanged: (selection) {
                              setState(() {
                                _tripType = selection.first;
                                _updateKmSplit();
                              });
                            },
                          ),
                          if (_tripType == 'M') ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _businessKmController,
                                    decoration: const InputDecoration(
                                      labelText: 'Zakelijk km',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _privateKmController,
                                    decoration: const InputDecoration(
                                      labelText: 'Privé km',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Car selection
                  if (provider.cars.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Auto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _carId,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.directions_car),
                              ),
                              items: provider.cars.map((car) {
                                return DropdownMenuItem(
                                  value: car.id,
                                  child: Text(car.name),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _carId = value),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Save button
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _save,
                    icon: const Icon(Icons.save),
                    label: Text(isEditing ? 'Opslaan' : 'Toevoegen'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _fromAddressController.dispose();
    _toAddressController.dispose();
    _distanceController.dispose();
    _businessKmController.dispose();
    _privateKmController.dispose();
    super.dispose();
  }
}
