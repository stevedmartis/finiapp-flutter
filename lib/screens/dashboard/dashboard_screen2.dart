import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/menu_app_controller.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/credit_card_horizontal.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashBoardScreen2 extends StatefulWidget {
  const DashBoardScreen2({super.key});
  @override
  State<DashBoardScreen2> createState() => _DashBoardScreen2();
}

class _DashBoardScreen2 extends State<DashBoardScreen2> {
  late MenuAppController menuAppController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    menuAppController = Provider.of<MenuAppController>(context);
  }

  String formatCurrency(double amount) {
    final NumberFormat format =
        NumberFormat.currency(locale: 'es_CL', symbol: '');
    String formatted = format.format(amount);
    formatted = formatted
        .replaceAll('\$', '')
        .replaceAll(',', ''); // Eliminar símbolo y separador de miles
    return '\$${formatted}'.substring(0, formatted.length - 2);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeProvider.getBackgroundColor(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Mis Productos',
                            style: TextStyle(
                              fontSize: 20,
                              color: themeProvider.getTitleColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    CreditCardHorizontalList(cards: myProducts),
                    const SizedBox(height: defaultPadding),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BudgetedExpensesChart(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator({
    required IconData icon,
    required String title,
    required double amount,
    required BuildContext context,
    required bool isPositive,
    required ThemeProvider themeProvider,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: themeProvider.getBackgroundColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isPositive ? Colors.green : Colors.red,
                size: 30,
              ),
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    formatCurrency(amount),
                    style: TextStyle(
                      fontSize: 20,
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
