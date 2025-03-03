import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Account {
  String name;
  String type;
  double balance;
  String bankName;

  Account({
    required this.name,
    required this.type,
    required this.balance,
    this.bankName = "bank_default",
  });

  // Convertir a JSON
  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "balance": balance,
        "bankName": bankName,
      };

  // Convertir desde JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json["name"],
      type: json["type"],
      balance: (json["balance"] as num).toDouble(),
      bankName: json["bankName"] ?? "bank_default",
    );
  }
}

class AccountsProvider extends ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  /// 🔹 Cargar cuentas desde `SharedPreferences`
  Future<void> loadAccounts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accountsString = prefs.getString("accounts");

    // 🔥 Primero intentamos cargar desde `SharedPreferences`
    if (accountsString != null &&
        accountsString.isNotEmpty &&
        accountsString != "[]") {
      List<dynamic> decodedList = jsonDecode(accountsString);
      if (decodedList.isNotEmpty) {
        _accounts = decodedList.map((item) => Account.fromJson(item)).toList();
        print("✅ Cuentas cargadas desde SharedPreferences: $_accounts");
        notifyListeners();
        return; // ⬅️ Si hay datos válidos, terminamos aquí y no llamamos a la API
      }
    }

    print(
        "⚠️ No hay cuentas guardadas localmente. Intentando cargar desde la API...");

    // 🔥 Ahora intentamos sincronizar con la API
    try {
      List<dynamic> apiResponse =
          await fetchAccountsFromServer(); // 🔥 Recibe List<dynamic>
      List<Account> apiData = apiResponse
          .map((item) => Account.fromJson(item))
          .toList(); // 🔄 Convertir a List<Account>

      if (apiData.isNotEmpty) {
        _accounts = apiData;
        await _saveAccounts(); // Guardamos en `SharedPreferences`
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
            'https://run.mocky.io/v3/e52fad95-20a8-424a-b252-fa5dc2e274ea'), // 🔹 Reemplaza con tu endpoint real
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

  /// 🔹 Agregar una nueva cuenta y guardarla en `SharedPreferences`
  Future<void> addAccount(Account newAccount) async {
    print(
        "🟢 ANTES de agregar cuenta: ${_accounts.map((e) => e.name).toList()}");

    _accounts.add(newAccount);
    notifyListeners();
    await _saveAccounts();

    print(
        "🟢 DESPUÉS de agregar cuenta: ${_accounts.map((e) => e.name).toList()}");
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
}
