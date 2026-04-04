import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery/screens/delivery_partener/provider/delivery_profile_provider.dart';
import 'package:food_delivery/screens/delivery_partener/widget/bank_account_card.dart';
import 'package:provider/provider.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _accountHolderController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscController;
  late TextEditingController _bankNameController;
  late TextEditingController _upiIdController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final bank =
        Provider.of<DeliveryProfileProvider>(
          context,
          listen: false,
        ).bankAccount;
    _accountHolderController = TextEditingController(
      text: bank.accountHolderName,
    );
    _accountNumberController = TextEditingController(text: bank.accountNumber);
    _ifscController = TextEditingController(text: bank.ifscCode);
    _bankNameController = TextEditingController(text: bank.bankName);
    _upiIdController = TextEditingController(text: bank.upiId);
  }

  @override
  void dispose() {
    _accountHolderController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _bankNameController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<DeliveryProfileProvider>(
        context,
        listen: false,
      );
      provider.updateBankDetails(
        accountHolderName: _accountHolderController.text,
        accountNumber: _accountNumberController.text,
        ifscCode: _ifscController.text,
        bankName: _bankNameController.text,
        upiId: _upiIdController.text,
      );
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bank details updated')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bank = Provider.of<DeliveryProfileProvider>(context).bankAccount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Details'),
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
              BankAccountCard(bank: bank),
              SizedBox(height: 24.h),

              if (_isEditing) ...[
                _buildTextField(
                  controller: _accountHolderController,
                  label: 'Account Holder Name',
                  hint: 'As per bank account',
                  icon: Icons.person,
                  enabled: _isEditing,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _accountNumberController,
                  label: 'Account Number',
                  hint: 'Enter account number',
                  icon: Icons.credit_card,
                  enabled: _isEditing,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _ifscController,
                  label: 'IFSC Code',
                  hint: 'e.g., SBIN0001234',
                  icon: Icons.code,
                  enabled: _isEditing,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _bankNameController,
                  label: 'Bank Name',
                  hint: 'Name of the bank',
                  icon: Icons.account_balance,
                  enabled: _isEditing,
                ),
                SizedBox(height: 16.h),
                _buildTextField(
                  controller: _upiIdController,
                  label: 'UPI ID (Optional)',
                  hint: 'username@bank',
                  icon: Icons.qr_code,
                  enabled: _isEditing,
                ),
              ],
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
        if (label == 'IFSC Code' && value.length != 11) {
          return 'Enter valid IFSC code';
        }
        return null;
      },
    );
  }
}
