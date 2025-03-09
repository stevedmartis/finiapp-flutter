import 'package:finia_app/constants.dart';
import 'package:finia_app/screens/credit_card/credit_card_slider.dart';
import 'package:finia_app/screens/credit_card/credit_card_widget.dart';
import 'package:finia_app/screens/dashboard/dashboard_home.dart';
import 'package:finia_app/services/accounts_services.dart';

import 'package:finia_app/services/auth_service.dart';
import 'package:finia_app/services/finance_summary_service.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCardDemo extends StatefulWidget {
  const CreditCardDemo({super.key});
  @override
  CreditCardDemoState createState() => CreditCardDemoState();
}

class CreditCardDemoState extends State<CreditCardDemo> {
  int _currentCardIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    int initialIndex = Provider.of<AuthService>(context, listen: false).index;

    super.initState();
    _pageController =
        PageController(initialPage: initialIndex, viewportFraction: 0.3);

    _currentCardIndex = initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onCardClicked(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var isScreenWide = MediaQuery.of(context).size.width > 600;

    return Consumer3<AccountsProvider, FinancialDataService,
        TransactionProvider>(
      builder:
          (context, accountsProvider, financialData, transactionProvider, _) {
        // ✅ Combinar cuentas + resumen financiero + saldo dinámico desde TransactionProvider
        final combinedAccounts = financialData.getCombinedAccounts(
          accountsProvider.accounts,
          Provider.of<TransactionProvider>(context,
              listen: false), // ✅ Pasar directamente
        );

        if (combinedAccounts.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Credit Cards')),
            body: const Center(child: Text('No hay tarjetas disponibles')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: logoAppBarCOLOR,
            title: const Text('Credit Cards'),
          ),
          body: isScreenWide
              ? Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(0.0),
                        height: MediaQuery.of(context).size.height * 0.235,
                        child: CreditCardSlider(
                          combinedAccounts, // ✅ Ahora el saldo está actualizado
                          pageController: _pageController,
                          initialCard: _currentCardIndex,
                          onCardClicked: _onCardClicked,
                          isVertical: true,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: CreditCardDetailWidget(
                          key: ValueKey(_currentCardIndex),
                          card: combinedAccounts[_currentCardIndex],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(0.0),
                  height: MediaQuery.of(context).size.height * 0.235,
                  child: CreditCardSlider(
                    combinedAccounts, // ✅ Ahora el saldo está actualizado
                    pageController: _pageController,
                    initialCard: _currentCardIndex,
                    onCardClicked: _onCardClicked,
                    isVertical: true,
                  ),
                ),
        );
      },
    );
  }
}

class CreditCardDetailWidget extends StatelessWidget {
  final AccountWithSummary card;

  const CreditCardDetailWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRect(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... Otros detalles de la tarjeta
            ],
          ),
        ),
      ),
    );
  }
}
