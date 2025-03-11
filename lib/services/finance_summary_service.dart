import 'dart:convert';

import 'package:finia_app/main.dart';
import 'package:finia_app/models/account_summary.dart';
import 'package:finia_app/models/finance_summary.dart';
import 'package:finia_app/screens/dashboard/dashboard_home.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinancialDataService with ChangeNotifier {
  FinancialData? _financialData;

  FinancialData? get financialData => _financialData;
  List<FinancialSummary> get financialSummary =>
      _financialData?.financialSummary ?? [];

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

  void syncTransactionsWithSummary(List<TransactionDto> transactions) {
    for (var transaction in transactions) {
      final accountId = int.tryParse(transaction.accountId) ?? 0;

      int index = _financialData!.financialSummary.indexWhere(
        (summary) => summary.accountId == accountId,
      );

      if (index != -1) {
        var currentSummary = _financialData!.financialSummary[index];

        // ✅ Acumular el saldo inicial y las transacciones
        currentSummary.balance += (transaction.type == "Ingreso"
            ? transaction.amount
            : -transaction.amount);

        currentSummary.totalIncome +=
            (transaction.type == "Ingreso" ? transaction.amount : 0);

        currentSummary.totalExpenses +=
            (transaction.type == "Gasto" ? transaction.amount : 0);

        _financialData!.financialSummary[index] = currentSummary;
      } else {
        // ✅ Si la cuenta no existe, crearla correctamente con el saldo inicial
        _financialData!.financialSummary.add(FinancialSummary(
          accountId: accountId,
          balance: transaction.type == "Ingreso"
              ? transaction.amount
              : -transaction.amount,
          totalIncome: transaction.type == "Ingreso" ? transaction.amount : 0,
          totalExpenses: transaction.type == "Gasto" ? transaction.amount : 0,
          averageIncome: 0,
          averageExpenses: 0,
          categories: {
            transaction.category: transaction.amount,
          },
        ));
      }
    }

    notifyListeners();
    saveData(); // ✅ Asegura que se actualice el estado
  }

  void addTransactionToSummary(TransactionDto transaction) {
    if (_financialData == null) {
      _financialData = FinancialData(
        creditcards: [],
        financialSummary: [],
      );
    }

    int index = _financialData!.financialSummary.indexWhere(
      (summary) => summary.accountId == int.tryParse(transaction.accountId),
    );

    if (index != -1) {
      var currentSummary = _financialData!.financialSummary[index];

      // ✅ Sumar el valor directamente a la categoría correspondiente
      currentSummary.categories[transaction.category] =
          (currentSummary.categories[transaction.category] ?? 0) +
              transaction.amount;

      // ✅ Sumar al balance y total correspondiente
      _financialData!.financialSummary[index] = FinancialSummary(
        accountId: currentSummary.accountId,
        balance: currentSummary.balance +
            (transaction.type == "Ingreso"
                ? transaction.amount
                : -transaction.amount), // ✅ SUMAR al balance actual
        totalIncome: currentSummary.totalIncome +
            (transaction.type == "Ingreso" ? transaction.amount : 0),
        totalExpenses: currentSummary.totalExpenses +
            (transaction.type == "Gasto" ? transaction.amount : 0),
        averageIncome: currentSummary.averageIncome,
        averageExpenses: currentSummary.averageExpenses,
        categories: currentSummary.categories,
      );
    } else {
      // ✅ Si la cuenta NO existe, crear una nueva entrada
      _financialData!.financialSummary.add(FinancialSummary(
        accountId: int.tryParse(transaction.accountId) ?? 0,
        balance: transaction.type == "Ingreso"
            ? transaction.amount
            : -transaction.amount,
        totalIncome: transaction.type == "Ingreso" ? transaction.amount : 0,
        totalExpenses: transaction.type == "Gasto" ? transaction.amount : 0,
        averageIncome: 0,
        averageExpenses: 0,
        categories: {
          transaction.category:
              transaction.amount, // ✅ Guardamos como valor numérico
        },
      ));
    }

    print("✅ Transacción agregada correctamente: ${transaction.amount}");

    // ✅ Recalcular el balance global para que sume el saldo inicial + nuevos valores
    calculateGlobalSummary();
    notifyListeners();
    saveData(); // ✅ Notificar cambios a la UI
  }

  double getTotalIngresado(AccountsProvider accountsProvider) {
    // Get initial balances
    double initialBalance = accountsProvider.accounts
        .map((account) => account.balance)
        .fold(0.0, (a, b) => a + b);

    // Add any transaction income
    double transactionIncome = 0;
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      transactionIncome = _financialData!.financialSummary
          .map((summary) => summary.totalIncome)
          .fold(0.0, (a, b) => a + b);
    }

    double totalIncome = initialBalance + transactionIncome;
    print("🟢 Total Income (Initial balance + Transactions): $totalIncome");
    return totalIncome;
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

  double getBalanceTotal(AccountsProvider accountsProvider) {
    // First, get the sum of all account balances
    double initialBalances = accountsProvider.accounts
        .map((account) => account.balance)
        .fold(0.0, (a, b) => a + b);

    // Next, if we have financial data, add transactions
    double transactionBalance = 0.0;
    if (_financialData != null && _financialData!.financialSummary.isNotEmpty) {
      transactionBalance =
          _financialData!.financialSummary.fold(0.0, (sum, summary) {
        return sum + summary.totalIncome - summary.totalExpenses;
      });
    }

    // Final balance is initial balances plus transaction activity
    double totalBalance = initialBalances + transactionBalance;

    print(
        "🟢 Balance total: $totalBalance = $initialBalances (initial) + $transactionBalance (transactions)");
    return totalBalance;
  }

  List<AccountWithSummary> getCombinedAccounts(
      List<Account> accounts, TransactionProvider transactionProvider) {
    return accounts.map((account) {
      final accountId = account.id;

      if (accountId.isEmpty) {
        print("⚠️ ID de cuenta inválido: ${account.id}");
      }

      // ✅ Obtener resumen financiero asociado a la cuenta
      final summary = _financialData?.financialSummary.firstWhere(
        (summary) => summary.accountId.toString() == accountId,
        orElse: () {
          print("⚠️ No se encontró resumen para ID: $accountId");
          return FinancialSummary(
            accountId: account.hashCode,
            balance: account.balance,
            totalIncome: 0,
            totalExpenses: 0,
            averageIncome: 0,
            averageExpenses: 0,
            categories: {},
          );
        },
      );

      // ✅ Calcular ingresos y gastos desde las transacciones
      double totalIncome =
          transactionProvider.getTotalIncomeForAccount(accountId) ?? 0;
      double totalExpenses =
          transactionProvider.getTotalExpensesForAccount(accountId) ?? 0;

      // ✅ Quitar summary.balance porque ya está reflejado en las transacciones
      double calculatedBalance = totalIncome - totalExpenses;

      print(
          "✅ Account ID: $accountId → Ingresos: $totalIncome | Gastos: $totalExpenses | Balance Calculado: $calculatedBalance");

      return AccountWithSummary(
        account: account.copyWith(
          // ✅ Usa el balance calculado desde las transacciones
          balance: calculatedBalance,
        ),
        summary: summary!,
        transactionProvider: transactionProvider, // ✅ Pasar transactionProvider
      );
    }).toList();
  }

  double getTotalDisponible(AccountsProvider accountsProvider) {
    // ✅ Sumar directamente el saldo inicial de las cuentas (sin duplicarlo)
    double initialBalance = accountsProvider.accounts
        .map((account) => account.balance)
        .fold(0.0, (a, b) => a + b);

    // ✅ Solo sumar ingresos desde las transacciones
    double totalIncome = _financialData?.financialSummary.isNotEmpty ?? false
        ? _financialData!.financialSummary
            .map((summary) => summary.totalIncome)
            .fold(0.0, (a, b) => a + b)
        : 0;

    // ✅ No sumamos el saldo inicial dos veces
    return initialBalance + totalIncome;
  }

  void calculateGlobalSummary() {
    if (_financialData == null) return;

    double totalIncome = 0;
    double totalExpenses = 0;

    for (var summary in _financialData!.financialSummary) {
      totalIncome += summary.totalIncome + (summary.categories['Ahorro'] ?? 0);
      totalExpenses += summary.totalExpenses;
    }

    if (totalIncome == 0 && totalExpenses == 0) {
      // Si no hay transacciones, basar el resumen en el saldo inicial
      totalIncome = _financialData!.financialSummary.isEmpty
          ? 0 // Si la lista está vacía, usar 0
          : _financialData!.financialSummary
              .map((summary) => summary.balance)
              .fold(0.0, (a, b) => a + b); // Usar fold en lugar de reduce
    }

    double totalBalance = totalIncome - totalExpenses;

    // Asignar el nuevo balance total al resumen
    _financialData = FinancialData(
      creditcards: _financialData!.creditcards,
      financialSummary: _financialData!.financialSummary.map((summary) {
        return FinancialSummary(
          accountId: summary.accountId,
          balance: summary.balance,
          totalIncome: summary.totalIncome,
          totalExpenses: summary.totalExpenses,
          averageIncome: summary.averageIncome,
          averageExpenses: summary.averageExpenses,
          categories: summary.categories,
        );
      }).toList(),
    );

    print("✅ [Global] Total Ingresos: $totalIncome");
    print("✅ [Global] Total Gastos: $totalExpenses");
    print("✅ [Global] Balance Total: $totalBalance");

    notifyListeners();
    // Aquí podrías llamar a saveData()
  }

  void addAccountToSummary(Account account) {
    if (_financialData == null) {
      _financialData = FinancialData(
        creditcards: [],
        financialSummary: [],
      );
    }

    int index = _financialData!.financialSummary
        .indexWhere((summary) => summary.accountId == int.tryParse(account.id));

    if (index == -1) {
      // Add new account entry correctly
      _financialData!.financialSummary.add(FinancialSummary(
        accountId: int.tryParse(account.id) ?? 0,
        balance: account.balance,
        totalIncome: 0, // Don't count initial balance as income
        totalExpenses: 0,
        averageIncome: 0,
        averageExpenses: 0,
        categories: {},
      ));
    } else {
      // Update existing account
      _financialData!.financialSummary[index] = FinancialSummary(
        accountId: int.tryParse(account.id) ?? 0,
        balance: account.balance,
        totalIncome: 0,
        totalExpenses: 0,
        averageIncome: 0,
        averageExpenses: 0,
        categories: {},
      );
    }

    notifyListeners();
    saveData();
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

// Add this to your FinancialDataService class
  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save your financial summary as JSON
    if (_financialData != null) {
      await prefs.setString('financial_data', jsonEncode(_financialData));
    }
  }

// And this method to load it
  Future<void> loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? data = prefs.getString('financial_data');
      if (data != null && data.isNotEmpty) {
        _financialData = FinancialData.fromJsonString(data);
        print("✅ Datos financieros cargados correctamente");
      } else {
        print("⚠️ No hay datos financieros guardados");
        _financialData ??= FinancialData(
          creditcards: [],
          financialSummary: [],
        );
      }
      notifyListeners();
    } catch (e) {
      print("❌ Error al cargar datos financieros: $e");
      _financialData ??= FinancialData(
        creditcards: [],
        financialSummary: [],
      );
      notifyListeners();
    }
  }
}
