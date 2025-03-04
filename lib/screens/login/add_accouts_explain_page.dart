import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/services/accounts_services.dart';
import 'package:finia_app/shared_preference/global_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/widgets/buttons/button_continue_loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../widgets/reouter_pages.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  AddAccountScreenState createState() => AddAccountScreenState();
}

class AddAccountScreenState extends State<AddAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  String _selectedAccountType = "Cuenta Corriente";
  bool _hasCompletedOnboarding = false; // 🔥 Nuevo flag
  List<Map<String, dynamic>> _accounts = []; // Lista de cuentas agregadas

  final List<String> _accountTypes = [
    "Cuenta Corriente",
    "Cuenta de Ahorro",
    "Cuenta Vista",
    "Tarjeta de Crédito",
    "Efectivo"
  ];

  double _needs = 0.0;
  double _wants = 0.0;
  double _savings = 0.0;
  bool _isEditing = false; // Evita bucles de actualización

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus(); // 🔥 Carga si ya completó el onboarding
  }

  /// ✅ Cargar `hasCompletedOnboarding` desde `SharedPreferences`
  Future<void> _loadOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool("hasCompletedOnboarding") ?? false;

    setState(() {
      _hasCompletedOnboarding = status;
    });

    debugPrint("🔵 Estado de onboarding: $_hasCompletedOnboarding");
  }

  void _onBalanceChanged(TextEditingController controller, String value) {
    if (_isEditing) return; // Evita llamadas múltiples innecesarias
    _isEditing = true;

    // Eliminar cualquier formato previo para obtener solo números
    String cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    double balance = double.tryParse(cleanValue) ?? 0;

    // Aplicar formateo en el TextField sin afectar cálculos
    String formattedValue = formatCurrency(balance);
    controller.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );

    // Asegurar que se actualice la distribución correctamente
    _calculateBudget(balance);

    _isEditing = false;
  }

  void _calculateBudget(double balance) {
    setState(() {
      _needs = balance * 0.50;
      _wants = balance * 0.30;
      _savings = balance * 0.20;
    });
  }

  void _addAccount() {
    String name = _accountNameController.text.trim();
    String cleanBalance =
        _balanceController.text.replaceAll(RegExp(r'[^\d]'), '');
    double balance = double.tryParse(cleanBalance) ?? 0;

    if (name.isEmpty || balance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor ingresa un nombre y saldo válido."),
        ),
      );
      return;
    }

    Account newAccount = Account(
      name: name,
      type: _selectedAccountType,
      balance: balance,
      bankName: 'bank_chile',
    );

    // 🔥 Imprimir datos en consola para verificar
    debugPrint(
        "🔵 Cuenta agregada: ${newAccount.name} - ${newAccount.balance}");

    // Guardar en el provider
    final accountsProvider =
        Provider.of<AccountsProvider>(context, listen: false);
    accountsProvider.addAccount(newAccount);

    // Verificar si la cuenta se agregó correctamente
    debugPrint(
        "📢 Total cuentas en Provider: ${accountsProvider.accounts.length}");

    // Limpiar campos
    setState(() {
      _accountNameController.clear();
      _balanceController.clear();
    });

    // 🔹 Si ya pasó el onboarding, guarda y cierra la pantalla
    if (_hasCompletedOnboarding) {
      Navigator.pop(context); // 🔙 Cierra la pantalla
    }
  }

  void _finishSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accounts", jsonEncode(_accounts));
    prefs.setDouble("totalBalance", _calculateTotalBalance());
    prefs.setDouble("totalNeeds", _calculateTotalNeeds());
    prefs.setDouble("totalWants", _calculateTotalWants());
    prefs.setDouble("totalSavings", _calculateTotalSavings());
    bool hasCompletedOnboarding =
        prefs.getBool("hasCompletedOnboarding") ?? false;

    await setOnboardingCompleted();

    if (!hasCompletedOnboarding) {
      // Primera vez → Marca como completado y muestra la animación
      await prefs.setBool("hasCompletedOnboarding", true);

      Navigator.pushReplacement(
        context,
        bubleSuccessRouter(myProducts), // ✅ Primera vez → Animación → Dashboard
      );
    } else {
      // Ya pasó la animación → Va directo al Dashboard
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      onChanged: (value) {
        if (isNumeric) {
          _onBalanceChanged(controller, value);
        }
        if (onChanged != null) {
          onChanged(value);
        }
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

// Función para construir el selector de tipo de cuenta
  Widget _buildDropdownField(String label, String value) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: darkCardBackground,
      style: const TextStyle(color: Colors.white),
      items: _accountTypes.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _selectedAccountType = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  double _calculateTotalBalance() {
    return _accounts.fold(
        0.0, (sum, account) => sum + (account["balance"] as double));
  }

  double _calculateTotalNeeds() {
    return _calculateTotalBalance() * 0.50;
  }

  double _calculateTotalWants() {
    return _calculateTotalBalance() * 0.30;
  }

  double _calculateTotalSavings() {
    return _calculateTotalBalance() * 0.20;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Agrega tus cuentas 📊",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.pop(context), // 🔙 Regresa a la pantalla anterior
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkCardBackground, darkCardBackground],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 0), // Aumenta el padding vertical
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: SvgPicture.asset("assets/images/wallet.svg"),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ingresa tus cuentas para empezar a administrar tu dinero automáticamente con la regla 50/30/20.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Nombre de la Cuenta", _accountNameController),
              const SizedBox(height: 15),
              _buildDropdownField("Tipo de Cuenta", _selectedAccountType),
              const SizedBox(height: 15),
              _buildTextField("Saldo Inicial", _balanceController,
                  isNumeric: true, onChanged: (value) {
                double balance =
                    double.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ??
                        0;
                _calculateBudget(balance); // Llamar con un `double` corregido
              }),
              const SizedBox(height: 20),
              _buildBudgetDistribution(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        logoCOLOR1, // Usa el color principal de la app
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _addAccount,
                  child: const Text(
                    "Agregar Cuenta",
                    style: TextStyle(
                      color: Colors.white, // Asegura buen contraste
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!_hasCompletedOnboarding)
                Consumer<AccountsProvider>(
                  builder: (context, accountsProvider, child) {
                    return accountsProvider.accounts.isNotEmpty
                        ? _buildAccountsList()
                        : const SizedBox();
                  },
                ),
              const SizedBox(height: 30),
              _accounts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Colors.white38),
                        const SizedBox(height: 10),
                        const Text("Resumen Total",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 5),
                        _buildBudgetRow("Total en Cuentas",
                            formatCurrency(_calculateTotalBalance())),
                        _buildBudgetRow("🟢 Necesidades (50%)",
                            formatCurrency(_calculateTotalNeeds())),
                        _buildBudgetRow("🔵 Deseos (30%)",
                            formatCurrency(_calculateTotalWants())),
                        _buildBudgetRow("🟠 Ahorro (20%)",
                            formatCurrency(_calculateTotalSavings())),
                        const SizedBox(height: 20),
                      ],
                    )
                  : const SizedBox(),
              Consumer<AccountsProvider>(
                builder: (context, accountsProvider, child) {
                  return (!_hasCompletedOnboarding &&
                          accountsProvider.accounts.isNotEmpty)
                      ? SizedBox(
                          width: double.infinity,
                          child: IconOrSpinnerButton(
                            loading: false,
                            showIcon: true,
                            onPressed: _finishSetup,
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountsList() {
    return Consumer<AccountsProvider>(
      builder: (context, accountsProvider, child) {
        if (accountsProvider.accounts.isEmpty) {
          return const Center(
            child: Text(
              "No tienes cuentas agregadas.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }
        return Column(
          children: accountsProvider.accounts.map((account) {
            return Card(
              color: Colors.white10,
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(account.name,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(
                    "${account.type} - Saldo: ${formatCurrency(account.balance)}",
                    style: const TextStyle(color: Colors.white70)),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String formatCurrency(double amount) {
    final NumberFormat format =
        NumberFormat.currency(locale: 'es_CL', symbol: '');
    String formatted = format.format(amount);
    formatted = formatted
        .replaceAll('\$', '')
        .replaceAll(',', ''); // Eliminar símbolo y separador de miles
    return '\$${formatted.substring(0, formatted.length - 3)}';
  }

  Widget _buildBudgetDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Distribución del saldo:",
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 10),
        _buildBudgetRow("🟢 50% Necesidades", formatCurrency(_needs)),
        _buildBudgetRow("🔵 30% Deseos", formatCurrency(_wants)),
        _buildBudgetRow("🟠 20% Ahorro", formatCurrency(_savings)),
      ],
    );
  }

  Widget _buildBudgetRow(String title, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 16)),
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }
}
