import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:provider/provider.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _vehicleTypeController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleColorController;
  late TextEditingController _insuranceExpiryController;
  late TextEditingController _permitNumberController;
  late TextEditingController _rcNumberController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final vehicle =
        Provider.of<DeliveryProfileProvider>(
          context,
          listen: false,
        ).vehicleDetails;
    _vehicleTypeController = TextEditingController(text: vehicle.vehicleType);
    _vehicleNumberController = TextEditingController(
      text: vehicle.vehicleNumber,
    );
    _vehicleModelController = TextEditingController(text: vehicle.vehicleModel);
    _vehicleColorController = TextEditingController(text: vehicle.vehicleColor);
    _insuranceExpiryController = TextEditingController(
      text: vehicle.insuranceExpiry ?? '',
    );
    _permitNumberController = TextEditingController(
      text: vehicle.permitNumber ?? '',
    );
    _rcNumberController = TextEditingController(text: vehicle.rcNumber ?? '');
  }

  @override
  void dispose() {
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _vehicleModelController.dispose();
    _vehicleColorController.dispose();
    _insuranceExpiryController.dispose();
    _permitNumberController.dispose();
    _rcNumberController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<DeliveryProfileProvider>(
        context,
        listen: false,
      );
      provider.updateVehicleDetails(
        vehicleType: _vehicleTypeController.text,
        vehicleNumber: _vehicleNumberController.text,
        vehicleModel: _vehicleModelController.text,
        vehicleColor: _vehicleColorController.text,
        insuranceExpiry: _insuranceExpiryController.text,
        permitNumber: _permitNumberController.text,
        rcNumber: _rcNumberController.text,
      );
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Vehicle details updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            TextButton(onPressed: _saveChanges, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _vehicleTypeController,
                label: 'Vehicle Type',
                hint: 'e.g., Bike, Scooter, Car',
                icon: Icons.directions_bike,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _vehicleNumberController,
                label: 'Vehicle Number',
                hint: 'e.g., ABC-1234',
                icon: Icons.confirmation_number,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _vehicleModelController,
                label: 'Vehicle Model',
                hint: 'e.g., Honda Activa, Hero Splendor',
                icon: Icons.model_training,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _vehicleColorController,
                label: 'Vehicle Color',
                hint: 'e.g., Black, Red, White',
                icon: Icons.color_lens,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _insuranceExpiryController,
                label: 'Insurance Expiry (Optional)',
                hint: 'DD/MM/YYYY',
                icon: Icons.security,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _permitNumberController,
                label: 'Permit Number (Optional)',
                hint: 'Enter permit number',
                icon: Icons.description,
                enabled: _isEditing,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                controller: _rcNumberController,
                label: 'RC Number (Optional)',
                hint: 'Registration Certificate Number',
                icon: Icons.card_membership,
                enabled: _isEditing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
