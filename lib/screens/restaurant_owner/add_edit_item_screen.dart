import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/customer/utils/app_theme.dart';
import 'package:food_delivery/screens/restaurant_owner/model/menu_item_model.dart';
import 'package:food_delivery/screens/restaurant_owner/provider/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddEditItemScreen extends StatefulWidget {
  final MenuItem? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _preparationTimeController = TextEditingController();

  String _selectedCategory = '';
  bool _isVeg = true;
  bool _isAvailable = true;
  File? _selectedImage;
  List<String> _addons = [];
  List<String> _sizes = [];

  final TextEditingController _addonController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _descriptionController.text = widget.item!.description;
      _priceController.text = widget.item!.price.toString();
      if (widget.item!.discountedPrice != null) {
        _discountedPriceController.text =
            widget.item!.discountedPrice!.toString();
      }
      _selectedCategory = widget.item!.category;
      _isVeg = widget.item!.isVeg;
      _isAvailable = widget.item!.isAvailable;
      _preparationTimeController.text = widget.item!.preparationTime.toString();
      _addons = List.from(widget.item!.addons);
      _sizes = List.from(widget.item!.sizes);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountedPriceController.dispose();
    _preparationTimeController.dispose();
    _addonController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final menuProvider = Provider.of<MenuProvider>(context, listen: false);

      final item = MenuItem(
        id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        discountedPrice:
            _discountedPriceController.text.isNotEmpty
                ? double.parse(_discountedPriceController.text)
                : null,
        category: _selectedCategory,
        imageUrl: '',
        isVeg: _isVeg,
        isAvailable: _isAvailable,
        preparationTime: int.parse(_preparationTimeController.text),
        addons: _addons,
        sizes: _sizes,
        createdAt: widget.item?.createdAt ?? DateTime.now(),
      );

      if (widget.item == null) {
        menuProvider.addMenuItem(item);
      } else {
        menuProvider.updateMenuItem(item);
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.item == null
                ? 'Item added successfully'
                : 'Item updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    final categories = menuProvider.categories.map((c) => c.name).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Menu Item' : 'Edit Menu Item'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [TextButton(onPressed: _saveItem, child: const Text('Save'))],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child:
                        _selectedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 40.sp,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Add Image',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  prefixIcon: Icon(Icons.restaurant),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Please enter item name'
                            : null,
              ),
              SizedBox(height: 16.h),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Please enter description'
                            : null,
              ),
              SizedBox(height: 16.h),

              // Price Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              value?.isEmpty == true ? 'Enter price' : null,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: TextFormField(
                      controller: _discountedPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discounted Price (Optional)',
                        prefixIcon: Icon(Icons.local_offer),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory.isEmpty ? null : _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items:
                    categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged:
                    (value) => setState(() => _selectedCategory = value!),
                validator: (value) => value == null ? 'Select category' : null,
              ),
              SizedBox(height: 16.h),

              // Preparation Time
              TextFormField(
                controller: _preparationTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preparation Time (minutes)',
                  prefixIcon: Icon(Icons.timer),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value?.isEmpty == true
                            ? 'Enter preparation time'
                            : null,
              ),
              SizedBox(height: 16.h),

              // Veg/Non-Veg
              Row(
                children: [
                  const Text('Food Type:'),
                  SizedBox(width: 16.w),
                  ChoiceChip(
                    label: const Text('Veg'),
                    selected: _isVeg,
                    onSelected: (selected) => setState(() => _isVeg = true),
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  SizedBox(width: 8.w),
                  ChoiceChip(
                    label: const Text('Non-Veg'),
                    selected: !_isVeg,
                    onSelected: (selected) => setState(() => _isVeg = false),
                    selectedColor: Colors.red,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Availability
              SwitchListTile(
                title: const Text('Available'),
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
                activeColor: AppTheme.primaryColor,
                contentPadding: EdgeInsets.zero,
              ),
              SizedBox(height: 16.h),

              // Add-ons
              const Text(
                'Add-ons',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: [
                  ..._addons.map(
                    (addon) => Chip(
                      label: Text(addon),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _addons.remove(addon)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _addonController,
                      decoration: const InputDecoration(
                        hintText: 'Add add-on (e.g., Extra Cheese)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      if (_addonController.text.isNotEmpty) {
                        setState(() {
                          _addons.add(_addonController.text);
                          _addonController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Sizes
              const Text(
                'Sizes (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                children: [
                  ..._sizes.map(
                    (size) => Chip(
                      label: Text(size),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => setState(() => _sizes.remove(size)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: const InputDecoration(
                        hintText: 'Add size (e.g., Small, Medium)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () {
                      if (_sizeController.text.isNotEmpty) {
                        setState(() {
                          _sizes.add(_sizeController.text);
                          _sizeController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _saveItem,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              widget.item == null ? 'Add Item' : 'Update Item',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
