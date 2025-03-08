import 'package:finia_app/screens/credit_card/account_cards_widget.dart';
import 'package:finia_app/screens/dashboard/components/header_custom.dart';
import 'package:finia_app/screens/providers/theme_provider.dart';
import 'package:finia_app/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finia_app/constants.dart';
import 'package:finia_app/responsive.dart';
import 'package:finia_app/screens/dashboard/components/transactions_list.page.dart';
import 'package:finia_app/services/auth_service.dart';
import '../../services/accounts_services.dart';

class CreditCardDetail extends StatefulWidget {
  final Account card;

  const CreditCardDetail({super.key, required this.card});

  @override
  CreditCardDetailState createState() => CreditCardDetailState();
}

class CreditCardDetailState extends State<CreditCardDetail> {
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);
    var tagActual = authService.cardsHero;
    final heroTag = '$tagActual-${widget.card.name}';
    final currentTheme = Provider.of<ThemeProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final double totalIncome = transactionProvider.transactions
        .where((t) => t.type == "Ingreso")
        .fold(0.0, (sum, t) => sum + t.amount);

    final double totalExpense = transactionProvider.transactions
        .where((t) => t.type == "Gasto")
        .fold(0.0, (sum, t) => sum + t.amount);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: logoAppBarCOLOR,
        title: Text('Cuenta: ${widget.card.name}'),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Hero(
              tag: heroTag,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: AccountCard(account: widget.card),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildCurrentBalance(
                    currentTheme,
                    widget.card.balance,
                    totalIncome,
                    totalExpense,
                  ),
                  const SizedBox(height: defaultPadding),
                  /*  InfoCardsAmounts(
                    fileInfo: widget.card.fileInfo,
                  ), */
                  if (Responsive.isMobile(context))
                    const TransactionHistorialPage(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBalance(ThemeProvider themeProvider, double available,
      double totalIncome, double totalExpense) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 0.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              gradient: themeProvider.getGradientCard(),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Saldo disponible
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatCurrency(available),
                          style: TextStyle(
                            color: themeProvider.getSubtitleColor(),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🔹 Ingresos y Gastos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ✅ Ingresos
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_upward,
                          color: Colors.greenAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "+\$${totalIncome.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    // ✅ Gastos
                    Row(
                      children: [
                        const Icon(
                          Icons.arrow_downward,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "-\$${totalExpense.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
