import 'package:finia_app/models/finance_summary.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialDataService with ChangeNotifier {
  FinancialData? _financialData;

  FinancialData? get financialData => _financialData;

  FinancialDataService() {
    _financialData ??= FinancialData(
      creditcards: [],
      financialSummary: [],
    );
  }

  void initializeData() {
    _financialData ??= FinancialData(
      creditcards: [],
      financialSummary: [],
    );
    notifyListeners(); // ✅ Para actualizar el UI si es necesario
  }

  /// 🔹 Actualiza los datos financieros y notifica a los widgets que escuchan
  void updateFinancialData(FinancialData newData) {
    _financialData = newData;
    notifyListeners();
  }

  /// 🔹 Método para obtener el resumen desde el backend
  Future<void> fetchFinancialSummary(String userId) async {
    var url = Uri.parse('http://localhost:3000/finance/summary/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final parsedData = FinancialData.fromJsonString(response.body);
          updateFinancialData(parsedData);
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception(
            'Failed to load financial summary with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load financial summary: $e');
    }
  }

  void addTransactionToSummary(TransactionDto transaction) {
    if (_financialData == null) {
      _financialData = FinancialData(
        creditcards: [],
        financialSummary: [],
      );
    }

    int index = _financialData!.financialSummary.indexWhere(
        (summary) => summary.accountId == int.tryParse(transaction.accountId));

    if (index != -1) {
      // ✅ Si la cuenta ya existe, SUMA al total
      _financialData!.financialSummary[index] = FinancialSummary(
        accountId: _financialData!.financialSummary[index].accountId,
        balance: _financialData!.financialSummary[index].balance +
            (transaction.type == "Ingreso"
                ? transaction.amount
                : -transaction.amount), // ✅ SUMA o RESTA
        totalIncome: _financialData!.financialSummary[index].totalIncome +
            (transaction.type == "Ingreso" ? transaction.amount : 0),
        totalExpenses: _financialData!.financialSummary[index].totalExpenses +
            (transaction.type == "Gasto" ? transaction.amount : 0),
        averageIncome: _financialData!.financialSummary[index].averageIncome,
        averageExpenses:
            _financialData!.financialSummary[index].averageExpenses,
        categories: _financialData!.financialSummary[index].categories,
      );
    } else {
      // ✅ Si la cuenta NO existe, crea una nueva entrada
      _financialData!.financialSummary.add(FinancialSummary(
        accountId: int.tryParse(transaction.accountId) ?? 0,
        balance: transaction.type == "Ingreso"
            ? transaction.amount
            : -transaction.amount,
        totalIncome: transaction.type == "Ingreso" ? transaction.amount : 0,
        totalExpenses: transaction.type == "Gasto" ? transaction.amount : 0,
        averageIncome: 0,
        averageExpenses: 0,
        categories: {},
      ));
    }

    print("✅ Transacción agregada correctamente: ${transaction.amount}");

    notifyListeners(); // ✅ Esto actualizará la UI
  }

  /// 🔥 **Calcula automáticamente ingresos y gastos desde el modelo**
  double getTotalIngresado() {
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      // ✅ Sumar todos los ingresos desde `FinancialSummary`
      return _financialData!.financialSummary
          .map((summary) => summary.totalIncome)
          .reduce((a, b) => a + b);
    }
    return 0;
  }

  double getTotalGastado() {
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      // ✅ Sumar todos los gastos desde `FinancialSummary`
      return _financialData!.financialSummary
          .map((summary) => summary.totalExpenses)
          .reduce((a, b) => a + b);
    }
    return 0;
  }

  double getBalanceTotal() {
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      // ✅ Balance = ingresos - gastos
      return getTotalIngresado() - getTotalGastado();
    }
    return 0;
  }

  void calculateGlobalSummary() {
    if (_financialData == null) return;

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var summary in _financialData!.financialSummary) {
      totalIncome += summary.totalIncome;
      totalExpenses += summary.totalExpenses;
    }

    double totalBalance = totalIncome - totalExpenses;

    print("✅ [Global] Total Ingresos: $totalIncome");
    print("✅ [Global] Total Gastos: $totalExpenses");
    print("✅ [Global] Balance Total: $totalBalance");

    // ✅ Crear una nueva lista para que `notifyListeners()` funcione
    _financialData = FinancialData(
      creditcards: _financialData!.creditcards,
      financialSummary: _financialData!.financialSummary.map((summary) {
        return FinancialSummary(
          accountId: summary.accountId,
          balance: summary.totalIncome -
              summary.totalExpenses, // ✅ Refleja el balance real
          totalIncome: summary.totalIncome,
          totalExpenses: summary.totalExpenses,
          averageIncome: summary.averageIncome,
          averageExpenses: summary.averageExpenses,
          categories: summary.categories,
        );
      }).toList(),
    );

    notifyListeners(); // ✅ Esto actualizará el UI automáticamente
  }

  void addAccountToSummary(Account account) {
    if (_financialData == null) {
      _financialData = FinancialData(
        creditcards: [],
        financialSummary: [],
      );
    }

    // ✅ Verifica que la cuenta no exista ya en el summary
    int index = _financialData!.financialSummary
        .indexWhere((summary) => summary.accountId == int.tryParse(account.id));

    if (index == -1) {
      // ✅ Si no existe, agrega una nueva entrada
      _financialData!.financialSummary.add(FinancialSummary(
        accountId: int.tryParse(account.id) ?? 0,
        balance: account.balance, // ✅ Saldo inicial
        totalIncome: account.balance, // ✅ Añadir saldo inicial como ingreso
        totalExpenses: 0, // ✅ No hay gastos aún
        averageIncome: 0,
        averageExpenses: 0,
        categories: {},
      ));
    } else {
      // ✅ Si ya existe, actualiza el saldo inicial
      _financialData!.financialSummary[index] = FinancialSummary(
        accountId: int.tryParse(account.id) ?? 0,
        balance: account.balance,
        totalIncome: account.balance, // ✅ Añadir saldo inicial como ingreso
        totalExpenses: 0,
        averageIncome: 0,
        averageExpenses: 0,
        categories: {},
      );
    }

    print(
        "✅ Cuenta añadida a summary: ${account.id} con saldo ${account.balance}");

    notifyListeners(); // 🔥 Notifica a la UI
  }

  void calculateSummaryForAccount(String accountId) {
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      final updatedSummary = _financialData!.financialSummary.map((summary) {
        if (summary.accountId == accountId) {
          // ✅ No reseteamos los valores → Solo sumamos las nuevas transacciones
          double totalIncome = summary.totalIncome;
          double totalExpenses = summary.totalExpenses;

          double updatedBalance = totalIncome - totalExpenses;

          print("✅ [Cuenta $accountId] Total Ingresos: ${summary.totalIncome}");
          print("✅ [Cuenta $accountId] Total Gastos: ${summary.totalExpenses}");
          print("✅ [Cuenta $accountId] Balance: $updatedBalance");

          return FinancialSummary(
            accountId: summary.accountId,
            balance: updatedBalance,
            totalIncome: totalIncome,
            totalExpenses: totalExpenses,
            averageIncome: summary.averageIncome,
            averageExpenses: summary.averageExpenses,
            categories: summary.categories,
          );
        }
        return summary;
      }).toList();

      // ✅ Crear una nueva instancia para actualizar los datos
      _financialData = FinancialData(
        creditcards: _financialData!.creditcards,
        financialSummary: updatedSummary,
      );

      notifyListeners(); // ✅ Esto notificará al widget automáticamente
    }
  }
}
