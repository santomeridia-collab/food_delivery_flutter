import 'package:flutter/material.dart';
import 'package:food_delivery/screens/customer/models/transaction_model.dart';

class WalletProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  WalletProvider() {
    _loadSampleTransactions();
  }

  void _loadSampleTransactions() {
    _transactions = [
      Transaction(
        id: '1',
        amount: 25.50,
        type: TransactionType.credit,
        status: TransactionStatus.success,
        description: 'Added money to wallet',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: '2',
        amount: 15.99,
        type: TransactionType.debit,
        status: TransactionStatus.success,
        description: 'Order #ORD12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        orderId: 'ORD12345678',
      ),
      Transaction(
        id: '3',
        amount: 10.00,
        type: TransactionType.credit,
        status: TransactionStatus.success,
        description: 'Referral bonus',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  void addTransaction({
    required double amount,
    required TransactionType type,
    required String description,
    String? orderId,
  }) {
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      type: type,
      status: TransactionStatus.success,
      description: description,
      createdAt: DateTime.now(),
      orderId: orderId,
    );
    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
