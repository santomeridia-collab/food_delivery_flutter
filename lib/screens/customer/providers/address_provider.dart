import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];

  List<Address> get addresses => _addresses;

  AddressProvider() {
    _loadSampleAddresses();
  }

  void _loadSampleAddresses() {
    _addresses = [
      Address(
        id: '1',
        label: 'Home',
        street: '123 Main Street',
        area: 'Downtown',
        city: 'New York',
        pincode: '10001',
        latitude: 40.7128,
        longitude: -74.0060,
        isDefault: true,
      ),
      Address(
        id: '2',
        label: 'Work',
        street: '456 Office Park',
        area: 'Midtown',
        city: 'New York',
        pincode: '10018',
        latitude: 40.7549,
        longitude: -73.9840,
        isDefault: false,
      ),
    ];
    notifyListeners();
  }

  Address? getDefaultAddress() {
    try {
      return _addresses.firstWhere((addr) => addr.isDefault);
    } catch (e) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void addAddress(Address address) {
    // Create a new list with the new address
    List<Address> updatedAddresses = List.from(_addresses);

    if (address.isDefault) {
      // Set all existing addresses' isDefault to false
      updatedAddresses =
          updatedAddresses.map((addr) {
            return addr.copyWith(isDefault: false);
          }).toList();
    }

    updatedAddresses.add(address);
    _addresses = updatedAddresses;
    notifyListeners();
  }

  void updateAddress(Address updatedAddress) {
    final index = _addresses.indexWhere((addr) => addr.id == updatedAddress.id);
    if (index != -1) {
      List<Address> updatedAddresses = List.from(_addresses);

      if (updatedAddress.isDefault) {
        // Set all other addresses' isDefault to false
        updatedAddresses =
            updatedAddresses.map((addr) {
              if (addr.id == updatedAddress.id) {
                return updatedAddress;
              }
              return addr.copyWith(isDefault: false);
            }).toList();
      } else {
        updatedAddresses[index] = updatedAddress;
      }

      _addresses = updatedAddresses;
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    List<Address> updatedAddresses = List.from(_addresses);
    updatedAddresses.removeWhere((addr) => addr.id == id);

    // If there are addresses left and no default address, set the first as default
    if (updatedAddresses.isNotEmpty && getDefaultAddress() == null) {
      updatedAddresses[0] = updatedAddresses[0].copyWith(isDefault: true);
    }

    _addresses = updatedAddresses;
    notifyListeners();
  }

  void setDefaultAddress(String id) {
    List<Address> updatedAddresses =
        _addresses.map((addr) {
          return addr.copyWith(isDefault: addr.id == id);
        }).toList();

    _addresses = updatedAddresses;
    notifyListeners();
  }
}
