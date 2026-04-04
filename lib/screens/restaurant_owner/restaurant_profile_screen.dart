import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/restaurant_settings_provider.dart';
import 'package:food_delivery/screens/restaurant_owner/widget/working_hours_picker.dart';
import 'package:provider/provider.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({super.key});

  @override
  State<RestaurantProfileScreen> createState() =>
      _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _cuisineController;
  late TextEditingController _minOrderController;
  late TextEditingController _deliveryFeeController;
  bool _isOpen = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final settings =
        Provider.of<RestaurantSettingsProvider>(
          context,
          listen: false,
        ).settings;
    _nameController = TextEditingController(text: settings.name);
    _emailController = TextEditingController(text: settings.email);
    _phoneController = TextEditingController(text: settings.phone);
    _addressController = TextEditingController(text: settings.address);
    _descriptionController = TextEditingController(text: settings.description);
    _cuisineController = TextEditingController(text: settings.cuisine);
    _minOrderController = TextEditingController(
      text: settings.minOrder.toString(),
    );
    _deliveryFeeController = TextEditingController(
      text: settings.deliveryFee.toString(),
    );
    _isOpen = settings.isOpen;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _cuisineController.dispose();
    _minOrderController.dispose();
    _deliveryFeeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<RestaurantSettingsProvider>(
        context,
        listen: false,
      );
      provider.updateSettings(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        description: _descriptionController.text,
        cuisine: _cuisineController.text,
        minOrder: double.parse(_minOrderController.text),
        deliveryFee: double.parse(_deliveryFeeController.text),
        isOpen: _isOpen,
      );
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<RestaurantSettingsProvider>(context).settings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Profile'),
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
        child: Column(
          children: [
            // Cover Image
            Stack(
              children: [
                Container(
                  height: 180.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: NetworkImage(settings.coverImageUrl),
                      image: AssetImage('assets/download.png'),

                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40.h,
                  left: 16.w,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: DecorationImage(
                        // image: AssetImage(settings.logoUrl),
                        image: AssetImage('assets/download.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40.h,
                  right: 16.w,
                  child: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60.h),

            // Profile Form
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Name
                    _buildTextField(
                      controller: _nameController,
                      label: 'Restaurant Name',
                      icon: Icons.restaurant,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: 16.h),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      enabled: _isEditing,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16.h),

                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone,
                      enabled: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.h),

                    // Address
                    _buildTextField(
                      controller: _addressController,
                      label: 'Address',
                      icon: Icons.location_on,
                      enabled: _isEditing,
                      maxLines: 2,
                    ),
                    SizedBox(height: 16.h),

                    // Cuisine
                    _buildTextField(
                      controller: _cuisineController,
                      label: 'Cuisine',
                      icon: Icons.restaurant_menu,
                      enabled: _isEditing,
                    ),
                    SizedBox(height: 16.h),

                    // Description
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      icon: Icons.description,
                      enabled: _isEditing,
                      maxLines: 3,
                    ),
                    SizedBox(height: 16.h),

                    // Min Order & Delivery Fee
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _minOrderController,
                            label: 'Min Order',
                            icon: Icons.attach_money,
                            enabled: _isEditing,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildTextField(
                            controller: _deliveryFeeController,
                            label: 'Delivery Fee',
                            icon: Icons.local_shipping,
                            enabled: _isEditing,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Open/Close Toggle
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _isOpen ? Icons.check_circle : Icons.cancel,
                                color: _isOpen ? Colors.green : Colors.red,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Restaurant Status',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          if (_isEditing)
                            Switch(
                              value: _isOpen,
                              onChanged:
                                  (value) => setState(() => _isOpen = value),
                              activeColor: Colors.green,
                            )
                          else
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _isOpen
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                _isOpen ? 'Open' : 'Closed',
                                style: TextStyle(
                                  color: _isOpen ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Working Hours Section
                    const Text(
                      'Working Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    WorkingHoursPicker(
                      workingHours: settings.workingHours,
                      isEditing: _isEditing,
                      onUpdate: (updatedHours) {
                        Provider.of<RestaurantSettingsProvider>(
                          context,
                          listen: false,
                        ).updateWorkingHours(updatedHours);
                      },
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
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
