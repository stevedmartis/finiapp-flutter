import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Account {
  String name;
  String type;
  double balance;
  String bankName;
  String id;

  Account({
    required this.name,
    required this.type,
    required this.balance,
    required this.id,
    this.bankName = "bank_default",
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "balance": balance,
        "bankName": bankName,
        "id": id,
      };

  // Convertir desde JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json["id"],
      name: json["name"],
      type: json["type"],
      balance: (json["balance"] as num).toDouble(),
      bankName: json["bankName"] ?? "bank_default",
    );
  }

  Account copyWith({
    String? id,
    String? name,
    double? balance,
    String? bankName,
    String? type,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      bankName: bankName ?? this.bankName,
      type: type ?? this.type,
    );
  }
}

class AccountsProvider extends ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  String? _currentAccountId;

  String? get currentAccountId => _currentAccountId;

  Account? getCurrentAccount() {
    if (_currentAccountId == null) return null;
    for (var account in _accounts) {
      if (account.id == _currentAccountId) {
        return account;
      }
    }
    return null; // ✅ Devuelve null directamente
  }

  void setCurrentAccountId(String id) {
    _currentAccountId = id;
    notifyListeners(); // 🔥 Notifica a los widgets que escuchan
  }

  double getTotalIncome() {
    // Como en tu modelo no hay un campo específico para ingresos,
    // asumimos que queremos el balance total de todas las cuentas
    return _accounts.fold(0, (sum, account) => sum + account.balance);
  }

  // Obtener deuda total (asumiendo que las deudas son balances negativos o cuentas de tipo "debt")
  double getTotalDebt() {
    // Enfoque 1: Si las deudas son representadas por balances negativos
    // return _accounts.fold(0, (sum, account) =>
    //   sum + (account.balance < 0 ? -account.balance : 0));

    // Enfoque 2: Si tienes un tipo de cuenta específico para deudas
    return _accounts
        .where((account) =>
            account.type.toLowerCase() == "debt" ||
            account.type.toLowerCase() == "credito" ||
            account.type.toLowerCase() == "préstamo")
        .fold(0, (sum, account) => sum + account.balance);
  }

  void updateAccountBalance(String accountId, double newBalance) {
    int index = _accounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      _accounts[index] = _accounts[index].copyWith(balance: newBalance);
      notifyListeners(); // ✅ Forzar actualización en la UI
    }
  }

  /// 🔹 Cargar cuentas desde `SharedPreferences`
  Future<void> loadAccounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accountsString = prefs.getString("accounts");

    if (accountsString != null && accountsString.isNotEmpty) {
      List<dynamic> decodedList = jsonDecode(accountsString);
      if (decodedList.isNotEmpty) {
        _accounts = decodedList.map((item) => Account.fromJson(item)).toList();

        // ✅ Si hay cuentas, asignar la primera como la cuenta activa
        if (_accounts.isNotEmpty) {
          _currentAccountId = _accounts.first.id; // ✅ ASIGNA EL VALOR INICIAL
        }

        _calculateTotalBalance(); // 🔥 Actualizar el balance total
        notifyListeners();
      }
    }

    print(
        "⚠️ No hay cuentas guardadas localmente. Intentando cargar desde la API...");

    // 🔥 Ahora intentamos sincronizar con la API
    try {
      List<dynamic> apiResponse = await fetchAccountsFromServer();
      List<Account> apiData =
          apiResponse.map((item) => Account.fromJson(item)).toList();

      if (apiData.isNotEmpty) {
        _accounts = apiData;
        await _saveAccounts(); // Guardamos en `SharedPreferences`
        _calculateTotalBalance(); // 🔥 Actualizar balance total después de cargar desde la API
        print("✅ Cuentas cargadas desde la API y guardadas localmente.");
      } else {
        print("⚠️ La API no devolvió cuentas.");
      }
    } catch (e) {
      print("❌ Error al obtener datos desde la API: $e");
    }

    notifyListeners();
  }

  Future<List<dynamic>> fetchAccountsFromServer() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://tu-api.com/cuentas'), // 🔹 Reemplaza con tu endpoint real
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer TOKEN_DEL_USUARIO' // 🔥 Agrega autenticación si es necesario
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print("✅ Cuentas recibidas desde la API: $data");
        return data;
      } else {
        print("❌ Error al obtener cuentas: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Error en la petición HTTP: $e");
      return [];
    }
  }

  double _totalBalance = 0.0;

  double get totalBalance => _totalBalance;

  /// 🔥 Calcula el balance total sumando el saldo de todas las cuentas
  void _calculateTotalBalance() {
    _totalBalance =
        _accounts.fold(0.0, (sum, account) => sum + account.balance);
    print("🔵 Balance Total Actualizado: $_totalBalance");
    notifyListeners();
  }

  Future<void> deleteAccount(Account account) async {
    _accounts.remove(account);
    _calculateTotalBalance(); // 🔥 Actualizar balance total después de eliminar cuenta
    await _saveAccounts();
    notifyListeners();
  }

  double getTotalBalance() {
    if (_accounts.isNotEmpty) {
      if (_accounts.length == 1) {
        // ✅ Si solo hay una cuenta y no hay transacciones → Devuelve el saldo directamente
        return _accounts.first.balance;
      } else {
        // ✅ Si hay múltiples cuentas → Sumar todos los saldos
        return _accounts.fold(0.0, (sum, account) => sum + account.balance);
      }
    }
    return 0;
  }

  /// 🔹 Agregar una nueva cuenta y guardarla en `SharedPreferences`
  Future<void> addAccount(Account newAccount) async {
    _accounts.add(newAccount);
    _calculateTotalBalance(); // 🔥 Actualizar balance total después de agregar cuenta
    await _saveAccounts();
    notifyListeners();
  }

  /// 🔹 Guardar cuentas en `SharedPreferences`
  Future<void> _saveAccounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_accounts.map((e) => e.toJson()).toList());

    print(
        "📌 ANTES de guardar: ${prefs.getString("accounts")}"); // 🔍 Debug antes de guardar
    await prefs.setString("accounts", encodedData);
    print(
        "✅ DESPUÉS de guardar: ${prefs.getString("accounts")}"); // 🔍 Debug después de guardar
  }

  Future<void> clearAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('accounts'); // ✅ Eliminar todas las transacciones guardadas
    print("✅ accounts eliminadas correctamente.");
  }
}
