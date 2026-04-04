import 'dart:ui';

import 'package:flutter/material.dart';

enum TransactionType { credit, debit }

enum TransactionStatus { success, pending, failed }

class Transaction {
  final String id;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final String description;
  final DateTime createdAt;
  final String? orderId;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.status,
    required this.description,
    required this.createdAt,
    this.orderId,
  });

  String get formattedAmount {
    final sign = type == TransactionType.credit ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  Color get amountColor {
    if (status == TransactionStatus.pending) return Colors.orange;
    return type == TransactionType.credit ? Colors.green : Colors.red;
  }
}
