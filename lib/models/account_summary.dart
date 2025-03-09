import 'package:finia_app/models/finance_summary.dart';
import 'package:finia_app/services/accounts_services.dart';

class AccountSummary {
  final String id;
  final String name;
  final String bankName;
  final String type;
  final double balance;
  final double totalIncome;
  final double totalExpenses;

  AccountSummary({
    required this.id,
    required this.name,
    required this.bankName,
    required this.type,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  factory AccountSummary.fromAccountAndSummary(
      Account account, FinancialSummary summary) {
    return AccountSummary(
      id: account.id,
      name: account.name,
      bankName: account.bankName,
      type: account.type,
      balance: summary.balance, // ✅ Balance actualizado
      totalIncome: summary.totalIncome,
      totalExpenses: summary.totalExpenses,
    );
  }
}
