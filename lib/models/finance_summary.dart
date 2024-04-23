import 'dart:convert';

class FinancialData {
  final List<CreditCardInfo> creditcards;
  final List<FinancialSummary> financialSummary;

  FinancialData({
    required this.creditcards,
    required this.financialSummary,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(
      creditcards: List<CreditCardInfo>.from(
          json['creditcards'].map((x) => CreditCardInfo.fromJson(x))),
      financialSummary: List<FinancialSummary>.from(
          json['financialSummary'].map((x) => FinancialSummary.fromJson(x))),
    );
  }

  static FinancialData fromJsonString(String str) {
    final jsonData = json.decode(str);
    return FinancialData.fromJson(jsonData);
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
  final double balance;
  final double totalIncome;
  final double totalExpenses;
  final double averageIncome;
  final double averageExpenses;
  final Map<String, List<Transaction>> categories;

  FinancialSummary({
    required this.accountId,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.averageIncome,
    required this.averageExpenses,
    required this.categories,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    var categoriesMap = Map<String, List<Transaction>>();
    json['categories'].forEach((key, dynamic value) {
      var transactionList = List<Transaction>.from(
          value.map((model) => Transaction.fromJson(model)));
      categoriesMap[key] = transactionList;
    });

    return FinancialSummary(
      accountId: json['accountId'] as int,
      balance: (json['balance'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      averageIncome: (json['averageIncome'] as num).toDouble(),
      averageExpenses: (json['averageExpenses'] as num).toDouble(),
      categories: categoriesMap,
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
