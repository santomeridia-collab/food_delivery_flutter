import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/models/address_model.dart';
import 'package:food_delivery/screens/customer/providers/address_provider.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'map_picker_screen.dart';

class AddAddressScreen extends StatefulWidget {
  final Address? address;
  const AddAddressScreen({super.key, this.address});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _selectedLabel = 'Home';
  bool _setAsDefault = false;
  Position? _selectedPosition;
  String _selectedAddress = '';

  final List<String> _labels = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!.street;
      _areaController.text = widget.address!.area;
      _cityController.text = widget.address!.city;
      _pincodeController.text = widget.address!.pincode;
      _selectedLabel = widget.address!.label;
      _setAsDefault = widget.address!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Label
              const Text(
                'Address Label',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                children:
                    _labels.map((label) {
                      final isSelected = _selectedLabel == label;
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedLabel = label;
                          });
                        },
                        selectedColor: AppTheme.primaryColor,
                        backgroundColor: Colors.grey.shade100,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 24),

              // Street Address
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  hintText: 'House number, building name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Area/Locality
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Area/Locality',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter area';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // City
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pincode
              TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Pincode',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pincode';
                  }
                  if (value.length != 6) {
                    return 'Enter valid 6-digit pincode';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Map Picker Button
              OutlinedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MapPickerScreen()),
                  );
                  if (result != null) {
                    setState(() {
                      _selectedPosition = result['position'];
                      _selectedAddress = result['address'];
                    });
                  }
                },
                icon: const Icon(Icons.map),
                label: const Text('Pick Location on Map'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              if (_selectedAddress.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedAddress,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Set as Default
              Row(
                children: [
                  Checkbox(
                    value: _setAsDefault,
                    onChanged: (value) {
                      setState(() {
                        _setAsDefault = value!;
                      });
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const Text('Set as default address'),
                ],
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  child: const Text('Save Address'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = Address(
        id: widget.address?.id ?? DateTime.now().toString(),
        label: _selectedLabel,
        street: _streetController.text,
        area: _areaController.text,
        city: _cityController.text,
        pincode: _pincodeController.text,
        latitude: _selectedPosition?.latitude ?? 0,
        longitude: _selectedPosition?.longitude ?? 0,
        isDefault: _setAsDefault,
      );

      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );

      if (widget.address == null) {
        addressProvider.addAddress(address);
      } else {
        addressProvider.updateAddress(address);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address saved successfully')),
      );
      Navigator.pop(context);
    }
  }
}
