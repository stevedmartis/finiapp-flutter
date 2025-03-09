import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionsDashList extends StatelessWidget {
  const TransactionsDashList({super.key});
  @override
  Widget build(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: true);

    // ✅ Si no hay transacciones, mostramos mensaje vacío
    if (transactionProvider.transactions.isEmpty) {
      return const Center(
        child: Text(
          'Tus movimientos apareceran aquí.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    // ✅ Obtener la última transacción
    final latestTransaction = transactionProvider.transactions.last;

    // ✅ Mapeo de iconos por categoría
    final Map<String, IconData> categoryIcons = {
      "Comida": Icons.fastfood,
      "Transporte": Icons.directions_car,
      "Salud": Icons.health_and_safety,
      "Ocio": Icons.movie,
      "Educación": Icons.school,
      "Gasolina": Icons.local_gas_station,
      "Uber / Taxi": Icons.directions_car_filled,
      "Streaming": Icons.tv,
      "Hogar": Icons.home,
      "Mascota": Icons.pets,
      "Ropa": Icons.shopping_bag,
      "Videojuegos": Icons.sports_esports,
      "Gimnasio": Icons.fitness_center,
      "Regalos": Icons.card_giftcard,
      "Viajes": Icons.flight_takeoff,
      "Inversión": Icons.savings,
    };

    final IconData icon =
        categoryIcons[latestTransaction.category] ?? Icons.help_outline;
    final bool isIncome = latestTransaction.type == "Ingreso";

    return GestureDetector(
      onTap: () {
        print("Abriendo detalles de la transacción...");
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF1C1C1E),
              Color(0xFF2C2C2E),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 Icono de la categoría
            CircleAvatar(
              backgroundColor: isIncome ? Colors.green[400] : Colors.red[400],
              radius: 24,
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),

            const SizedBox(width: 12),

            // 🔹 Descripción y monto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    latestTransaction.category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd-MM-yyyy').format(
                      DateFormat('dd-MM-yyyy').parse(latestTransaction.date),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Monto
            Text(
              "${isIncome ? '+' : '-'} ${formatCurrency(latestTransaction.amount)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    isIncome ? Colors.greenAccent[400] : Colors.redAccent[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
