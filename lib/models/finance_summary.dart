import 'dart:convert';

class FinancialData {
  final List<dynamic> creditcards;
  final List<FinancialSummary> financialSummary;

  FinancialData({
    required this.creditcards,
    required this.financialSummary,
  });

  // Añade este método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'creditcards': creditcards,
      'financialSummary':
          financialSummary.map((summary) => summary.toJson()).toList(),
    };
  }

  // Mantén el método from JSON que ya tienes
  factory FinancialData.fromJsonString(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return FinancialData(
      creditcards: data['creditcards'] ?? [],
      financialSummary: (data['financialSummary'] as List)
          .map((item) => FinancialSummary.fromJson(item))
          .toList(),
    );
  }
}

class CreditCardInfo {
  String name;
  String number;
  String currency;
  double total;
  double used;
  double available;

  CreditCardInfo({
    required this.name,
    required this.number,
    required this.currency,
    required this.total,
    required this.used,
    required this.available,
  });

  factory CreditCardInfo.fromJson(Map<String, dynamic> json) {
    return CreditCardInfo(
      name: json['name'],
      number: json['number'],
      currency: json['currency'],
      total: (json['total'] as num).toDouble(),
      used: (json['used'] as num).toDouble(),
      available: (json['available'] as num).toDouble(),
    );
  }
}

class FinancialSummary {
  final int accountId;
  double balance;
  double totalIncome;
  double totalExpenses;
  double averageIncome;
  double averageExpenses;
  Map<String, dynamic> categories;

  FinancialSummary({
    required this.accountId,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.averageIncome,
    required this.averageExpenses,
    required this.categories,
  });

  // Añade este método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'balance': balance,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'averageIncome': averageIncome,
      'averageExpenses': averageExpenses,
      'categories': categories,
    };
  }

  // Mantén el método fromJson que ya tienes
  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      accountId: json['accountId'],
      balance: json['balance']?.toDouble() ?? 0.0,
      totalIncome: json['totalIncome']?.toDouble() ?? 0.0,
      totalExpenses: json['totalExpenses']?.toDouble() ?? 0.0,
      averageIncome: json['averageIncome']?.toDouble() ?? 0.0,
      averageExpenses: json['averageExpenses']?.toDouble() ?? 0.0,
      categories: Map<String, dynamic>.from(json['categories'] ?? {}),
    );
  }
}

class Transaction {
  final String date;
  final String branch;
  final String description;
  final String docNumber;
  final double out;
  final double income;
  final double balance;
  final String category;
  final String id;

  Transaction({
    required this.date,
    required this.branch,
    required this.description,
    required this.docNumber,
    required this.out,
    required this.income,
    required this.balance,
    required this.category,
    required this.id,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'],
      branch: json['branch'],
      description: json['description'],
      docNumber: json['doc_number'],
      out: (json['out'] as num?)?.toDouble() ?? 0,
      income: (json['in'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      category: json['category'],
      id: json['_id'],
    );
  }
}
