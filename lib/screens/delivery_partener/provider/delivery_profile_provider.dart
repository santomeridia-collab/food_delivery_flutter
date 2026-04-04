import 'dart:io';
import 'package:flutter/material.dart';
import '../model/delivery_earnings_model.dart';

class DeliveryProfileProvider extends ChangeNotifier {
  // Add DeliveryPartner property
  DeliveryPartner _deliveryPartner = DeliveryPartner(
    name: 'Raj Kumar',
    email: 'raj.kumar@example.com',
    phone: '+91 98765 43210',
    avatar: '',
    rating: 4.8,
    completedDeliveries: 156,
    joinDate: 'Jan 2024',
  );

  DeliveryEarnings _earnings = DeliveryEarnings(
    todayEarnings: 45.50,
    thisWeekEarnings: 320.75,
    thisMonthEarnings: 1250.00,
    totalEarnings: 4560.00,
    totalDeliveries: 156,
    averagePerDelivery: 29.23,
    activeHours: 45,
    rating: 4.8,
  );

  List<Incentive> _incentives = [
    Incentive(
      id: '1',
      title: 'Weekend Bonus',
      description: 'Complete 20 deliveries on weekends',
      amount: 50.00,
      isCompleted: false,
      progress: 12,
      target: 20,
      type: 'bonus',
    ),
    Incentive(
      id: '2',
      title: 'Peak Hour Incentive',
      description: 'Deliver during peak hours (6-9 PM)',
      amount: 30.00,
      isCompleted: true,
      progress: 15,
      target: 15,
      type: 'peak',
    ),
    Incentive(
      id: '3',
      title: 'Referral Bonus',
      description: 'Refer a friend to join as delivery partner',
      amount: 100.00,
      isCompleted: false,
      progress: 1,
      target: 3,
      type: 'referral',
    ),
  ];

  VehicleDetails _vehicleDetails = VehicleDetails(
    vehicleType: 'Bike',
    vehicleNumber: 'MH-12-AB-1234',
    vehicleModel: 'Honda Activa 6G',
    vehicleColor: 'Black',
    insuranceExpiry: '31/12/2024',
    permitNumber: 'PERM-12345',
    rcNumber: 'MH-12-AB-1234',
  );

  BankAccount _bankAccount = BankAccount(
    accountHolderName: 'John Doe',
    accountNumber: '123456789012',
    ifscCode: 'SBIN0012345',
    bankName: 'State Bank of India',
    upiId: 'john@okhdfcbank',
    isVerified: true,
  );

  List<Document> _documents = [
    Document(
      id: '1',
      name: 'Driving License',
      isUploaded: true,
      isVerified: true,
      expiryDate: '31/12/2025',
    ),
    Document(
      id: '2',
      name: 'Vehicle Registration',
      isUploaded: true,
      isVerified: false,
    ),
    Document(
      id: '3',
      name: 'Insurance Certificate',
      isUploaded: false,
      isVerified: false,
    ),
    Document(id: '4', name: 'Aadhar Card', isUploaded: true, isVerified: true),
    Document(id: '5', name: 'PAN Card', isUploaded: false, isVerified: false),
  ];

  // Getters
  DeliveryPartner get deliveryPartner => _deliveryPartner;
  DeliveryEarnings get earnings => _earnings;
  List<Incentive> get incentives => _incentives;
  VehicleDetails get vehicleDetails => _vehicleDetails;
  BankAccount get bankAccount => _bankAccount;
  List<Document> get documents => _documents;

  void updateVehicleDetails({
    required String vehicleType,
    required String vehicleNumber,
    required String vehicleModel,
    required String vehicleColor,
    String? insuranceExpiry,
    String? permitNumber,
    String? rcNumber,
  }) {
    _vehicleDetails = VehicleDetails(
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleModel: vehicleModel,
      vehicleColor: vehicleColor,
      insuranceExpiry: insuranceExpiry,
      permitNumber: permitNumber,
      rcNumber: rcNumber,
    );
    notifyListeners();
  }

  void updateBankDetails({
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String bankName,
    required String upiId,
  }) {
    _bankAccount = BankAccount(
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      bankName: bankName,
      upiId: upiId,
      isVerified: false,
    );
    notifyListeners();
  }

  void uploadDocument(String documentId, File file) {
    final index = _documents.indexWhere((d) => d.id == documentId);
    if (index != -1) {
      _documents[index] = Document(
        id: _documents[index].id,
        name: _documents[index].name,
        fileUrl: file.path,
        isUploaded: true,
        isVerified: false,
        expiryDate: _documents[index].expiryDate,
      );
      notifyListeners();
    }
  }

  void updateDeliveryPartner({
    String? name,
    String? email,
    String? phone,
    String? avatar,
  }) {
    _deliveryPartner = DeliveryPartner(
      name: name ?? _deliveryPartner.name,
      email: email ?? _deliveryPartner.email,
      phone: phone ?? _deliveryPartner.phone,
      avatar: avatar ?? _deliveryPartner.avatar,
      rating: _deliveryPartner.rating,
      completedDeliveries: _deliveryPartner.completedDeliveries,
      joinDate: _deliveryPartner.joinDate,
    );
    notifyListeners();
  }
}
