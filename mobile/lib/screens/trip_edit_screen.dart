// Trip edit/add screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
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
        SnackBar(content: Text(provider.error ?? l10n.somethingWentWrong)),
      );
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    if (!isEditing) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTrip),
        content: Text(l10n.deleteTripConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
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
        SnackBar(content: Text(provider.error ?? l10n.couldNotDelete)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? l10n.editTrip : l10n.addTrip),
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
                          Text(l10n.dateAndTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(l10n.date),
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
                                  title: Text(l10n.start),
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
                                  title: Text(l10n.end),
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
                          Text(l10n.route, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _fromAddressController,
                            decoration: InputDecoration(
                              labelText: l10n.from,
                              hintText: l10n.fromPlaceholder,
                              prefixIcon: const Icon(Icons.trip_origin, color: Colors.green),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) => v?.isEmpty == true ? l10n.required : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _toAddressController,
                            decoration: InputDecoration(
                              labelText: l10n.to,
                              hintText: l10n.toPlaceholder,
                              prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                              border: const OutlineInputBorder(),
                            ),
                            validator: (v) => v?.isEmpty == true ? l10n.required : null,
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
                          Text(l10n.distanceAndType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _distanceController,
                            decoration: InputDecoration(
                              labelText: l10n.distanceKm,
                              prefixIcon: const Icon(Icons.straighten),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => _updateKmSplit(),
                            validator: (v) {
                              final val = double.tryParse(v ?? '');
                              if (val == null || val < 0) return l10n.invalidDistance;
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(l10n.type, style: const TextStyle(fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: [
                              ButtonSegment(value: 'B', label: Text(l10n.tripTypeBusiness)),
                              ButtonSegment(value: 'P', label: Text(l10n.tripTypePrivate)),
                              ButtonSegment(value: 'M', label: Text(l10n.tripTypeMixed)),
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
                                    decoration: InputDecoration(
                                      labelText: l10n.businessKm,
                                      border: const OutlineInputBorder(),
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _privateKmController,
                                    decoration: InputDecoration(
                                      labelText: l10n.privateKm,
                                      border: const OutlineInputBorder(),
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
                            Text(l10n.car, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              initialValue: _carId,
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
                    label: Text(isEditing ? l10n.save : l10n.add),
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
