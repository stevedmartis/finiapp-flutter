import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/transaction_widget.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import 'chart.dart';

class TransactionHistorialPage extends StatelessWidget {
  const TransactionHistorialPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        gradient: themeProvider.getGradientCard(),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Últimas Transacciones",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          SizedBox(height: defaultPadding),
          SizedBox(
            child: TransactionsWidget(
              transactions: myTransactions,
            ),
          ),
        ],
      ),
    );
  }
}
