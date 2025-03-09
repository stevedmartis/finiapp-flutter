import 'package:finia_app/screens/dashboard/components/transaction_widget.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'chart.dart';

class TransactionHistorialPage extends StatelessWidget {
  final String accountId;

  const TransactionHistorialPage({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        gradient: themeProvider.getGradientCard(),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Últimas Transacciones",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: defaultPadding),
          const Chart(), // ✅ Si deseas filtrar el gráfico por cuenta, ajusta esta parte
          const SizedBox(height: defaultPadding),

          // ✅ Pasar las transacciones filtradas por `accountId`
          TransactionsWidget(
            accountId: accountId,
          ),
        ],
      ),
    );
  }
}
