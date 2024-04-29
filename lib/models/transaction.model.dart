import 'package:flutter/material.dart';

class TransactionCreditCard {
  final DateTime date;
  final String description;
  final int inAmount;
  final int outAmount;
  final String currency;
  final Widget icon;

  TransactionCreditCard(
      {required this.date,
      required this.description,
      required this.inAmount,
      required this.outAmount,
      required this.currency,
      required this.icon});

  factory TransactionCreditCard.fromJson(Map<String, dynamic> json) {
    return TransactionCreditCard(
        date: DateTime.parse(json['date']),
        description: json['description'],
        inAmount: json['in'] as int,
        outAmount: json['out'] as int,
        currency: json['currency'],
        icon: json['icon']);
  }
}
