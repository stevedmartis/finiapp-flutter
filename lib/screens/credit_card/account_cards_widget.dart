import 'package:flutter/material.dart';
import 'package:finia_app/services/accounts_services.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAccountOptions(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: _getBackgroundDecoration(account.type),
        child: Stack(
          children: [
            // 🔹 Imagen del banco en el fondo
            Positioned(
              top: 10,
              right: 10,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  _getBankLogo(account.bankName),
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(account),
                const SizedBox(height: 12),
                Text(
                  account.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Saldo: ${formatCurrency(account.balance)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📌 Muestra opciones cuando el usuario toca la tarjeta
  void _showAccountOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text("Editar Cuenta"),
                onTap: () {
                  // Implementar acción de edición
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Eliminar Cuenta"),
                onTap: () {
                  // Implementar acción de eliminación
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// 📌 Obtiene el diseño de fondo con imagen del banco
  BoxDecoration _getBackgroundDecoration(String type) {
    return BoxDecoration(
      gradient: _getGradient(type),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  /// 📌 Obtiene la imagen del banco desde `assets/`
  String _getBankLogo(String bankName) {
    switch (bankName.toLowerCase()) {
      case "bank_chile":
        return "assets/images/banks/bank_chile.png";
      case "santander":
        return "assets/images/banks/bank_santander.png";
      case "scotiabank":
        return "assets/images/banks/bank_scotiabank.png";
      case "bancoestado":
        return "assets/images/banks/bank_estado.png";
      case "falabella":
        return "assets/images/banks/bank_falabella.png";
      default:
        return "assets/images/banks/bank_default.png";
    }
  }

  /// 📌 Obtiene el gradiente según el tipo de cuenta
  LinearGradient _getGradient(String type) {
    switch (type) {
      case "Cuenta Corriente":
        return const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Cuenta de Ahorro":
        return const LinearGradient(
          colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Efectivo":
        return const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case "Cuenta Vista":
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 59, 59, 59),
            Color.fromARGB(255, 8, 16, 30)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF607D8B), Color(0xFF455A64)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// 📌 Construye el encabezado con icono y tipo de cuenta
  Widget _buildHeader(Account account) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getAccountIcon(account.type),
        Text(
          account.type,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  /// 📌 Obtiene el icono según el tipo de cuenta
  Widget _getAccountIcon(String type) {
    switch (type) {
      case "Cuenta Corriente":
        return const Icon(Icons.account_balance, color: Colors.white);
      case "Cuenta de Ahorro":
        return const Icon(Icons.savings, color: Colors.white);
      case "Efectivo":
        return const Icon(Icons.money, color: Colors.white);
      default:
        return const Icon(Icons.account_balance_wallet, color: Colors.white);
    }
  }

  /// 📌 Formatea la moneda correctamente
  String formatCurrency(double amount) {
    return "\$${amount.toStringAsFixed(2)}";
  }
}
