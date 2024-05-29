import 'package:finia_app/constants.dart';
import 'package:finia_app/controllers/MenuAppController.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/components/charts/financial_categories.chat.dart';
import 'package:finia_app/screens/dashboard/components/credit_card_horizontal.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Necesario para formatear los números

class DashBoardScreen2 extends StatefulWidget {
  @override
  State<DashBoardScreen2> createState() => _DashBoardScreen2();
}

class _DashBoardScreen2 extends State<DashBoardScreen2> {
  // Función para formatear números en pesos chilenos
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
      body: Stack(
        children: [
          // Fondo azul
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -3.0), // Ajusta el inicio del gradiente
                end: Alignment.bottomCenter,
                colors: [
                  logoCOLOR1,
                  logoCOLOR2,
                ],
              ),
            ),
            height: double.infinity,
          ),
          // Contenido principal
          SingleChildScrollView(
            primary: false,
            child: Column(
              children: [
                // Sección del encabezado
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 20,
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      if (!Responsive.isDesktop(context))
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed:
                              context.read<MenuAppController>().controlMenu,
                        ),
                    ],
                  ),
                ),
                // Sección del saldo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Balance Total:',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        formatCurrency(1842081),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildIndicator(
                            icon: Icons.arrow_upward,
                            title: 'Ingresado',
                            amount: 12000,
                            context: context,
                            isPositive: true,
                            themeProvider: themeProvider,
                          ),
                          SizedBox(width: 16),
                          buildIndicator(
                            icon: Icons.arrow_downward,
                            title: 'Gastado',
                            amount: 6000,
                            context: context,
                            isPositive: false,
                            themeProvider: themeProvider,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Widget con fondo blanco sobre el azul
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeProvider.getContainerBackgroundColor(),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Mis Productos',
                                style: TextStyle(
                                  fontSize: 20,
                                  color:themeProvider.getTitleColor(),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ],
                        ),
                        CreditCardHorizontalList(cards: myProducts),
                        SizedBox(height: defaultPadding),
                        BudgetedExpensesChart(),
                      ],
                    ),
                  ),
                ),
              ],
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
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: themeProvider.getCardColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
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
                    style: TextStyle(
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
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
