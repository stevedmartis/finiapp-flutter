import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TransactionDto {
  final String id;
  final String type;
  final double amount;
  final String category;
  final String date;
  final String note;
  final String accountId;

  TransactionDto({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
    required this.accountId,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountId": accountId,
        "type": type,
        "amount": amount,
        "category": category,
        "date": date,
        "note": note,
      };

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json["id"],
      accountId: json["accountId"],
      type: json["type"],
      amount: (json["amount"] as num).toDouble(),
      category: json["category"],
      date: json["date"],
      note: json["note"] ?? "",
    );
  }
}

class TransactionProvider extends ChangeNotifier {
  List<TransactionDto> _transactions = [];

  List<TransactionDto> get transactions => _transactions;

  /// 🔹 Cargar transacciones desde `SharedPreferences`
  Future<void> loadTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? transactionsString = prefs.getString("transactions");

    if (transactionsString != null && transactionsString.isNotEmpty) {
      List<dynamic> decodedList = jsonDecode(transactionsString);
      _transactions =
          decodedList.map((item) => TransactionDto.fromJson(item)).toList();
      notifyListeners();
    }
  }

  /// 🔹 Agregar una nueva transacción y guardarla en `SharedPreferences`
  Future<void> addTransaction(TransactionDto newTransaction) async {
    _transactions.add(newTransaction);
    await _saveTransactions();
    notifyListeners();
  }

  /// 🔹 Guardar transacciones en `SharedPreferences`
  Future<void> _saveTransactions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_transactions.map((e) => e.toJson()).toList());
    await prefs.setString("transactions", encodedData);
  }

  // ✅ Obtener transacciones de una cuenta específica
  List<TransactionDto> getTransactionsByAccountId(String accountId) {
    return _transactions
        .where((transaction) => transaction.accountId == accountId)
        .toList();
  }

  Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('transactions'); // ✅ Eliminar todas las transacciones guardadas
    print("✅ Transacciones eliminadas correctamente.");
  }
}
