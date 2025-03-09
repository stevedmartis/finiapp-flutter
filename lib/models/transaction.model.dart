import 'package:flutter/material.dart';

class TransactionCreditCard {
  final String id;
  final DateTime date;
  final String description;
  final String category;
  final int inAmount;
  final double outAmount;
  final String currency;
  final String accountId;
  final Widget icon;

  TransactionCreditCard({
    required this.id,
    required this.date,
    required this.description,
    required this.inAmount,
    required this.outAmount,
    required this.category,
    required this.currency,
    required this.icon,
    required this.accountId,
  });

  factory TransactionCreditCard.fromJson(Map<String, dynamic> json) {
    return TransactionCreditCard(
        id: json['icon'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        category: json['category'],
        inAmount: json['in'] as int,
        outAmount: json['out'] as double,
        currency: json['currency'],
        accountId: json['accountId'],
        icon: json['icon']);
  }
}
